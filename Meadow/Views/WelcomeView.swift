//
//  WelcomeView.swift
//  Meadow
//
//  Created on [Date]
//

import SwiftUI
import SwiftData

struct WelcomeView: View {
    @EnvironmentObject var container: AppContainer
    @Environment(\.modelContext) private var modelContext
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Image(systemName: "pawprint.fill")
                .font(.system(size: 80))
                .foregroundColor(AppColors.sunflowerGold)
            
            Text("Meadow")
                .font(.system(size: 32, weight: .bold))
                .tracking(-2.0)
                .foregroundColor(.white)
            
            Text("Track your pet's care, expenses, and health all in one place.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            VStack(spacing: 16) {
                Button(action: createProfile) {
                    Text("Get Started")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppColors.sunflowerGold)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .background(AppColors.background.ignoresSafeArea())
        .alert("Error", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func createProfile() {
        // Create profile with default name - user can edit later from Profile screen
        let profile = UserProfile(
            name: "User",
            trialStartDate: Date()
        )
        
        modelContext.insert(profile)
        
        do {
            try modelContext.save()
            // Navigation to Home happens automatically via ContentView's profile check
        } catch {
            alertMessage = "Failed to create profile: \(error.localizedDescription)"
            showingAlert = true
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: UserProfile.self, configurations: config)
    let appContainer = AppContainer.create(modelContainer: container)
    
    return WelcomeView()
        .environmentObject(appContainer)
        .modelContainer(container)
}
