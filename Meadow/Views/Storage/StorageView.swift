//
//  StorageView.swift
//  Meadow
//
//  Created on [Date]
//

import SwiftUI
import SwiftData

struct StorageView: View {
    @EnvironmentObject var container: AppContainer
    @Query(sort: \InventoryItem.updatedAt, order: .reverse) private var items: [InventoryItem]
    @State private var showingAddItem = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    InventoryRowView(item: item)
                }
            }
            .navigationTitle("Storage")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddItem = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddItem) {
                AddInventoryItemView()
            }
        }
    }
}

struct InventoryRowView: View {
    @Environment(\.modelContext) private var modelContext
    let item: InventoryItem
    @State private var quantity: Double
    
    init(item: InventoryItem) {
        self.item = item
        _quantity = State(initialValue: item.quantity)
    }
    
    var body: some View {
        HStack {
            Image(systemName: item.inventoryType.systemImage)
                .foregroundColor(.blue)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                Text(item.inventoryType.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                Button {
                    quantity = max(0, quantity - 1)
                    updateQuantity()
                } label: {
                    Image(systemName: "minus.circle")
                }
                
                Text(item.formattedQuantity)
                    .font(.headline)
                    .frame(minWidth: 80)
                
                Button {
                    quantity += 1
                    updateQuantity()
                } label: {
                    Image(systemName: "plus.circle")
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    private func updateQuantity() {
        item.quantity = quantity
        item.updatedAt = Date()
        try? modelContext.save()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: InventoryItem.self, configurations: config)
    let appContainer = AppContainer.create(modelContainer: container)
    
    return StorageView()
        .environmentObject(appContainer)
        .modelContainer(container)
}

