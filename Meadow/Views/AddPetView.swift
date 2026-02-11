//
//  AddPetView.swift
//  Meadow
//
//  Created on 25.01.2025
//

import SwiftUI
import SwiftData
import PhotosUI
import UIKit

struct AddPetView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var name: String = ""
    @State private var species: String = "Cat"
    @State private var birthDate: Date?
    @State private var weight: String = ""
    @State private var height: String = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var photoData: Data?
    @State private var showingDatePicker = false
    
    let speciesOptions = ["Cat", "Dog", "Bird", "Rabbit", "Hamster", "Other"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Basic Info") {
                    TextField("Name", text: $name)
                    
                    Picker("Species", selection: $species) {
                        ForEach(speciesOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                }
                
                Section("Photo") {
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        HStack {
                            if let photoData = photoData, let uiImage = UIImage(data: photoData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "photo")
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                            }
                            Text("Select Photo")
                                .foregroundColor(.blue)
                        }
                    }
                    .onChange(of: selectedPhoto) { _, newValue in
                        Task {
                            if let data = try? await newValue?.loadTransferable(type: Data.self) {
                                photoData = data
                            }
                        }
                    }
                }
                
                Section("Optional Details") {
                    Toggle("Add Age", isOn: Binding(
                        get: { birthDate != nil },
                        set: { if $0 { birthDate = Date() } else { birthDate = nil } }
                    ))
                    
                    if birthDate != nil {
                        DatePicker("Birth Date", selection: Binding(
                            get: { birthDate ?? Date() },
                            set: { birthDate = $0 }
                        ), displayedComponents: .date)
                    }
                    
                    TextField("Weight (kg)", text: $weight)
                        .keyboardType(.decimalPad)
                    
                    TextField("Height (cm)", text: $height)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Add Pet")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        savePet()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func savePet() {
        let pet = Pet(
            name: name,
            species: species,
            birthDate: birthDate,
            photoData: photoData,
            weight: weight.isEmpty ? nil : Double(weight),
            height: height.isEmpty ? nil : Double(height)
        )
        
        modelContext.insert(pet)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Failed to save pet: \(error)")
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Pet.self, configurations: config)
    
    return AddPetView()
        .modelContainer(container)
}

