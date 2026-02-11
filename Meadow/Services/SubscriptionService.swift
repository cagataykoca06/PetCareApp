//
//  SubscriptionService.swift
//  Meadow
//

import Foundation
import StoreKit

@MainActor
protocol SubscriptionService {
    func loadProducts() async throws -> [Product]
    func purchase(_ product: Product) async throws -> Transaction?
    func restorePurchases() async throws
    func checkSubscriptionStatus() async -> Bool
}

@MainActor
class StoreKitSubscriptionService: SubscriptionService {
    private let productIds = ["meadow_premium_monthly", "meadow_premium_annual"]
    private var products: [Product] = []
    
    func loadProducts() async throws -> [Product] {
        products = try await Product.products(for: productIds)
        return products
    }
    
    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            return transaction
        case .userCancelled, .pending:
            return nil
        @unknown default:
            return nil
        }
    }
    
    func restorePurchases() async throws {
        try await AppStore.sync()
    }
    
    func checkSubscriptionStatus() async -> Bool {
        var isActive = false
        
        for productId in productIds {
            guard let product = try? await Product.products(for: [productId]).first else { continue }
            
            if let status = try? await product.subscription?.status.first,
               case .subscribed = status.state {
                isActive = true
                break
            }
        }
        
        return isActive
    }
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw SubscriptionError.unverifiedTransaction
        case .verified(let safe):
            return safe
        }
    }
}

enum SubscriptionError: Error {
    case unverifiedTransaction
    case productNotFound
    case purchaseFailed
}

// Mock implementation for testing
@MainActor
class MockSubscriptionService: SubscriptionService {
    var isPremium: Bool = false
    
    func loadProducts() async throws -> [Product] {
        // Return empty for mock - will use test purchase button
        return []
    }
    
    func purchase(_ product: Product) async throws -> Transaction? {
        // Simulate purchase
        isPremium = true
        return nil
    }
    
    func restorePurchases() async throws {
        // Simulate restore
    }
    
    func checkSubscriptionStatus() async -> Bool {
        return isPremium
    }
}

