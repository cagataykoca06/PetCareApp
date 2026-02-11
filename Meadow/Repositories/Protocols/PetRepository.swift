//
//  PetRepository.swift
//  Meadow
//
//  Created on [Date]
//

import Foundation

protocol PetRepository {
    func fetchAll() async throws -> [Pet]
    func fetch(id: UUID) async throws -> Pet?
    func create(_ pet: Pet) async throws
    func update(_ pet: Pet) async throws
    func delete(_ pet: Pet) async throws
}

