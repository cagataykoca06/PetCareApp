//
//  MockData.swift
//  Meadow
//
//  Created on [Date]
//

import Foundation
import SwiftData

struct MockData {
    static func createSampleData(modelContext: ModelContext) {
        // Create user profile
        let profile = UserProfile(
            name: "Cagatay Koca",
            trialStartDate: Date()
        )
        modelContext.insert(profile)
        
        // Create pets
        let cat = Pet(
            name: "Konti",
            species: "Cat",
            birthDate: Calendar.current.date(byAdding: .year, value: -2, to: Date()),
            weight: 4.5,
            height: 25.0
        )
        modelContext.insert(cat)
        
        let dog = Pet(
            name: "Max",
            species: "Dog",
            birthDate: Calendar.current.date(byAdding: .year, value: -1, to: Date()),
            weight: 15.0,
            height: 45.0
        )
        modelContext.insert(dog)
        
        // Create events
        let today = Date()
        for i in 0..<10 {
            let eventDate = Calendar.current.date(byAdding: .day, value: -i, to: today) ?? today
            let event = CareEvent(
                type: i % 2 == 0 ? .feeding : .litter,
                date: eventDate,
                notes: "Sample event \(i)",
                pet: i % 2 == 0 ? cat : dog
            )
            modelContext.insert(event)
        }
        
        // Create expenses
        for i in 0..<5 {
            let expenseDate = Calendar.current.date(byAdding: .day, value: -i * 2, to: today) ?? today
            let expense = Expense(
                amount: Double.random(in: 10...50),
                category: i % 2 == 0 ? .food : .vet,
                date: expenseDate,
                notes: "Sample expense \(i)",
                pet: i % 2 == 0 ? cat : nil
            )
            modelContext.insert(expense)
        }
        
        // Create inventory
        let food = InventoryItem(
            type: .food,
            name: "Premium Cat Food",
            quantity: 5.0,
            unit: "kg"
        )
        modelContext.insert(food)
        
        let litter = InventoryItem(
            type: .litter,
            name: "Clumping Litter",
            quantity: 2.0,
            unit: "bags"
        )
        modelContext.insert(litter)
        
        try? modelContext.save()
    }
}

