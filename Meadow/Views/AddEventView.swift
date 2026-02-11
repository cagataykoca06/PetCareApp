//
//  AddEventView.swift
//  Meadow
//
//  Created on 25.01.2025
//

import SwiftUI
import SwiftData

/// Defines the context/mode for adding events
enum AddEventMode {
    case feedingOnly  // Food tab: only feeding, no type picker
    case careOnly     // Paw tab: all types except feeding
    case all          // Home: all event types
}

struct AddEventView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var pets: [Pet]
    
    let mode: AddEventMode
    @State private var selectedType: CareEventType
    @State private var selectedPetId: UUID?
    @State private var notes: String = ""
    @State private var date: Date = Date()
    
    // Feeding-specific states
    @State private var isSpecialFood: Bool = false
    @State private var foodGrams: String = ""
    @State private var selectedFlavor: String? = nil
    @State private var customFlavor: String = ""
    @State private var showCustomFlavorInput = false
    
    // Walk-specific states
    @State private var walkDurationMinutes: Int? = nil
    
    private let commonFlavors = ["Salmon", "Chicken", "Beef", "Turkey", "Tuna", "Lamb"]
    
    private var relativeTimeString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    // Computed properties for pet selection logic
    private var petsCount: Int {
        pets.count
    }
    
    private var singlePet: Pet? {
        pets.count == 1 ? pets.first : nil
    }
    
    private var selectedPet: Pet? {
        guard let selectedPetId = selectedPetId else { return nil }
        return pets.first(where: { $0.id == selectedPetId })
    }
    
    private var shouldShowPetPicker: Bool {
        pets.count > 1
    }
    
    private var walkDurationLabel: String {
        guard let minutes = walkDurationMinutes else { return "15 min" }
        switch minutes {
        case 15: return "15 min"
        case 30: return "30 min"
        case 45: return "45 min"
        case 60: return "1 hour"
        case 120: return "2 hours"
        case 180: return "3 hours"
        default: return "\(minutes) min"
        }
    }
    
    private var availableEventTypes: [CareEventType] {
        switch mode {
        case .feedingOnly:
            return [.feeding]
        case .careOnly:
            return CareEventType.allCases.filter { $0 != .feeding }
        case .all:
            return CareEventType.allCases
        }
    }
    
    init(mode: AddEventMode = .all) {
        self.mode = mode
        // Set initial selected type based on mode
        switch mode {
        case .feedingOnly:
            _selectedType = State(initialValue: .feeding)
        case .careOnly:
            _selectedType = State(initialValue: .litter) // First non-feeding type
        case .all:
            _selectedType = State(initialValue: .feeding)
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // Only show Event Type section if not feedingOnly mode
                if mode != .feedingOnly {
                    Section("Event Type") {
                        Picker("Type", selection: $selectedType) {
                            ForEach(availableEventTypes, id: \.self) { type in
                                Label(type.rawValue, systemImage: type.systemImage)
                                    .tag(type)
                            }
                        }
                    }
                    .appTextColor()
                    .listRowBackground(Color.white.opacity(0.1))
                }
                
                Section("Pet") {
                    if shouldShowPetPicker {
                        // Show picker when user has 2+ pets
                        Picker("Pet", selection: $selectedPetId) {
                            Text("Select Your Pet").tag(nil as UUID?)
                            ForEach(pets) { pet in
                                Text(pet.name).tag(pet.id as UUID?)
                            }
                        }
                    } else if let pet = singlePet {
                        // Show pet name as plain text when there's exactly 1 pet
                        Text(pet.name)
                            .appTextColor()
                    } else {
                        // 0 pets: keep current behavior (picker with no options)
                        Picker("Pet", selection: $selectedPetId) {
                            Text("Select Your Pet").tag(nil as UUID?)
                            ForEach(pets) { pet in
                                Text(pet.name).tag(pet.id as UUID?)
                            }
                        }
                    }
                }
                .appTextColor()
                .listRowBackground(Color.white.opacity(0.1))
                
                // Walk-specific section (before Details)
                if selectedType == .walk {
                    Section {
                        HStack {
                            Spacer()
                            
                            Menu {
                                Button("30 min") { walkDurationMinutes = 30 }
                                Button("45 min") { walkDurationMinutes = 45 }
                                Button("1 hour") { walkDurationMinutes = 60 }
                                Button("2 hours") { walkDurationMinutes = 120 }
                                Button("3 hours") { walkDurationMinutes = 180 }
                            } label: {
                                HStack {
                                    Text(walkDurationLabel)
                                        .appTextColor()
                                    Image(systemName: "chevron.down")
                                        .font(.caption)
                                        .foregroundColor(AppColors.text)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(8)
                            }
                        }
                    } header: {
                        Label("Time", systemImage: "clock.fill")
                            .appTextColor()
                    }
                    .appTextColor()
                    .listRowBackground(Color.white.opacity(0.1))
                }
                
                Section("Details") {
                    TextField("Notes (optional)", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                        .appTextColor()
                }
                .appTextColor()
                .listRowBackground(Color.white.opacity(0.1))
                
                // Feeding-specific section
                if selectedType == .feeding {
                    Section("Feeding Details") {
                        // Ordinary vs Special Food
                        Picker("Food Type", selection: $isSpecialFood) {
                            Text("Ordinary Food").tag(false)
                            Text("Special Food").tag(true)
                        }
                        .pickerStyle(.segmented)
                        .appTextColor()
                        
                        // Grams input with presets
                        HStack {
                            Text("Grams")
                                .appTextColor()
                            
                            Spacer()
                            
                            Menu {
                                Button("50g") { foodGrams = "50" }
                                Button("100g") { foodGrams = "100" }
                                Button("250g") { foodGrams = "250" }
                                Button("1000g (1kg)") { foodGrams = "1000" }
                            } label: {
                                Image(systemName: "list.bullet")
                                    .foregroundColor(AppColors.text)
                                    .padding(8)
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(8)
                            }
                            
                            TextField("0", text: $foodGrams)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 80)
                                .appTextColor()
                        }
                        
                        // Flavor selection
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Food Flavor")
                                .appTextColor()
                                .font(AppFonts.headline)
                            
                            // Flavor chips
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 8) {
                                ForEach(commonFlavors, id: \.self) { flavor in
                                    FlavorChip(
                                        flavor: flavor,
                                        isSelected: selectedFlavor == flavor,
                                        action: {
                                            if selectedFlavor == flavor {
                                                selectedFlavor = nil
                                            } else {
                                                selectedFlavor = flavor
                                                showCustomFlavorInput = false
                                                customFlavor = ""
                                            }
                                        }
                                    )
                                }
                                
                                // Other option
                                FlavorChip(
                                    flavor: "Other",
                                    isSelected: showCustomFlavorInput,
                                    action: {
                                        showCustomFlavorInput.toggle()
                                        if !showCustomFlavorInput {
                                            customFlavor = ""
                                            selectedFlavor = nil
                                        } else {
                                            selectedFlavor = nil
                                        }
                                    }
                                )
                            }
                            
                            // Custom flavor input
                            if showCustomFlavorInput {
                                TextField("Enter custom flavor", text: $customFlavor)
                                    .appTextColor()
                            }
                        }
                    }
                    .appTextColor()
                    .listRowBackground(Color.white.opacity(0.1))
                }
            }
            .scrollContentBackground(.hidden)
            .appBackground()
            .navigationTitle(mode == .feedingOnly ? "Add Feeding" : "Add Event")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                // Auto-select pet when there's exactly 1 pet
                if let singlePet = singlePet, selectedPetId == nil {
                    selectedPetId = singlePet.id
                }
                // Set default walk duration if starting with walk type
                if selectedType == .walk && walkDurationMinutes == nil {
                    walkDurationMinutes = 15
                }
            }
            .onChange(of: selectedType) { _, newType in
                // Set default walk duration when switching to walk
                if newType == .walk && walkDurationMinutes == nil {
                    walkDurationMinutes = 15
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .appTextColor()
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveEvent()
                    }
                    .disabled(selectedPetId == nil && petsCount > 1)
                    .appTextColor()
                }
            }
        }
        .appBackground()
    }
    
    private func saveEvent() {
        guard let petId = selectedPetId,
              let pet = pets.first(where: { $0.id == petId }) else { return }
        
        // Parse food grams
        let grams: Double? = {
            if let gramsValue = Double(foodGrams), gramsValue > 0 {
                return gramsValue
            }
            return nil
        }()
        
        // Determine final flavor
        let finalFlavor: String? = {
            if showCustomFlavorInput && !customFlavor.isEmpty {
                return customFlavor
            } else if let flavor = selectedFlavor {
                return flavor
            }
            return nil
        }()
        
        // Set feeding-specific fields only for feeding events
        let isSpecial: Bool? = selectedType == .feeding ? isSpecialFood : nil
        
        // Set walk-specific fields only for walk events
        let duration: Int? = selectedType == .walk ? walkDurationMinutes : nil
        
        let event = CareEvent(
            type: selectedType,
            date: date,
            notes: notes,
            isSpecialFood: isSpecial,
            foodGrams: grams,
            foodFlavor: finalFlavor,
            durationMinutes: duration,
            pet: pet
        )
        
        modelContext.insert(event)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Failed to save event: \(error)")
        }
    }
}

struct FlavorChip: View {
    let flavor: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(flavor)
                .font(AppFonts.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(isSelected ? AppColors.text : Color.white.opacity(0.2))
                .foregroundColor(isSelected ? AppColors.background : AppColors.text)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(AppColors.text, lineWidth: isSelected ? 0 : 1)
                )
        }
        .contentShape(Rectangle())
        .buttonStyle(.plain)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Pet.self, CareEvent.self, configurations: config)
    
    AddEventView()
        .modelContainer(container)
        .background(Color(red: 0.95, green: 0.65, blue: 0.68).ignoresSafeArea())
}
