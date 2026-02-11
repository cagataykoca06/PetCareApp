//
//  NotificationService.swift
//  Meadow
//

import Foundation
import UserNotifications

protocol NotificationService {
    func requestPermission() async -> Bool
    func scheduleDailyReminder(at hour: Int, minute: Int) async
    func cancelDailyReminder() async
    func checkPermissionStatus() async -> UNAuthorizationStatus
    
    // Litter reminders
    func scheduleLitterReminder(for petId: UUID, petName: String, at hour: Int, minute: Int, playfulEmoji: Bool) async
    func cancelLitterReminder(for petId: UUID) async
    func cancelAllLitterReminders() async
}

class UserNotificationService: NotificationService {
    private let center = UNUserNotificationCenter.current()
    
    func requestPermission() async -> Bool {
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            return granted
        } catch {
            return false
        }
    }
    
    func scheduleDailyReminder(at hour: Int, minute: Int) async {
        // Cancel existing reminder
        await cancelDailyReminder()
        
        let content = UNMutableNotificationContent()
        content.title = "Daily Pet Care Reminder"
        content.body = "Don't forget to log today's care events for your pets!"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(
            identifier: "dailyReminder",
            content: content,
            trigger: trigger
        )
        
        do {
            try await center.add(request)
        } catch {
            print("Failed to schedule reminder: \(error)")
        }
    }
    
    func cancelDailyReminder() async {
        center.removePendingNotificationRequests(withIdentifiers: ["dailyReminder"])
    }
    
    func checkPermissionStatus() async -> UNAuthorizationStatus {
        let settings = await center.notificationSettings()
        return settings.authorizationStatus
    }
    
    // MARK: - Litter Reminders
    
    func scheduleLitterReminder(for petId: UUID, petName: String, at hour: Int, minute: Int, playfulEmoji: Bool) async {
        // Cancel existing reminder for this pet
        await cancelLitterReminder(for: petId)
        
        let content = UNMutableNotificationContent()
        if playfulEmoji {
            content.title = "Litter Time 💩"
            content.body = "Time to log a litter clean for \(petName) 💩"
        } else {
            content.title = "Litter Reminder"
            content.body = "Reminder: log a litter clean for \(petName)."
        }
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(
            identifier: litterReminderId(for: petId),
            content: content,
            trigger: trigger
        )
        
        do {
            try await center.add(request)
        } catch {
            print("Failed to schedule litter reminder: \(error)")
        }
    }
    
    func cancelLitterReminder(for petId: UUID) async {
        center.removePendingNotificationRequests(withIdentifiers: [litterReminderId(for: petId)])
    }
    
    func cancelAllLitterReminders() async {
        let requests = await center.pendingNotificationRequests()
        let litterIds = requests
            .filter { $0.identifier.hasPrefix("litterReminder_") }
            .map { $0.identifier }
        center.removePendingNotificationRequests(withIdentifiers: litterIds)
    }
    
    private func litterReminderId(for petId: UUID) -> String {
        "litterReminder_\(petId.uuidString)"
    }
}

// Mock implementation for testing
class MockNotificationService: NotificationService {
    var hasPermission: Bool = false
    var isScheduled: Bool = false
    var scheduledLitterReminders: Set<UUID> = []
    
    func requestPermission() async -> Bool {
        hasPermission = true
        return true
    }
    
    func scheduleDailyReminder(at hour: Int, minute: Int) async {
        isScheduled = true
    }
    
    func cancelDailyReminder() async {
        isScheduled = false
    }
    
    func checkPermissionStatus() async -> UNAuthorizationStatus {
        return hasPermission ? .authorized : .notDetermined
    }
    
    func scheduleLitterReminder(for petId: UUID, petName: String, at hour: Int, minute: Int, playfulEmoji: Bool) async {
        scheduledLitterReminders.insert(petId)
    }
    
    func cancelLitterReminder(for petId: UUID) async {
        scheduledLitterReminders.remove(petId)
    }
    
    func cancelAllLitterReminders() async {
        scheduledLitterReminders.removeAll()
    }
}

