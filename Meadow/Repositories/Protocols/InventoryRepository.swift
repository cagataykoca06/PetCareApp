//
//  InventoryRepository.swift
//  Meadow
//
//  Created on [Date]
//

import Foundation

protocol InventoryRepository {
    func fetchAll() async throws -> [InventoryItem]
    func fetch(id: UUID) async throws -> InventoryItem?
    func create(_ item: InventoryItem) async throws
    func update(_ item: InventoryItem) async throws
    func delete(_ item: InventoryItem) async throws
}

