//
//  MainTabView.swift
//  Meadow
//
//  Created on [Date]
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            FoodView()
                .tabItem {
                    Label("Food", systemImage: "cat.fill")
                }
                .tag(1)
            
            PawView()
                .tabItem {
                    Label("Paw", systemImage: "pawprint.fill")
                }
                .tag(2)
            
            StorageView()
                .tabItem {
                    Label("Storage", systemImage: "archivebox.fill")
                }
                .tag(3)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "brain.head.profile.fill")
                }
                .tag(4)
        }
        .appBackground()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: UserProfile.self, Pet.self, CareEvent.self, Expense.self, NecessityItem.self, InventoryItem.self, configurations: config)
    let appContainer = AppContainer.create(modelContainer: container)
    
    MainTabView()
        .environmentObject(appContainer)
        .modelContainer(container)
}

