# Meadow - MVP Product Requirements Document

## 1. Product Overview

**Product Name:** Meadow  
**Version:** MVP (v0.1.0)  
**Platform:** iOS (iPhone, iPad), Mac (via Catalyst)  
**Target Launch:** Post-Sprint 7

### Vision Statement
Meadow helps pet owners maintain consistent care routines, track expenses, and monitor their pets' health over time—all while keeping data private and local-first.

---

## 2. Goals

### Primary Goals
1. **Daily Usability:** MVP must be usable end-to-end for daily pet care tracking
2. **Privacy-First:** No account required for first month; all data stored locally
3. **Simple Onboarding:** Create profile and start tracking in < 2 minutes
4. **Premium Path:** Clear value proposition for subscription (stats beyond 1 month)

### Success Criteria
- User can track daily care events for multiple pets
- User can view expenses and necessities in organized views
- User can see basic stats (last 30 days) without premium
- Premium conversion path is clear and frictionless
- App works reliably on iPhone, iPad, and Mac

---

## 3. Personas

### Primary Persona: "The Careful Caregiver"
- **Name:** Sarah, 32
- **Pets:** 2 cats, 1 dog
- **Needs:** Track feeding schedules, litter cleaning, vet visits, expenses
- **Pain Points:** Forgetting daily tasks, losing track of expenses, no historical data
- **Tech Comfort:** High (uses multiple apps daily)

### Secondary Persona: "The New Pet Owner"
- **Name:** Mike, 28
- **Pets:** 1 cat (first pet)
- **Needs:** Learn care routines, track milestones, budget for expenses
- **Pain Points:** Unfamiliar with pet care, wants guidance
- **Tech Comfort:** Medium

---

## 4. Core User Journeys

### Journey 1: First-Time Setup
1. Open app → See welcome screen
2. Create profile (name only, no login)
3. Add first pet (name, species, optional photo)
4. See empty dashboard with "Add your first event" prompt
5. **Success:** User is ready to log events

### Journey 2: Daily Care Logging
1. Open app → See Home tab with today's summary
2. Tap "Quick Add" → Select event type (feeding/litter/walk)
3. Select pet → Add details (optional notes)
4. Save → Event appears in feed
5. **Success:** Event is logged and visible in history

### Journey 3: Expense Tracking
1. Navigate to Food tab or Profile → Expenses
2. Tap "Add Expense"
3. Select pet (or "Household"), category, amount
4. Optionally link to event or necessity
5. Save → Expense appears in list and charts
6. **Success:** Expense is tracked and visible in stats

### Journey 4: Viewing Stats
1. Navigate to Home → Tap "View Stats" (or dedicated section)
2. See charts for last 30 days (free)
3. Try to view 3-month view → See paywall
4. Understand premium value → Consider subscription
5. **Success:** User understands value of premium

### Journey 5: Managing Necessities
1. Navigate to Profile → Necessities
2. Add item (e.g., "Buy cat litter")
3. Mark as done when purchased
4. Optionally link expense
5. **Success:** To-do list helps user stay organized

---

## 5. MVP Scope

### ✅ In Scope (MVP)

#### Core Features
- **Profile Management:** Local profile (no auth), trial tracking
- **Pet Management:** Create, list, detail, optional photo/weight/height
- **Event Logging:** Feeding, litter, walk, vet, vaccine, custom events
- **Expense Tracking:** Add expenses, categorize, link to events
- **Necessities:** To-do list with completion and expense linking
- **Storage Inventory:** Track food/litter quantities (add/subtract)
- **Stats & Charts:**
  - Last 30 days: Free
  - Beyond 30 days: Premium
  - Charts: Expenses over time, Care events over time
  - Filters: Time range, Pet (individual/all)
- **Premium:**
  - 1 month free trial (includes all stats)
  - After trial: Stats > 1 month require premium
  - Pricing: $1/month, $10/year
  - Paywall UI with StoreKit 2 (stubbed for testing)
- **Notifications:**
  - Opt-in only (not default)
  - Daily reminder if no log that day
  - Background delivery

#### Technical Requirements
- SwiftUI + Swift Charts
- SwiftData (local-first persistence)
- MVVM architecture
- Tab bar navigation (5 tabs)
- iPad + Mac Catalyst support
- Accessibility (Dynamic Type, VoiceOver)
- SwiftUI Previews for all major screens

---

### ❌ Out of Scope (MVP)

#### Explicitly Excluded
- **Authentication:** No login/account required for MVP
- **Cloud Sync:** Local-only (Firebase sync in v1.1)
- **Social Features:** No friends/sharing (v2)
- **Watch App:** Notifications only, no companion app
- **Reference Wiki:** Basic offline text only (expandable later)
- **Inventory Alerts:** Low stock reminders (v1.1)
- **Export:** CSV/PDF export (v1.1)
- **Widgets:** iOS widgets (v1.1)
- **Multi-language:** English only for MVP

---

## 6. Non-Goals

1. **Social Network:** Not building a social platform
2. **Vet Integration:** No API integrations with vet clinics
3. **E-commerce:** No in-app purchases of pet products
4. **AI/ML:** No predictive analytics or recommendations (future consideration)
5. **Gamification:** No points, badges, or achievements

---

## 7. Acceptance Criteria

### AC1: Profile Creation
- **Given** user opens app for first time
- **When** user enters name and taps "Create Profile"
- **Then** profile is created locally, trial start date is set, user sees Home tab

### AC2: Pet Creation
- **Given** user is on Profile tab
- **When** user taps "Add Pet", enters name and species, optionally adds photo
- **Then** pet appears in list, can be selected for events

### AC3: Event Logging
- **Given** user is on Home or Paw tab
- **When** user taps "Add Event", selects type and pet, saves
- **Then** event appears in feed, is linked to pet, persists across app restarts

### AC4: Expense Logging
- **Given** user is on Profile → Expenses
- **When** user adds expense with amount, category, pet (optional)
- **Then** expense appears in list, is included in charts, can be filtered by pet

### AC5: Stats Display (Free)
- **Given** user has logged events/expenses
- **When** user views stats for last 30 days
- **Then** charts display correctly, filters work, no paywall shown

### AC6: Premium Gating
- **Given** user's trial has expired
- **When** user tries to view stats beyond 30 days
- **Then** paywall is shown, premium features are gated

### AC7: Notifications (Opt-In)
- **Given** user has not enabled notifications
- **When** user toggles "Daily Reminders" in settings
- **Then** permission is requested, if granted, reminders are scheduled

### AC8: Cross-Platform
- **Given** app is built
- **When** app runs on iPhone, iPad, Mac (Catalyst)
- **Then** layouts adapt correctly, no crashes, navigation works

### AC9: Data Persistence
- **Given** user has created pets and logged events
- **When** app is closed and reopened
- **Then** all data is preserved, no data loss

### AC10: Accessibility
- **Given** user has VoiceOver enabled or uses Dynamic Type
- **When** user navigates app
- **Then** all key buttons have labels, text scales correctly, charts are accessible

---

## 8. Design Principles

1. **Clean & Premium:** Negative letter spacing for headings, Apple-like density
2. **Privacy-First:** Local data, no tracking, opt-in notifications
3. **Simple Onboarding:** Minimal steps to start using
4. **Progressive Disclosure:** Free features first, premium value clear
5. **Consistent Icons:** SF Symbols throughout
6. **Readable:** Dynamic Type support, good contrast

---

## 9. Technical Constraints

- **Minimum iOS:** iOS 17.0 (for SwiftData + Swift Charts)
- **Storage:** Local-only (SwiftData)
- **Dependencies:** Minimal (StoreKit 2, UserNotifications)
- **Architecture:** MVVM with dependency injection
- **Testing:** Unit tests for ViewModels, integration tests for repositories

---

## 10. Launch Readiness Checklist

- [ ] All MVP features implemented
- [ ] No critical bugs
- [ ] App Store assets ready (screenshots, description)
- [ ] Privacy policy published
- [ ] StoreKit 2 tested (sandbox)
- [ ] TestFlight beta tested
- [ ] iPad + Mac layouts verified
- [ ] Accessibility tested
- [ ] Performance profiled
- [ ] ASO keywords optimized

---

## 11. Post-MVP Roadmap

### v1.1 (Q2)
- Firebase sync (cloud backup)
- Inventory alerts
- Export data (CSV)

### v1.2 (Q3)
- Reference wiki expansion
- Widgets
- Enhanced charts

### v2.0 (Q4)
- Social features (friends, sharing)
- Apple Watch companion app
- Multi-language support

