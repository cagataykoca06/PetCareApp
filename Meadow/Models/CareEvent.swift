//
//  CareEvent.swift
//  Meadow
//
import Foundation
import SwiftData

enum CareEventType: String, Codable, CaseIterable {
    case feeding = "Feeding"
    case litter = "Litter Cleaning"
    case walk = "Walk"
    case vet = "Vet Visit"
    case vaccine = "Vaccine"
    case playing = "Playing"
    case custom = "Custom"
    
    var systemImage: String {
        switch self {
        case .feeding: return "fish.fill"
        case .litter: return "tree.fill"
        case .walk: return "dog.fill"
        case .vet: return "heart.text.clipboard.fill"
        case .vaccine: return "cross.case.fill"
        case .playing: return "figure.play"
        case .custom: return "star.fill"
        }
    }
}

@Model
final class CareEvent {
    @Attribute(.unique) var id: UUID
    var type: String
    // CareEventType rawValue
    var date: Date
    var notes: String
    var metadata: String?
    // JSON string for additional data (foodType, duration, etc.)
    
    // Feeding-specific fields
    var isSpecialFood: Bool? // nil if not a feeding event, true for special, false for ordinary
    var foodGrams: Double? // Amount in grams
    var foodFlavor: String? // Selected flavor (e.g., "Salmon", "Chicken", etc.)
    
    // Walk-specific fields
    var durationMinutes: Int? // Duration in minutes for walk events
    
    @Relationship(inverse: \Pet.events) var pet: Pet?
    
    init(
        id: UUID = UUID(),
        type: CareEventType,
        date: Date = Date(),
        notes: String = "",
        metadata: String? = nil,
        isSpecialFood: Bool? = nil,
        foodGrams: Double? = nil,
        foodFlavor: String? = nil,
        durationMinutes: Int? = nil,
        pet: Pet? = nil
    ) {
        self.id = id
        self.type = type.rawValue
        self.date = date
        self.notes = notes
        self.metadata = metadata
        self.isSpecialFood = isSpecialFood
        self.foodGrams = foodGrams
        self.foodFlavor = foodFlavor
        self.durationMinutes = durationMinutes
        self.pet = pet
    }
    
    var eventType: CareEventType {
        CareEventType(rawValue: type) ?? .custom
    }
    
    var feedingDetails: String? {
        guard eventType == .feeding else { return nil }
        var parts: [String] = []
        
        if let isSpecial = isSpecialFood {
            parts.append(isSpecial ? "Special" : "Ordinary")
        }
        
        if let grams = foodGrams {
            parts.append("\(Int(grams))g")
        }
        
        if let flavor = foodFlavor, !flavor.isEmpty {
            parts.append(flavor)
        }
        
        return parts.isEmpty ? nil : parts.joined(separator: " • ")
    }
}

