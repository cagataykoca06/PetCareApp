//
//  PetDetailView.swift
//  Meadow
//
//  Created on [Date]
//

import SwiftUI
import SwiftData
import UIKit

struct PetDetailView: View {
    @Environment(\.modelContext) private var modelContext
    let pet: Pet
    @Query private var events: [CareEvent]
    @Query private var expenses: [Expense]
    
    private var petEvents: [CareEvent] {
        events.filter { $0.pet?.id == pet.id }
    }
    
    private var petExpenses: [Expense] {
        expenses.filter { $0.pet?.id == pet.id }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Photo/Icon
                if let photoData = pet.photoData, let uiImage = UIImage(data: photoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.green)
                        .frame(width: 120, height: 120)
                        .background(Color.green.opacity(0.1))
                        .clipShape(Circle())
                }
                
                // Info
                VStack(spacing: 8) {
                    Text(pet.name)
                        .font(.system(size: 28, weight: .bold))
                        .tracking(-0.5)
                    
                    Text(pet.species)
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    if let age = pet.age {
                        Text(age)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Stats
                HStack(spacing: 32) {
                    VStack {
                        Text("\(petEvents.count)")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Events")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack {
                        Text(petExpenses.reduce(0) { $0 + $1.amount }, format: .currency(code: "USD"))
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Expenses")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(16)
                
                // Recent Events
                if !petEvents.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Events")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(Array(petEvents.prefix(5))) { event in
                            EventRowView(event: event)
                                .padding(.horizontal)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle(pet.name)
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Pet.self, CareEvent.self, Expense.self, configurations: config)
    let pet = Pet(name: "Fluffy", species: "Cat")
    
    return NavigationStack {
        PetDetailView(pet: pet)
    }
    .modelContainer(container)
}

