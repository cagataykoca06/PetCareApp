//
//  ExpenseRepository.swift
//  Meadow
//
//  Created on [Date]
//

import Foundation

protocol ExpenseRepository {
    func fetchAll() async throws -> [Expense]
    func fetch(id: UUID) async throws -> Expense?
    func fetch(for petId: UUID?) async throws -> [Expense] // nil = household expenses
    func fetch(from startDate: Date, to endDate: Date) async throws -> [Expense]
    func fetch(for petId: UUID?, from startDate: Date, to endDate: Date) async throws -> [Expense]
    func create(_ expense: Expense) async throws
    func update(_ expense: Expense) async throws
    func delete(_ expense: Expense) async throws
    func totalAmount(from startDate: Date, to endDate: Date) async throws -> Double
}

