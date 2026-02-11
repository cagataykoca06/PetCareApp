//
//  SwiftDataRepository.swift
//  Meadow
//
//  Created on 05.01.2026
//

import Foundation
import SwiftData

@MainActor
class SwiftDataRepository: PetRepository, EventRepository, ExpenseRepository, NecessityRepository, InventoryRepository, UserProfileRepository {
    private let modelContainer: ModelContainer
    private var context: ModelContext {
        modelContainer.mainContext
    }
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }
    
    // UserProfileRepository
    
    func fetch() async throws -> UserProfile? {
        let descriptor = FetchDescriptor<UserProfile>()
        return try context.fetch(descriptor).first
    }
    
    func create(_ profile: UserProfile) async throws {
        context.insert(profile)
        try context.save()
    }
    
    func update(_ profile: UserProfile) async throws {
        try context.save()
    }
    
    // PetRepository
    
    func fetchAll() async throws -> [Pet] {
        let descriptor = FetchDescriptor<Pet>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        return try context.fetch(descriptor)
    }
    
    func fetch(id: UUID) async throws -> Pet? {
        let descriptor = FetchDescriptor<Pet>(
            predicate: #Predicate { $0.id == id }
        )
        return try context.fetch(descriptor).first
    }
    
    func create(_ pet: Pet) async throws {
        context.insert(pet)
        try context.save()
    }
    
    func update(_ pet: Pet) async throws {
        try context.save()
    }
    
    func delete(_ pet: Pet) async throws {
        context.delete(pet)
        try context.save()
    }
    
    //EventRepository
    
    func fetchAll() async throws -> [CareEvent] {
        let descriptor = FetchDescriptor<CareEvent>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        return try context.fetch(descriptor)
    }
    
    func fetch(id: UUID) async throws -> CareEvent? {
        let descriptor = FetchDescriptor<CareEvent>(
            predicate: #Predicate { $0.id == id }
        )
        return try context.fetch(descriptor).first
    }
    
    func fetch(for petId: UUID) async throws -> [CareEvent] {
        let descriptor = FetchDescriptor<CareEvent>(
            predicate: #Predicate { $0.pet?.id == petId },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        return try context.fetch(descriptor)
    }
    
    func fetch(from startDate: Date, to endDate: Date) async throws -> [CareEvent] {
        let descriptor = FetchDescriptor<CareEvent>(
            predicate: #Predicate { event in
                event.date >= startDate && event.date <= endDate
            },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        return try context.fetch(descriptor)
    }
    
    func fetch(for petId: UUID, from startDate: Date, to endDate: Date) async throws -> [CareEvent] {
        let descriptor = FetchDescriptor<CareEvent>(
            predicate: #Predicate { event in
                event.pet?.id == petId && event.date >= startDate && event.date <= endDate
            },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        return try context.fetch(descriptor)
    }
    
    func create(_ event: CareEvent) async throws {
        context.insert(event)
        try context.save()
    }
    
    func update(_ event: CareEvent) async throws {
        try context.save()
    }
    
    func delete(_ event: CareEvent) async throws {
        context.delete(event)
        try context.save()
    }
    
    // MARK: - ExpenseRepository
    
    func fetchAll() async throws -> [Expense] {
        let descriptor = FetchDescriptor<Expense>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        return try context.fetch(descriptor)
    }
    
    func fetch(id: UUID) async throws -> Expense? {
        let descriptor = FetchDescriptor<Expense>(
            predicate: #Predicate { $0.id == id }
        )
        return try context.fetch(descriptor).first
    }
    
    func fetch(for petId: UUID?) async throws -> [Expense] {
        if let petId = petId {
            let descriptor = FetchDescriptor<Expense>(
                predicate: #Predicate { $0.pet?.id == petId },
                sortBy: [SortDescriptor(\.date, order: .reverse)]
            )
            return try context.fetch(descriptor)
        } else {
            let descriptor = FetchDescriptor<Expense>(
                predicate: #Predicate { $0.pet == nil },
                sortBy: [SortDescriptor(\.date, order: .reverse)]
            )
            return try context.fetch(descriptor)
        }
    }
    
    func fetch(from startDate: Date, to endDate: Date) async throws -> [Expense] {
        let descriptor = FetchDescriptor<Expense>(
            predicate: #Predicate { expense in
                expense.date >= startDate && expense.date <= endDate
            },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        return try context.fetch(descriptor)
    }
    
    func fetch(for petId: UUID?, from startDate: Date, to endDate: Date) async throws -> [Expense] {
        if let petId = petId {
            let descriptor = FetchDescriptor<Expense>(
                predicate: #Predicate { expense in
                    expense.pet?.id == petId && expense.date >= startDate && expense.date <= endDate
                },
                sortBy: [SortDescriptor(\.date, order: .reverse)]
            )
            return try context.fetch(descriptor)
        } else {
            let descriptor = FetchDescriptor<Expense>(
                predicate: #Predicate { expense in
                    expense.pet == nil && expense.date >= startDate && expense.date <= endDate
                },
                sortBy: [SortDescriptor(\.date, order: .reverse)]
            )
            return try context.fetch(descriptor)
        }
    }
    
    func create(_ expense: Expense) async throws {
        context.insert(expense)
        try context.save()
    }
    
    func update(_ expense: Expense) async throws {
        try context.save()
    }
    
    func delete(_ expense: Expense) async throws {
        context.delete(expense)
        try context.save()
    }
    
    func totalAmount(from startDate: Date, to endDate: Date) async throws -> Double {
        let expenses: [Expense] = try await fetch(from: startDate, to: endDate)
        return expenses.reduce(0) { $0 + $1.amount }
    }
    
    //NecessityRepository
    
    func fetchAll() async throws -> [NecessityItem] {
        let descriptor = FetchDescriptor<NecessityItem>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        return try context.fetch(descriptor)
    }
    
    func fetch(id: UUID) async throws -> NecessityItem? {
        let descriptor = FetchDescriptor<NecessityItem>(
            predicate: #Predicate { $0.id == id }
        )
        return try context.fetch(descriptor).first
    }
    
    func fetch(for petId: UUID?) async throws -> [NecessityItem] {
        if let petId = petId {
            let descriptor = FetchDescriptor<NecessityItem>(
                predicate: #Predicate { $0.pet?.id == petId },
                sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
            )
            return try context.fetch(descriptor)
        } else {
            let descriptor = FetchDescriptor<NecessityItem>(
                predicate: #Predicate { $0.pet == nil },
                sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
            )
            return try context.fetch(descriptor)
        }
    }
    
    func fetchPending() async throws -> [NecessityItem] {
        let descriptor = FetchDescriptor<NecessityItem>(
            predicate: #Predicate { !$0.isDone },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return try context.fetch(descriptor)
    }
    
    func create(_ item: NecessityItem) async throws {
        context.insert(item)
        try context.save()
    }
    
    func update(_ item: NecessityItem) async throws {
        try context.save()
    }
    
    func delete(_ item: NecessityItem) async throws {
        context.delete(item)
        try context.save()
    }
    
    // InventoryRepository
    
    func fetchAll() async throws -> [InventoryItem] {
        let descriptor = FetchDescriptor<InventoryItem>(sortBy: [SortDescriptor(\.updatedAt, order: .reverse)])
        return try context.fetch(descriptor)
    }
    
    func fetch(id: UUID) async throws -> InventoryItem? {
        let descriptor = FetchDescriptor<InventoryItem>(
            predicate: #Predicate { $0.id == id }
        )
        return try context.fetch(descriptor).first
    }
    
    func create(_ item: InventoryItem) async throws {
        context.insert(item)
        try context.save()
    }
    
    func update(_ item: InventoryItem) async throws {
        try context.save()
    }
    
    func delete(_ item: InventoryItem) async throws {
        context.delete(item)
        try context.save()
    }
}

