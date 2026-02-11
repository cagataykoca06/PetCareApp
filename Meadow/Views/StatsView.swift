//
//  StatsView.swift
//  Meadow
//
//  Created on [Date]
//

import SwiftUI
import SwiftData
import Charts

struct StatsView: View {
    @EnvironmentObject var container: AppContainer
    @Environment(\.dismiss) private var dismiss
    @Query private var pets: [Pet]
    @Query private var profiles: [UserProfile]
    @State private var viewModel: StatsViewModel?
    
    var userProfile: UserProfile? {
        profiles.first
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Filters
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Time Range")
                            .font(.headline)
                        
                        if let viewModel = viewModel {
                            Picker("Time Range", selection: Binding(
                                get: { viewModel.selectedTimeRange },
                                set: { viewModel.selectedTimeRange = $0 }
                            )) {
                                ForEach(TimeRange.allCases, id: \.self) { range in
                                    Text(range.rawValue).tag(range)
                                }
                            }
                            .pickerStyle(.segmented)
                            
                            Text("Pet Filter")
                                .font(.headline)
                                .padding(.top)
                            
                            Picker("Pet", selection: Binding(
                                get: { viewModel.selectedPetId },
                                set: { viewModel.selectedPetId = $0 }
                            )) {
                                Text("All Pets").tag(nil as UUID?)
                                ForEach(pets) { pet in
                                    Text(pet.name).tag(pet.id as UUID?)
                                }
                            }
                            .pickerStyle(.menu)
                        }
                    }
                    .padding()
                    
                    if let viewModel = viewModel {
                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity, minHeight: 200)
                        } else if viewModel.showPaywall {
                            PaywallPromptView {
                                viewModel.showPaywall = true
                            }
                        } else {
                            // Expenses Chart
                            if !viewModel.expenses.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Expenses Over Time")
                                        .font(.headline)
                                        .padding(.horizontal)
                                    
                                    Chart {
                                        ForEach(groupedExpenses(for: viewModel), id: \.date) { data in
                                            BarMark(
                                                x: .value("Date", data.date, unit: .day),
                                                y: .value("Amount", data.amount)
                                            )
                                            .foregroundStyle(.blue)
                                        }
                                    }
                                    .frame(height: 200)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(16)
                                    .padding(.horizontal)
                                }
                            }
                            
                            // Events Chart
                            if !viewModel.events.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Care Events Over Time")
                                        .font(.headline)
                                        .padding(.horizontal)
                                    
                                    Chart {
                                        ForEach(groupedEvents(for: viewModel), id: \.date) { data in
                                            BarMark(
                                                x: .value("Date", data.date, unit: .day),
                                                y: .value("Count", data.count)
                                            )
                                            .foregroundStyle(.green)
                                        }
                                    }
                                    .frame(height: 200)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(16)
                                    .padding(.horizontal)
                                }
                            }
                            
                            if viewModel.expenses.isEmpty && viewModel.events.isEmpty {
                                VStack(spacing: 8) {
                                    Image(systemName: "chart.bar")
                                        .font(.system(size: 40))
                                        .foregroundColor(.secondary)
                                    Text("No data for this period")
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 40)
                            }
                        }
                    } else {
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 200)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Stats")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if viewModel == nil {
                    viewModel = StatsViewModel(container: container, userProfile: userProfile)
                }
            }
            .task {
                if let viewModel = viewModel {
                    await viewModel.loadData()
                }
            }
            .onChange(of: viewModel?.selectedTimeRange) { _, _ in
                Task {
                    if let viewModel = viewModel {
                        await viewModel.loadData()
                    }
                }
            }
            .onChange(of: viewModel?.selectedPetId) { _, _ in
                Task {
                    if let viewModel = viewModel {
                        await viewModel.loadData()
                    }
                }
            }
            .sheet(isPresented: Binding(
                get: { viewModel?.showPaywall ?? false },
                set: { if let viewModel = viewModel { viewModel.showPaywall = $0 } }
            )) {
                PaywallView()
            }
        }
    }
    
    private func groupedExpenses(for viewModel: StatsViewModel) -> [(date: Date, amount: Double)] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: viewModel.expenses) { expense in
            calendar.startOfDay(for: expense.date)
        }
        
        return grouped.map { (date, expenses) in
            (date: date, amount: expenses.reduce(0) { $0 + $1.amount })
        }.sorted { $0.date < $1.date }
    }
    
    private func groupedEvents(for viewModel: StatsViewModel) -> [(date: Date, count: Int)] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: viewModel.events) { event in
            calendar.startOfDay(for: event.date)
        }
        
        return grouped.map { (date, events) in
            (date: date, count: events.count)
        }.sorted { $0.date < $1.date }
    }
}

struct PaywallPromptView: View {
    let onUpgrade: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "crown.fill")
                .font(.system(size: 50))
                .foregroundColor(.yellow)
            
            Text("Premium Required")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Upgrade to Premium to view stats beyond 30 days")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Button {
                onUpgrade()
            } label: {
                Text("Upgrade Now")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: UserProfile.self, Pet.self, CareEvent.self, Expense.self, configurations: config)
    let appContainer = AppContainer.create(modelContainer: container)
    
    return StatsView()
        .environmentObject(appContainer)
        .modelContainer(container)
}

