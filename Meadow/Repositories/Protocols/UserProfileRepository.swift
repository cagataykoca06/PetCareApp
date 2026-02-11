//
//  UserProfileRepository.swift
//  Meadow
//
//  Created on [Date]
//

import Foundation

protocol UserProfileRepository {
    func fetch() async throws -> UserProfile?
    func create(_ profile: UserProfile) async throws
    func update(_ profile: UserProfile) async throws
}

