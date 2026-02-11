//
//  ProfileView.swift
//  Meadow
//
//  Created on [Date]
//

import SwiftUI
import SwiftData
import UIKit

struct ProfileView: View {
    @EnvironmentObject var container: AppContainer
    @Query private var pets: [Pet]
    @Query private var profiles: [UserProfile]
    @State private var showingAddPet = false
    @State private var showingPaywall = false
    
    var userProfile: UserProfile? {
        profiles.first
    }
    
    var body: some View {
        NavigationStack {
            List {
                // User Info
                if let profile = userProfile {
                    Section {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.green)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(profile.name)
                                    .font(.headline)
                                Text(profile.isPremium ? "Premium" : profile.isTrialActive ? "Free Trial" : "Free")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                // Pets
                Section("Pets") {
                    ForEach(pets) { pet in
                        NavigationLink {
                            PetDetailView(pet: pet)
                        } label: {
                            PetRowView(pet: pet)
                        }
                    }
                    
                    Button {
                        showingAddPet = true
                    } label: {
                        Label("Add Pet", systemImage: "plus")
                    }
                }
                
                // Premium
                Section("Premium") {
                    if let profile = userProfile, !profile.canAccessPremiumFeatures {
                        Button {
                            showingPaywall = true
                        } label: {
                            HStack {
                                Image(systemName: "crown.fill")
                                    .foregroundColor(.yellow)
                                Text("Upgrade to Premium")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                            }
                        }
                    } else {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Premium Active")
                        }
                    }
                }
                
                // Settings
                Section("Settings") {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Label("Settings", systemImage: "gearshape")
                    }
                }
            }
            .navigationTitle("Profile")
            .sheet(isPresented: $showingAddPet) {
                AddPetView()
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
            }
        }
    }
}

struct PetRowView: View {
    let pet: Pet
    
    var body: some View {
        HStack {
            if let photoData = pet.photoData, let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } else {
                Image(systemName: "pawprint.fill")
                    .font(.title2)
                    .foregroundColor(.green)
                    .frame(width: 50, height: 50)
                    .background(Color.green.opacity(0.1))
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(pet.name)
                    .font(.headline)
                Text(pet.species)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: UserProfile.self, Pet.self, configurations: config)
    let appContainer = AppContainer.create(modelContainer: container)
    
    return ProfileView()
        .environmentObject(appContainer)
        .modelContainer(container)
}

