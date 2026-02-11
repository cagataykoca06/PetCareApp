//
//  StatsViewModel.swift
//  Meadow
//

import Foundation
import Combine

enum TimeRange: String, CaseIterable {
    case week = "Last 7 Days"
    case twoWeeks = "Last 15 Days"
    case month = "Last 30 Days"
    case threeMonths = "Last 3 Months"
    case sixMonths = "Last 6 Months"
    case year = "Last Year"
    case multiYear = "All Time"
    
    var days: Int? {
        switch self {
        case .week: return 7
        case .twoWeeks: return 15
        case .month: return 30
        case .threeMonths: return 90
        case .sixMonths: return 180
        case .year: return 365
        case .multiYear: return nil
        }
    }
}

@MainActor
class StatsViewModel: ObservableObject {
    @Published var selectedTimeRange: TimeRange = .month
    @Published var selectedPetId: UUID? = nil
    @Published var expenses: [Expense] = []
    @Published var events: [CareEvent] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showPaywall = false
    
    private let expenseRepository: ExpenseRepository
    private let eventRepository: EventRepository
    private let container: AppContainer
    private let userProfile: UserProfile?
    
    init(container: AppContainer, userProfile: UserProfile?) {
        self.container = container
        self.expenseRepository = container.expenseRepository
        self.eventRepository = container.eventRepository
        self.userProfile = userProfile
    }
    
    var dateRange: (start: Date, end: Date) {
        let end = Date()
        let start: Date
        
        if let days = selectedTimeRange.days {
            start = Calendar.current.date(byAdding: .day, value: -days, to: end) ?? end
        } else {
            // All time - use a date far in the past
            start = Calendar.current.date(byAdding: .year, value: -10, to: end) ?? end
        }
        
        return (start, end)
    }
    
    var requiresPremium: Bool {
        guard let userProfile = userProfile else { return true }
        
        // Free tier: only last 30 days
        if selectedTimeRange == .month || selectedTimeRange == .twoWeeks || selectedTimeRange == .week {
            return false
        }
        
        return !userProfile.canAccessPremiumFeatures
    }
    
    func loadData() async {
        // Check premium requirement
        if requiresPremium {
            showPaywall = true
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let range = dateRange
        
        do {
            if let petId = selectedPetId {
                expenses = try await expenseRepository.fetch(for: petId, from: range.start, to: range.end)
                events = try await eventRepository.fetch(for: petId, from: range.start, to: range.end)
            } else {
                expenses = try await expenseRepository.fetch(from: range.start, to: range.end)
                events = try await eventRepository.fetch(from: range.start, to: range.end)
            }
        } catch {
            errorMessage = "Failed to load stats: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}

