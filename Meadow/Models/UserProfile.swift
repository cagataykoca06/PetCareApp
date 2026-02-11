//
//  UserProfile.swift
//  Meadow
//
//  Created on [Date]
//

import Foundation
import SwiftData

@Model
final class UserProfile {
    @Attribute(.unique) var id: UUID
    var name: String
    var createdAt: Date
    var trialStartDate: Date?
    var isPremium: Bool
    var premiumExpiresAt: Date?
    var locale: String
    var notificationsEnabled: Bool
    
    // Litter Reminder Settings
    var litterRemindersEnabled: Bool
    var litterReminderHour: Int
    var litterReminderMinute: Int
    var litterReminderThresholdDays: Int
    var playfulEmojiEnabled: Bool
    
    // Feeding Guidance Settings
    var defaultFoodKcalPer100g: Double
    
    init(
        id: UUID = UUID(),
        name: String,
        createdAt: Date = Date(),
        trialStartDate: Date? = nil,
        isPremium: Bool = false,
        premiumExpiresAt: Date? = nil,
        locale: String = "en_US",
        notificationsEnabled: Bool = false,
        litterRemindersEnabled: Bool = false,
        litterReminderHour: Int = 20,
        litterReminderMinute: Int = 0,
        litterReminderThresholdDays: Int = 3,
        playfulEmojiEnabled: Bool = true,
        defaultFoodKcalPer100g: Double = 350.0
    ) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.trialStartDate = trialStartDate ?? createdAt
        self.isPremium = isPremium
        self.premiumExpiresAt = premiumExpiresAt
        self.locale = locale
        self.notificationsEnabled = notificationsEnabled
        self.litterRemindersEnabled = litterRemindersEnabled
        self.litterReminderHour = litterReminderHour
        self.litterReminderMinute = litterReminderMinute
        self.litterReminderThresholdDays = litterReminderThresholdDays
        self.playfulEmojiEnabled = playfulEmojiEnabled
        self.defaultFoodKcalPer100g = defaultFoodKcalPer100g
    }
    
    var isTrialActive: Bool {
        guard let trialStart = trialStartDate else { return false }
        let trialEnd = Calendar.current.date(byAdding: .month, value: 1, to: trialStart) ?? Date()
        return Date() < trialEnd && !isPremium
    }
    
    var canAccessPremiumFeatures: Bool {
        isPremium || isTrialActive
    }
}

