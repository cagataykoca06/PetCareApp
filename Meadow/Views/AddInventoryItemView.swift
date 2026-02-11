//
//  AddInventoryItemView.swift
//  Meadow
//
//  Created on 25.01.2025
//

import SwiftUI
import SwiftData

struct AddInventoryItemView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var type: InventoryType = .food
    @State private var name: String = ""
    @State private var quantity: String = ""
    @State private var unit: String = "gr"
    
    let unitOptions = ["g", "kg", "lbs", "bags", "cans", "pieces"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Item Details") {
                    Picker("Type", selection: $type) {
                        ForEach(InventoryType.allCases, id: \.self) { type in
                            Label(type.rawValue, systemImage: type.systemImage)
                                .tag(type)
                        }
                    }
                    
                    TextField("Name", text: $name)
                    
                    HStack {
                        TextField("Quantity", text: $quantity)
                            .keyboardType(.decimalPad)
                        
                        Picker("Unit", selection: $unit) {
                            ForEach(unitOptions, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
            }
            .navigationTitle("Add Inventory Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        saveItem()
                    }
                    .disabled(name.isEmpty || quantity.isEmpty)
                }
            }
        }
    }
    
    private func saveItem() {
        guard let quantityValue = Double(quantity) else { return }
        
        let item = InventoryItem(
            type: type,
            name: name,
            quantity: quantityValue,
            unit: unit
        )
        
        modelContext.insert(item)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Failed to save inventory item: \(error)")
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: InventoryItem.self, configurations: config)
    
    return AddInventoryItemView()
        .modelContainer(container)
}

