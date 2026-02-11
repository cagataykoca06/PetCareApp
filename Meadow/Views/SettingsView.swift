//
//  SettingsView.swift
//  Meadow
//
//  Created on [Date]
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @EnvironmentObject var container: AppContainer
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]
    @Query private var pets: [Pet]
    @State private var notificationsEnabled = false
    @State private var showingPermissionAlert = false
    
    // Litter reminder states
    @State private var litterRemindersEnabled = false
    @State private var litterReminderTime = Date()
    @State private var litterThresholdDays = 3
    @State private var playfulEmojiEnabled = true
    
    private let thresholdOptions = [2, 3, 4, 5, 7]
    
    var userProfile: UserProfile? {
        profiles.first
    }
    
    var body: some View {
        List {
            Section("Notifications") {
                Toggle("Daily Reminders", isOn: Binding(
                    get: { notificationsEnabled },
                    set: { newValue in
                        notificationsEnabled = newValue
                        handleNotificationToggle(newValue)
                    }
                ))
                
                if notificationsEnabled {
                    Text("You'll receive a reminder each evening if you haven't logged care events for the day.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Section {
                Toggle("Litter Cleaning Reminders", isOn: Binding(
                    get: { litterRemindersEnabled },
                    set: { newValue in
                        litterRemindersEnabled = newValue
                        handleLitterReminderToggle(newValue)
                    }
                ))
                
                if litterRemindersEnabled {
                    DatePicker("Reminder Time", selection: $litterReminderTime, displayedComponents: .hourAndMinute)
                        .onChange(of: litterReminderTime) { _, _ in
                            saveLitterSettings()
                        }
                    
                    Picker("Remind after", selection: $litterThresholdDays) {
                        ForEach(thresholdOptions, id: \.self) { days in
                            Text("\(days) days").tag(days)
                        }
                    }
                    .onChange(of: litterThresholdDays) { _, _ in
                        saveLitterSettings()
                    }
                    
                    Toggle("Playful Emoji 💩", isOn: $playfulEmojiEnabled)
                        .onChange(of: playfulEmojiEnabled) { _, _ in
                            saveLitterSettings()
                        }
                    
                    Text("Get reminded if you haven't logged a litter clean for your pet.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } header: {
                Label("Litter Reminders", systemImage: "tree.fill")
            }
            
            Section("About") {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.secondary)
                }
                
                Link("Privacy Policy", destination: URL(string: "https://example.com/privacy")!)
                Link("Support", destination: URL(string: "https://example.com/support")!)
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadNotificationStatus()
            loadLitterSettings()
        }
        .alert("Permission Required", isPresented: $showingPermissionAlert) {
            Button("Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Please enable notifications in Settings to receive reminders.")
        }
    }
    
    private func loadNotificationStatus() async {
        let status = await container.notificationService.checkPermissionStatus()
        notificationsEnabled = status == .authorized
        
        if let profile = userProfile {
            notificationsEnabled = profile.notificationsEnabled
        }
    }
    
    private func loadLitterSettings() {
        guard let profile = userProfile else { return }
        litterRemindersEnabled = profile.litterRemindersEnabled
        litterThresholdDays = profile.litterReminderThresholdDays
        playfulEmojiEnabled = profile.playfulEmojiEnabled
        
        // Convert hour/minute to Date for DatePicker
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = profile.litterReminderHour
        components.minute = profile.litterReminderMinute
        litterReminderTime = Calendar.current.date(from: components) ?? Date()
    }
    
    private func handleNotificationToggle(_ enabled: Bool) {
        Task {
            if enabled {
                let granted = await container.notificationService.requestPermission()
                if granted {
                    // Schedule reminder for 8 PM
                    await container.notificationService.scheduleDailyReminder(at: 20, minute: 0)
                    
                    // Update profile
                    if let profile = userProfile {
                        profile.notificationsEnabled = true
                        try? modelContext.save()
                    }
                } else {
                    notificationsEnabled = false
                    showingPermissionAlert = true
                }
            } else {
                await container.notificationService.cancelDailyReminder()
                
                if let profile = userProfile {
                    profile.notificationsEnabled = false
                    try? modelContext.save()
                }
            }
        }
    }
    
    private func handleLitterReminderToggle(_ enabled: Bool) {
        Task {
            if enabled {
                let granted = await container.notificationService.requestPermission()
                if granted {
                    if let profile = userProfile {
                        profile.litterRemindersEnabled = true
                        try? modelContext.save()
                    }
                    await scheduleLitterRemindersIfNeeded()
                } else {
                    litterRemindersEnabled = false
                    showingPermissionAlert = true
                }
            } else {
                await container.notificationService.cancelAllLitterReminders()
                if let profile = userProfile {
                    profile.litterRemindersEnabled = false
                    try? modelContext.save()
                }
            }
        }
    }
    
    private func saveLitterSettings() {
        guard let profile = userProfile else { return }
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: litterReminderTime)
        profile.litterReminderHour = components.hour ?? 20
        profile.litterReminderMinute = components.minute ?? 0
        profile.litterReminderThresholdDays = litterThresholdDays
        profile.playfulEmojiEnabled = playfulEmojiEnabled
        
        try? modelContext.save()
        
        if litterRemindersEnabled {
            Task {
                await scheduleLitterRemindersIfNeeded()
            }
        }
    }
    
    private func scheduleLitterRemindersIfNeeded() async {
        guard let profile = userProfile, profile.litterRemindersEnabled else { return }
        
        let calendar = Calendar.current
        let now = Date()
        let thresholdDate = calendar.date(byAdding: .day, value: -profile.litterReminderThresholdDays, to: now) ?? now
        
        for pet in pets {
            // Check if already sent reminder today
            if let lastSent = pet.lastLitterReminderSentAt,
               calendar.isDateInToday(lastSent) {
                continue
            }
            
            // Find last litter cleaning event for this pet
            let lastLitterEvent = pet.events?
                .filter { $0.eventType == .litter }
                .sorted { $0.date > $1.date }
                .first
            
            let shouldRemind: Bool
            if let lastEvent = lastLitterEvent {
                shouldRemind = lastEvent.date < thresholdDate
            } else {
                // No litter events ever logged - remind
                shouldRemind = true
            }
            
            if shouldRemind {
                await container.notificationService.scheduleLitterReminder(
                    for: pet.id,
                    petName: pet.name,
                    at: profile.litterReminderHour,
                    minute: profile.litterReminderMinute,
                    playfulEmoji: profile.playfulEmojiEnabled
                )
                
                // Update last reminder sent
                pet.lastLitterReminderSentAt = now
                try? modelContext.save()
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: UserProfile.self, configurations: config)
    let appContainer = AppContainer.create(modelContainer: container)
    
    return NavigationStack {
        SettingsView()
    }
    .environmentObject(appContainer)
    .modelContainer(container)
}

