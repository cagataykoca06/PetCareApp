//
//  HomeView.swift
//  Meadow
//
//  Created on [Date]
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @EnvironmentObject var container: AppContainer
    @Query private var pets: [Pet]
    @Query private var profiles: [UserProfile]
    @State private var viewModel: HomeViewModel?
    @State private var showingAddEvent = false
    @State private var showingStats = false
    @State private var pulseAnimation = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Summary Card
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Summary")
                            .font(AppFonts.title2)
                            .appTextColor()
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Today")
                                    .font(AppFonts.subheadline)
                                    .appTextColor()
                                    .opacity(0.8)
                                
                                if let viewModel = viewModel, !viewModel.last24HoursEvents.isEmpty {
                                    // Show event type icons
                                    HStack(spacing: 8) {
                                        ForEach(viewModel.last24HoursEventTypes, id: \.self) { eventType in
                                            Image(systemName: eventType.systemImage)
                                                .font(AppFonts.body)
                                                .appTextColor()
                                        }
                                    }
                                    
                                    // Show relative time for most recent event
                                    if let relativeTime = viewModel.mostRecentEventRelativeTime {
                                        Text("Last added \(relativeTime)")
                                            .font(AppFonts.caption)
                                            .appTextColor()
                                            .opacity(0.7)
                                    }
                                }
                            }
                            
                            Spacer()
                            
                            // Pet names
                            if !pets.isEmpty {
                                VStack(alignment: .trailing, spacing: 4) {
                                    ForEach(pets) { pet in
                                        Text(pet.name)
                                            .font(AppFonts.subheadline)
                                            .appTextColor()
                                            .opacity(0.8)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(16)
                    
                    // Quick Actions with animated plus
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Button {
                                showingAddEvent = true
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(AppFonts.title2)
                                    .appTextColor()
                                    .scaleEffect(pulseAnimation ? 1.1 : 1.0)
                                    .animation(
                                        Animation.easeInOut(duration: 1.5)
                                            .repeatForever(autoreverses: true),
                                        value: pulseAnimation
                                    )
                            }
                            .accessibilityLabel("Add")
                            
                            Spacer()
                        }
                        
                        HStack(spacing: 12) {
                            QuickActionButton(icon: "cat.fill", title: "Food", color: AppColors.text) {
                                showingAddEvent = true
                            }
                            
                            QuickActionButton(icon: "pawprint.fill", title: "Care", color: AppColors.text) {
                                showingAddEvent = true
                            }
                            
                            QuickActionButton(icon: "chart.bar", title: "Stats", color: AppColors.text) {
                                showingStats = true
                            }
                        }
                    }
                    
                    // Recent Events
                    if let viewModel = viewModel, !viewModel.recentEvents.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recent Events")
                                .font(AppFonts.title3)
                                .appTextColor()
                            
                            ForEach(viewModel.recentEvents) { event in
                                EventRowView(event: event)
                            }
                        }
                    } else {
                        VStack(spacing: 8) {
                            Image(systemName: "pawprint.fill")
                                .font(.system(size: 40))
                                .appTextColor()
                                .opacity(0.6)
                            Text("No events yet")
                                .font(AppFonts.headline)
                                .appTextColor()
                                .opacity(0.8)
                            Text("Start tracking your pet's care")
                                .font(AppFonts.subheadline)
                                .appTextColor()
                                .opacity(0.6)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    }
                }
                .padding()
            }
            .appBackground()
            .navigationTitle("Home")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(AppColors.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .onAppear {
                if viewModel == nil {
                    viewModel = HomeViewModel(container: container)
                }
                pulseAnimation = true
            }
            .task {
                if let viewModel = viewModel {
                    await viewModel.loadData()
                }
            }
            .sheet(isPresented: $showingAddEvent) {
                AddEventView()
            }
            .sheet(isPresented: $showingStats) {
                StatsView()
            }
        }
    }
}

struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(AppFonts.title2)
                Text(title)
                    .font(AppFonts.caption)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white.opacity(0.2))
            .foregroundColor(color)
            .cornerRadius(12)
        }
    }
}

struct EventRowView: View {
    let event: CareEvent
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM HH:mm"
        return formatter.string(from: event.date)
    }
    
    var body: some View {
        HStack {
            Image(systemName: event.eventType.systemImage)
                .foregroundColor(AppColors.text)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(event.eventType.rawValue)
                        .font(AppFonts.headline)
                        .appTextColor()
                    
                    if let details = event.feedingDetails {
                        Text("• \(details)")
                            .font(AppFonts.caption)
                            .appTextColor()
                            .opacity(0.8)
                    }
                }
                
                if let pet = event.pet {
                    Text(pet.name)
                        .font(AppFonts.subheadline)
                        .appTextColor()
                        .opacity(0.8)
                }
            }
            
            Spacer()
            
            Text(formattedDate)
                .font(AppFonts.caption)
                .appTextColor()
                .opacity(0.8)
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(12)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: UserProfile.self, Pet.self, CareEvent.self, configurations: config)
    let appContainer = AppContainer.create(modelContainer: container)
    
    return HomeView()
        .environmentObject(appContainer)
        .modelContainer(container)
}
