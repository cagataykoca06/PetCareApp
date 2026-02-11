//
//  AppContainer.swift
//  Meadow
//
//  Created on [Date]
//

import Foundation
import SwiftData
import Combine

@MainActor
class AppContainer: ObservableObject {
    let petRepository: PetRepository
    let eventRepository: EventRepository
    let expenseRepository: ExpenseRepository
    let necessityRepository: NecessityRepository
    let inventoryRepository: InventoryRepository
    let userProfileRepository: UserProfileRepository
    let subscriptionService: SubscriptionService
    let notificationService: NotificationService
    
    init(
        petRepository: PetRepository,
        eventRepository: EventRepository,
        expenseRepository: ExpenseRepository,
        necessityRepository: NecessityRepository,
        inventoryRepository: InventoryRepository,
        userProfileRepository: UserProfileRepository,
        subscriptionService: SubscriptionService,
        notificationService: NotificationService
    ) {
        self.petRepository = petRepository
        self.eventRepository = eventRepository
        self.expenseRepository = expenseRepository
        self.necessityRepository = necessityRepository
        self.inventoryRepository = inventoryRepository
        self.userProfileRepository = userProfileRepository
        self.subscriptionService = subscriptionService
        self.notificationService = notificationService
    }
    
    static func create(modelContainer: ModelContainer) -> AppContainer {
        return MainActor.assumeIsolated {
            let repository = SwiftDataRepository(modelContainer: modelContainer)
            
            #if DEBUG
            // Use mock services in debug for easier testing
            let subscriptionService: SubscriptionService = MockSubscriptionService()
            let notificationService: NotificationService = MockNotificationService()
            #else
            let subscriptionService: SubscriptionService = StoreKitSubscriptionService()
            let notificationService: NotificationService = UserNotificationService()
            #endif
            
            return AppContainer(
                petRepository: repository,
                eventRepository: repository,
                expenseRepository: repository,
                necessityRepository: repository,
                inventoryRepository: repository,
                userProfileRepository: repository,
                subscriptionService: subscriptionService,
                notificationService: notificationService
            )
        }
    }
}

