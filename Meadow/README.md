# Meadow

A comprehensive pet care tracking app for iOS, iPadOS, and macOS (via Catalyst). Track daily care events, expenses, necessities, and inventory—all while keeping your data private and local-first.

---

## Product Overview

Meadow helps pet owners maintain consistent care routines, track expenses, and monitor their pets' health over time. Built with privacy in mind, the MVP requires no account and stores all data locally on your device.

### Key Features (MVP)

- **Pet Management:** Create profiles for multiple pets with optional photos and details
- **Care Event Tracking:** Log feeding, litter cleaning, walks, vet visits, vaccines, and custom events
- **Expense Tracking:** Track expenses per pet or household, categorized and linked to events
- **Necessities To-Do:** Manage care-related tasks with completion tracking
- **Storage Inventory:** Monitor food and litter quantities at home
- **Stats & Charts:** View insights with Swift Charts (last 30 days free, unlimited with premium)
- **Premium Subscriptions:** $0.99/month or $9.99/year for unlimited historical stats
- **Notifications:** Opt-in daily reminders if you haven't logged care that day

---

## Architecture Overview

### MVVM Pattern

```
Views (SwiftUI)
  ↓
ViewModels (State + Intents)
  ↓
Services/Repositories (Protocols)
  ↓
Data Layer (SwiftData)
```

### Project Structure

```
Meadow/
├── App/
│   ├── MeadowApp.swift
│   └── AppContainer.swift
├── Models/
│   ├── UserProfile.swift
│   ├── Pet.swift
│   ├── CareEvent.swift
│   ├── Expense.swift
│   ├── NecessityItem.swift
│   └── InventoryItem.swift
├── Repositories/
│   ├── Protocols/
│   │   ├── PetRepository.swift
│   │   ├── EventRepository.swift
│   │   ├── ExpenseRepository.swift
│   │   ├── NecessityRepository.swift
│   │   └── InventoryRepository.swift
│   └── Implementations/
│       └── SwiftDataRepository.swift
├── ViewModels/
│   ├── HomeViewModel.swift
│   ├── PetListViewModel.swift
│   ├── EventListViewModel.swift
│   ├── ExpenseListViewModel.swift
│   ├── StatsViewModel.swift
│   └── ProfileViewModel.swift
├── Views/
│   ├── Home/
│   ├── Food/
│   ├── Paw/
│   ├── Storage/
│   └── Profile/
├── Services/
│   ├── SubscriptionService.swift
│   └── NotificationService.swift
└── Utilities/
    ├── Extensions/
    └── MockData.swift
```

### Key Design Decisions

1. **Local-First:** SwiftData for persistence, no cloud sync in MVP
2. **Dependency Injection:** AppContainer holds all services
3. **Protocol-Based:** Repositories are protocols for testability
4. **SwiftUI Previews:** All screens have working previews with mock data

---

## How to Run

### Prerequisites

- Xcode 15.0+
- iOS 17.0+ (for SwiftData and Swift Charts)
- macOS 14.0+ (for Mac Catalyst)

### Setup

1. Clone the repository
2. Open `Meadow.xcodeproj` in Xcode
3. Select your target device (iPhone, iPad, or Mac)
4. Build and run (⌘R)

### First Launch

1. Create a local profile (name only, no login required)
2. Add your first pet
3. Start logging care events

### Testing Premium

- In Simulator, use the "Test Purchase" button in the paywall
- In Sandbox, sign in with a test Apple ID

---

## MVP Feature List

### ✅ Implemented

- [x] Local profile creation (no auth)
- [x] Trial status tracking (1 month free)
- [x] Pet CRUD (create, list, detail)
- [x] Optional pet photos
- [x] Care event logging (all types)
- [x] Expense tracking
- [x] Necessities to-do list
- [x] Storage inventory
- [x] Stats & charts (Swift Charts)
- [x] Time range filters (7d-1y+)
- [x] Pet filters (individual/all)
- [x] Premium paywall (StoreKit 2)
- [x] Subscription gating (stats > 30 days)
- [x] Opt-in notifications
- [x] Tab bar navigation
- [x] iPad + Mac Catalyst support

### 🚧 In Progress

- Currently in Sprint 1-7 (see SPRINT_BACKLOG.md)

### 📋 Coming Next (v1.1)

- Firebase cloud sync
- Inventory low stock alerts
- Data export (CSV)
- Enhanced charts
- Reference wiki expansion

See [BACKLOG.md](./BACKLOG.md) for full roadmap.

---

## Development

### Code Style

- Swift concurrency (async/await) where appropriate
- MVVM architecture strictly followed
- Protocol-oriented design
- No overengineering—prefer readable, modular code

### Testing

- Unit tests for ViewModels
- Integration tests for repositories
- SwiftUI Previews for all screens
- Manual testing on iPhone, iPad, Mac

### Accessibility

- VoiceOver labels for all interactive elements
- Dynamic Type support
- WCAG AA color contrast
- Accessible charts

---

## Design Principles

1. **Clean & Premium:** Negative letter spacing for headings (-2% to -4%)
2. **Privacy-First:** Local data, no tracking, opt-in notifications
3. **Simple Onboarding:** Minimal steps to start using
4. **Progressive Disclosure:** Free features first, premium value clear
5. **Consistent Icons:** SF Symbols throughout
6. **Readable:** Dynamic Type support, good contrast

---

## Project Status

**Current Phase:** MVP Development (Sprints 1-7)  
**Target Launch:** Post-Sprint 7  
**Version:** 0.1.0 (MVP)

See [PRODUCT_PIPELINE.md](./PRODUCT_PIPELINE.md) for detailed phases and milestones.

---

## Documentation

- [Product Pipeline](./PRODUCT_PIPELINE.md) - Phases, milestones, sprint plan
- [MVP PRD](./MVP_PRD.md) - Product requirements, personas, journeys
- [Sprint Backlog](./SPRINT_BACKLOG.md) - Detailed sprint tasks
- [Release Checklist](./RELEASE_CHECKLIST.md) - Pre-launch checklist
- [Backlog](./BACKLOG.md) - Post-MVP features and roadmap

---

## License

Unlicensed (as per project requirements). All icons use SF Symbols or custom vector shapes. No copyrighted imagery.

---

## Support

For issues, feature requests, or questions, please open an issue in the repository.

---

**Built with ❤️ using SwiftUI and SwiftData**

