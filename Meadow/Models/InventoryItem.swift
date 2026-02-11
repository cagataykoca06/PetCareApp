//
//  InventoryItem.swift
//  Meadow
//
//  Created on [Date]
//

import Foundation
import SwiftData

enum InventoryType: String, Codable, CaseIterable {
    case food = "Food"
    case litter = "Litter"
    case other = "Other"
    
    var systemImage: String {
        switch self {
        case .food: return "fish.fill"
        case .litter: return "tree.fill"
        case .other: return "cube.box"
        }
    }
}

@Model
final class InventoryItem {
    @Attribute(.unique) var id: UUID
    var type: String // InventoryType rawValue
    var name: String
    var quantity: Double
    var unit: String // "kg", "lbs", "bags", etc.
    var updatedAt: Date
    
    init(
        id: UUID = UUID(),
        type: InventoryType,
        name: String,
        quantity: Double,
        unit: String = "kg",
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.type = type.rawValue
        self.name = name
        self.quantity = quantity
        self.unit = unit
        self.updatedAt = updatedAt
    }
    
    var inventoryType: InventoryType {
        InventoryType(rawValue: type) ?? .other
    }
    
    var formattedQuantity: String {
        "\(String(format: "%.1f", quantity)) \(unit)"
    }
}

