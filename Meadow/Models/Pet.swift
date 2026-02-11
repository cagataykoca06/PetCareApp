//
//  Pet.swift
//  Meadow
//
//  Created on [Date]
//

import Foundation
import SwiftData

@Model
final class Pet {
    @Attribute(.unique) var id: UUID
    var name: String
    var species: String // "Cat", "Dog", etc.
    var birthDate: Date?
    var photoData: Data?
    var weight: Double? // in kg
    var height: Double? // in cm
    var createdAt: Date
    
    // Reminder tracking
    var lastLitterReminderSentAt: Date?
    
    // Feeding guidance (optional per-pet override)
    var foodKcalPer100g: Double?
    
    @Relationship(deleteRule: .cascade) var events: [CareEvent]?
    @Relationship(deleteRule: .cascade) var expenses: [Expense]?
    @Relationship(deleteRule: .cascade) var necessities: [NecessityItem]?
    
    init(
        id: UUID = UUID(),
        name: String,
        species: String,
        birthDate: Date? = nil,
        photoData: Data? = nil,
        weight: Double? = nil,
        height: Double? = nil,
        createdAt: Date = Date(),
        lastLitterReminderSentAt: Date? = nil,
        foodKcalPer100g: Double? = nil
    ) {
        self.id = id
        self.name = name
        self.species = species
        self.birthDate = birthDate
        self.photoData = photoData
        self.weight = weight
        self.height = height
        self.createdAt = createdAt
        self.lastLitterReminderSentAt = lastLitterReminderSentAt
        self.foodKcalPer100g = foodKcalPer100g
        self.events = []
        self.expenses = []
        self.necessities = []
    }
    
    var age: String? {
        guard let birthDate = birthDate else { return nil }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: birthDate, to: Date())
        if let years = components.year, let months = components.month {
            if years > 0 {
                return "\(years) year\(years > 1 ? "s" : "")"
            } else if months > 0 {
                return "\(months) month\(months > 1 ? "s" : "")"
            }
        }
        return "Newborn"
    }
}

