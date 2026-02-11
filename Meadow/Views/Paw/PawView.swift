//
//  PawView.swift
//  Meadow
//
//  Created on [Date]
//

import SwiftUI
import SwiftData

struct PawView: View {
    @EnvironmentObject var container: AppContainer
    @Query(filter: #Predicate<CareEvent> { $0.type != "Feeding" }, sort: \CareEvent.date, order: .reverse) private var events: [CareEvent]
    @State private var showingAddEvent = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(events) { event in
                    EventRowView(event: event)
                        .listRowBackground(Color.white.opacity(0.1))
                }
            }
            .scrollContentBackground(.hidden)
            .background(AppColors.background.ignoresSafeArea())
            .navigationTitle("Care Events")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddEvent = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(AppColors.text)
                    }
                }
            }
            .sheet(isPresented: $showingAddEvent) {
                AddEventView(mode: .careOnly)
            }
        }
        .background(AppColors.background.ignoresSafeArea())
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: CareEvent.self, Pet.self, configurations: config)
    let appContainer = AppContainer.create(modelContainer: container)
    
    return PawView()
        .environmentObject(appContainer)
        .modelContainer(container)
}

