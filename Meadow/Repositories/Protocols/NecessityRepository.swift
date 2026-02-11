//
//  NecessityRepository.swift
//  Meadow
//
//  Created on [Date]
//

import Foundation

protocol NecessityRepository {
    func fetchAll() async throws -> [NecessityItem]
    func fetch(id: UUID) async throws -> NecessityItem?
    func fetch(for petId: UUID?) async throws -> [NecessityItem]
    func fetchPending() async throws -> [NecessityItem]
    func create(_ item: NecessityItem) async throws
    func update(_ item: NecessityItem) async throws
    func delete(_ item: NecessityItem) async throws
}

