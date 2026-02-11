//
//  ContentView.swift
//  Meadow
//
//  Created on [Date]
//

import SwiftUI
import SwiftData

// Theme definitions (temporary location until AppTheme.swift is added to Xcode project)
struct AppColors {
    static let background = Color(red: 0.996, green: 0.384, blue: 0.216) // Tiger Flame: #FE6237
    static let text = Color.white
    static let sunflowerGold = Color(red: 1.0, green: 0.71, blue: 0.18) // Sunflower Gold: #FFB62E
}

struct AppFonts {
    static func monospaced(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .monospaced)
    }
    
    static let largeTitle = monospaced(size: 34, weight: .bold)
    static let title = monospaced(size: 28, weight: .bold)
    static let title2 = monospaced(size: 22, weight: .bold)
    static let title3 = monospaced(size: 20, weight: .bold)
    static let headline = monospaced(size: 17, weight: .semibold)
    static let body = monospaced(size: 17, weight: .regular)
    static let callout = monospaced(size: 16, weight: .regular)
    static let subheadline = monospaced(size: 15, weight: .regular)
    static let footnote = monospaced(size: 13, weight: .regular)
    static let caption = monospaced(size: 12, weight: .regular)
    static let caption2 = monospaced(size: 11, weight: .regular)
}

extension View {
    func appBackground() -> some View {
        self.background(AppColors.background.ignoresSafeArea())
    }
    
    func appTextColor() -> some View {
        self.foregroundColor(AppColors.text)
    }
}

struct ContentView: View {
    @EnvironmentObject var container: AppContainer
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]
    
    var body: some View {
        Group {
            if profiles.isEmpty {
                WelcomeView()
            } else {
                MainTabView()
            }
        }
        .appBackground()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: UserProfile.self, Pet.self, CareEvent.self, Expense.self, NecessityItem.self, InventoryItem.self, configurations: config)
    let appContainer = AppContainer.create(modelContainer: container)
    
    return ContentView()
        .environmentObject(appContainer)
        .modelContainer(container)
}

