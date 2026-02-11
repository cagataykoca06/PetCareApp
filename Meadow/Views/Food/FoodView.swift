//
//  FoodView.swift
//  Meadow
//
//  Created on [Date]
//

import SwiftUI
import SwiftData

struct FoodView: View {
    @EnvironmentObject var container: AppContainer
    @Query(filter: #Predicate<CareEvent> { $0.type == "Feeding" }, sort: \CareEvent.date, order: .reverse) private var feedingEvents: [CareEvent]
    @Query private var pets: [Pet]
    @Query private var profiles: [UserProfile]
    @State private var showingAddEvent = false
    @State private var expandedEventIds: Set<UUID> = []
    
    private var userProfile: UserProfile? { profiles.first }
    private var firstPet: Pet? { pets.first }
    
    var body: some View {
        NavigationStack {
            List {
                // Feeding Guidance Card
                if let pet = firstPet {
                    FeedingGuidanceCard(
                        pet: pet,
                        feedingEvents: feedingEvents,
                        defaultKcalPer100g: userProfile?.defaultFoodKcalPer100g ?? 350.0
                    )
                    .listRowBackground(Color.white.opacity(0.1))
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                }
                
                ForEach(feedingEvents) { event in
                    FeedingRowView(
                        event: event,
                        isExpanded: expandedEventIds.contains(event.id),
                        onTap: {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                if expandedEventIds.contains(event.id) {
                                    expandedEventIds.remove(event.id)
                                } else {
                                    expandedEventIds.insert(event.id)
                                }
                            }
                        }
                    )
                    .listRowBackground(Color.white.opacity(0.1))
                }
            }
            .scrollContentBackground(.hidden)
            .background(AppColors.background.ignoresSafeArea())
            .navigationTitle("Food")
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
                AddEventView(mode: .feedingOnly)
            }
        }
        .background(AppColors.background.ignoresSafeArea())
    }
}

// MARK: - Feeding Guidance Card
private struct FeedingGuidanceCard: View {
    let pet: Pet
    let feedingEvents: [CareEvent]
    let defaultKcalPer100g: Double
    
    private var guidance: FeedingGuidance? {
        FeedingGuidance.calculate(
            for: pet,
            feedingEvents: feedingEvents,
            defaultKcalPer100g: defaultKcalPer100g
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let guidance = guidance {
                HStack {
                    Image(systemName: "chart.bar.fill")
                        .foregroundColor(AppColors.text)
                    Text("2-Day Feeding Target")
                        .font(AppFonts.headline)
                        .appTextColor()
                }
                
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Target")
                            .font(AppFonts.caption)
                            .appTextColor()
                            .opacity(0.7)
                        Text("\(Int(guidance.twoDayTargetGrams))g")
                            .font(AppFonts.headline)
                            .appTextColor()
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Logged")
                            .font(AppFonts.caption)
                            .appTextColor()
                            .opacity(0.7)
                        Text("\(Int(guidance.loggedGrams))g")
                            .font(AppFonts.headline)
                            .appTextColor()
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Remaining")
                            .font(AppFonts.caption)
                            .appTextColor()
                            .opacity(0.7)
                        Text("\(Int(max(0, guidance.remainingGrams)))g")
                            .font(AppFonts.headline)
                            .foregroundColor(guidance.remainingGrams <= 0 ? .green : AppColors.text)
                    }
                }
                
                Text("Estimate only — not veterinary advice.")
                    .font(.system(size: 10))
                    .appTextColor()
                    .opacity(0.5)
            } else if pet.weight == nil {
                HStack {
                    Image(systemName: "scalemass.fill")
                        .foregroundColor(AppColors.text.opacity(0.6))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Add weight to enable feeding estimates")
                            .font(AppFonts.subheadline)
                            .appTextColor()
                        Text("Go to Profile → \(pet.name) to add weight.")
                            .font(AppFonts.caption)
                            .appTextColor()
                            .opacity(0.7)
                    }
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.15))
        .cornerRadius(12)
    }
}

// MARK: - Feeding Guidance Calculation
struct FeedingGuidance {
    let dailyGrams: Double
    let twoDayTargetGrams: Double
    let loggedGrams: Double
    let remainingGrams: Double
    
    /// Calculate feeding guidance based on pet data and recent events
    static func calculate(
        for pet: Pet,
        feedingEvents: [CareEvent],
        defaultKcalPer100g: Double
    ) -> FeedingGuidance? {
        // Require weight
        guard let weightKg = pet.weight, weightKg > 0 else { return nil }
        
        // RER = 70 * (weight ^ 0.75)
        let rer = 70 * pow(weightKg, 0.75)
        
        // Daily factor by species
        let dailyFactor: Double
        switch pet.species.lowercased() {
        case "cat":
            dailyFactor = 1.2
        case "dog":
            dailyFactor = 1.6
        default:
            dailyFactor = 1.2
        }
        
        // Estimated daily calories
        let dailyCalories = rer * dailyFactor
        
        // kcal per 100g (use pet override or default)
        let kcalPer100g = pet.foodKcalPer100g ?? defaultKcalPer100g
        
        // Convert to grams: dailyCalories / (kcal/g)
        let dailyGrams = dailyCalories / (kcalPer100g / 100.0)
        let twoDayTarget = dailyGrams * 2
        
        // Sum logged grams in last 2 days
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date()
        let recentFeedings = feedingEvents.filter { $0.date >= twoDaysAgo }
        let loggedGrams = recentFeedings.compactMap { $0.foodGrams }.reduce(0, +)
        
        return FeedingGuidance(
            dailyGrams: dailyGrams,
            twoDayTargetGrams: twoDayTarget,
            loggedGrams: loggedGrams,
            remainingGrams: twoDayTarget - loggedGrams
        )
    }
}

// MARK: - Feeding Row View (Food screen only)
private struct FeedingRowView: View {
    let event: CareEvent
    let isExpanded: Bool
    let onTap: () -> Void
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM HH:mm"
        return formatter.string(from: event.date)
    }
    
    /// Collapsed summary: grams + flavor only (no Ordinary/Special, no bullets)
    private var collapsedSummary: String? {
        var parts: [String] = []
        
        if let grams = event.foodGrams {
            parts.append("\(Int(grams))g")
        }
        
        if let flavor = event.foodFlavor, !flavor.isEmpty {
            parts.append(flavor)
        }
        
        return parts.isEmpty ? nil : parts.joined(separator: " ")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Main row content
            HStack {
                Image(systemName: event.eventType.systemImage)
                    .foregroundColor(AppColors.text)
                    .frame(width: 32)
                
                VStack(alignment: .leading, spacing: 4) {
                    if let summary = collapsedSummary {
                        Text(summary)
                            .font(AppFonts.headline)
                            .appTextColor()
                    }
                    
                    if let pet = event.pet {
                        Text(pet.name)
                            .font(AppFonts.subheadline)
                            .appTextColor()
                            .opacity(0.8)
                    }
                }
                
                Spacer()
                
                Text(formattedDate)
                    .font(AppFonts.caption)
                    .appTextColor()
                    .opacity(0.8)
            }
            
            // Expanded details
            if isExpanded {
                VStack(alignment: .leading, spacing: 4) {
                    if let isSpecial = event.isSpecialFood {
                        Text(isSpecial ? "Special" : "Ordinary")
                            .font(AppFonts.subheadline)
                            .appTextColor()
                            .opacity(0.8)
                    }
                    
                    if let grams = event.foodGrams {
                        Text("\(Int(grams))g")
                            .font(AppFonts.subheadline)
                            .appTextColor()
                            .opacity(0.8)
                    }
                    
                    if let flavor = event.foodFlavor, !flavor.isEmpty {
                        Text(flavor)
                            .font(AppFonts.subheadline)
                            .appTextColor()
                            .opacity(0.8)
                    }
                }
                .padding(.leading, 40)
            }
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(12)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: CareEvent.self, Pet.self, configurations: config)
    let appContainer = AppContainer.create(modelContainer: container)
    
    return FoodView()
        .environmentObject(appContainer)
        .modelContainer(container)
}

