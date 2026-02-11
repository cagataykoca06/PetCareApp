//
//  MeadowApp.swift
//  Meadow
//
//  Created on [Date]
//

import SwiftUI
import SwiftData

@main
struct MeadowApp: App {
    @StateObject private var appContainer: AppContainer
    let modelContainer: ModelContainer
    
    init() {
        let schema = Schema([
            UserProfile.self,
            Pet.self,
            CareEvent.self,
            Expense.self,
            NecessityItem.self,
            InventoryItem.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            self.modelContainer = container
            self._appContainer = StateObject(wrappedValue: AppContainer.create(modelContainer: container))
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appContainer)
                .modelContainer(modelContainer)
        }
    }
}
