//
//  HomeViewModel.swift
//  Meadow
//

import Foundation
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var recentEvents: [CareEvent] = []
    @Published var last24HoursEvents: [CareEvent] = []
    @Published var mostRecentEvent: CareEvent? = nil
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let eventRepository: EventRepository
    private let container: AppContainer
    
    init(container: AppContainer) {
        self.container = container
        self.eventRepository = container.eventRepository
    }
    
    func loadData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Get events from last 24 hours
            let now = Date()
            let last24Hours = Calendar.current.date(byAdding: .hour, value: -24, to: now) ?? now
            
            let events24h = try await eventRepository.fetch(from: last24Hours, to: now)
            last24HoursEvents = events24h.sorted(by: { $0.date > $1.date })
            mostRecentEvent = last24HoursEvents.first
            
            // Get recent events (last 5) for the Recent Events section
            let allEvents = try await eventRepository.fetchAll()
            recentEvents = Array(allEvents.prefix(5))
        } catch {
            errorMessage = "Failed to load data: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    var last24HoursEventTypes: [CareEventType] {
        Array(Set(last24HoursEvents.map { $0.eventType })).sorted(by: { $0.rawValue < $1.rawValue })
    }
    
    var mostRecentEventRelativeTime: String? {
        guard let event = mostRecentEvent else { return nil }
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: event.date, relativeTo: Date())
    }
}

