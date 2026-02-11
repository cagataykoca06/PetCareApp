//
//  EventRepository.swift
//  Meadow
//
//  Created on [Date]
//

import Foundation

protocol EventRepository {
    func fetchAll() async throws -> [CareEvent]
    func fetch(id: UUID) async throws -> CareEvent?
    func fetch(for petId: UUID) async throws -> [CareEvent]
    func fetch(from startDate: Date, to endDate: Date) async throws -> [CareEvent]
    func fetch(for petId: UUID, from startDate: Date, to endDate: Date) async throws -> [CareEvent]
    func create(_ event: CareEvent) async throws
    func update(_ event: CareEvent) async throws
    func delete(_ event: CareEvent) async throws
}

