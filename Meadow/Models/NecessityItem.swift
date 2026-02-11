//
//  NecessityItem.swift
//  Meadow
//
//  Created on [Date]
//

import Foundation
import SwiftData

@Model
final class NecessityItem {
    @Attribute(.unique) var id: UUID
    var title: String
    var category: String // ExpenseCategory rawValue
    var isDone: Bool
    var createdAt: Date
    var dueDate: Date?
    var linkedExpenseId: UUID?
    
    @Relationship(inverse: \Pet.necessities) var pet: Pet?
    
    init(
        id: UUID = UUID(),
        title: String,
        category: ExpenseCategory,
        isDone: Bool = false,
        createdAt: Date = Date(),
        dueDate: Date? = nil,
        linkedExpenseId: UUID? = nil,
        pet: Pet? = nil
    ) {
        self.id = id
        self.title = title
        self.category = category.rawValue
        self.isDone = isDone
        self.createdAt = createdAt
        self.dueDate = dueDate
        self.linkedExpenseId = linkedExpenseId
        self.pet = pet
    }
    
    var expenseCategory: ExpenseCategory {
        ExpenseCategory(rawValue: category) ?? .other
    }
}

