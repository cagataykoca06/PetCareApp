//
//  Expense.swift
//  Meadow
//
//  Created on [Date]
//

import Foundation
import SwiftData

enum ExpenseCategory: String, Codable, CaseIterable {
    case food = "Food"
    case litter = "Litter"
    case vet = "Vet"
    case other = "Other"
    
    var systemImage: String {
        switch self {
        case .food: return "fish.fill"
        case .litter: return "tree.fill"
        case .vet: return "cross.case.fill"
        case .other: return "tag"
        }
    }
}

@Model
final class Expense {
    @Attribute(.unique) var id: UUID
    var amount: Double
    var currency: String
    var category: String // ExpenseCategory rawValue
    var date: Date
    var notes: String
    
    @Relationship(inverse: \Pet.expenses) var pet: Pet?
    var linkedEventId: UUID?
    
    init(
        id: UUID = UUID(),
        amount: Double,
        currency: String = "USD",
        category: ExpenseCategory,
        date: Date = Date(),
        notes: String = "",
        pet: Pet? = nil,
        linkedEventId: UUID? = nil
    ) {
        self.id = id
        self.amount = amount
        self.currency = currency
        self.category = category.rawValue
        self.date = date
        self.notes = notes
        self.pet = pet
        self.linkedEventId = linkedEventId
    }
    
    var expenseCategory: ExpenseCategory {
        ExpenseCategory(rawValue: category) ?? .other
    }
    
    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        return formatter.string(from: NSNumber(value: amount)) ?? "$\(String(format: "%.2f", amount))"
    }
}

