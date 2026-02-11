# Meadow - Product Pipeline & Progress Plan

## Vision
Meadow is a comprehensive pet care tracking app that helps pet owners maintain consistent care routines, track expenses, and monitor their pets' health over time—all while respecting privacy with local-first data storage.

---

## Phase 1: MVP Foundation (Sprints 1-3)
**Goal:** Ship a fully functional MVP that can be used daily for pet care tracking.

### Sprint 1: Core Infrastructure (2 weeks)
**Deliverables:**
- ✅ Project structure (MVVM architecture)
- ✅ Data models + SwiftData persistence
- ✅ Repository layer (protocols + implementations)
- ✅ Basic navigation (Tab bar)
- ✅ User profile (local, no auth)
- ✅ Trial status tracking

**Exit Criteria:**
- Can create a local profile
- Trial start date is tracked
- Data persists across app launches
- All models are testable with mocks

### Sprint 2: Pet Management & Event Logging (2 weeks)
**Deliverables:**
- ✅ Pet CRUD (create, list, detail)
- ✅ Photo support (optional, local storage)
- ✅ Care event logging (feeding, litter, walk, vet, vaccine, custom)
- ✅ Event detail screens
- ✅ Quick add from Home tab

**Exit Criteria:**
- Can create multiple pets
- Can log all event types
- Events are linked to pets
- Events persist and display correctly

### Sprint 3: Expenses, Necessities & Storage (2 weeks)
**Deliverables:**
- ✅ Expense logging (standalone or linked to events)
- ✅ Necessities to-do list (add, mark done, link expense)
- ✅ Storage inventory page (food/litter quantities)
- ✅ Basic inventory add/subtract

**Exit Criteria:**
- Can add expenses per pet or household
- Can create and complete necessity items
- Can track inventory quantities
- All data persists correctly

---

## Phase 2: Analytics & Premium (Sprints 4-5)
**Goal:** Add insights and monetization.

### Sprint 4: Stats & Charts (2 weeks)
**Deliverables:**
- ✅ Swift Charts integration
- ✅ Expense chart (bar/line over time)
- ✅ Care events chart (stacked/grouped)
- ✅ Time range filters (7d, 15d, 30d, 3m, 6m, 1y, multi-year)
- ✅ Pet filter (individual vs all pets)
- ✅ Stats screen UI

**Exit Criteria:**
- Charts render correctly with real data
- All time ranges work
- Filtering works (pet + time)
- Charts are accessible (VoiceOver)

### Sprint 5: Premium & Paywall (2 weeks)
**Deliverables:**
- ✅ StoreKit 2 integration (stubbed for testing)
- ✅ Paywall screen (clean design)
- ✅ Premium gating logic (stats > 1 month)
- ✅ Subscription status tracking
- ✅ Trial expiration handling

**Exit Criteria:**
- Paywall displays correctly
- Premium status gates features appropriately
- Test purchases work in Simulator
- Trial logic works (1 month free)

---

## Phase 3: Polish & Notifications (Sprint 6)
**Goal:** Add reminders and final polish.

### Sprint 6: Notifications & Polish (2 weeks)
**Deliverables:**
- ✅ Notification permission flow (opt-in only)
- ✅ Daily reminder logic (evening if no log)
- ✅ Settings screen (reminders toggle)
- ✅ iPad layout optimization
- ✅ Mac Catalyst compatibility
- ✅ Accessibility improvements
- ✅ Bug fixes and performance

**Exit Criteria:**
- Notifications work in background
- Reminders only sent if user opts in
- App works on iPhone, iPad, Mac
- No critical bugs
- All previews work

---

## Phase 4: Pre-Launch (Sprint 7)
**Goal:** Prepare for App Store submission.

### Sprint 7: ASO & Launch Prep (2 weeks)
**Deliverables:**
- ✅ App Store assets (screenshots, description)
- ✅ Privacy policy
- ✅ Keywords optimization
- ✅ Release checklist completion
- ✅ Beta testing (TestFlight)
- ✅ Final bug fixes

**Exit Criteria:**
- All App Store requirements met
- TestFlight beta tested
- Privacy policy published
- Ready for App Review

---

## Phase 5: Post-MVP (v1.1+)
**Backlog items for future sprints:**
- Firebase sync (cloud backup)
- Reference info/wiki expansion
- Inventory alerts (low stock)
- Enhanced charts (more visualizations)
- Export data (CSV/PDF)
- Widgets (iOS 16+)
- Apple Watch companion app
- Social features (friends, sharing) - v2
- Multi-language support
- Dark mode refinements

---

## Milestones

| Milestone | Target Date | Status |
|-----------|-------------|--------|
| MVP Foundation Complete | Sprint 3 end | 🎯 |
| Analytics & Premium Live | Sprint 5 end | 🎯 |
| MVP Ready for Beta | Sprint 6 end | 🎯 |
| App Store Submission | Sprint 7 end | 🎯 |
| v1.0 Launch | Post-Sprint 7 | 🎯 |

---

## Success Metrics (Post-Launch)
- Daily active users (DAU)
- Pet profiles created
- Events logged per week
- Premium conversion rate
- Retention (7-day, 30-day)
- App Store rating (target: 4.5+)

---

## Tools & Workflow
- **ASO Management:** Helm (optional, for keyword testing)
- **Screenshots/Localization:** AppScreens (optional, for asset generation)
- **Analytics:** (TBD - add post-MVP)
- **Crash Reporting:** (TBD - add post-MVP)

---

## Risk Mitigation
- **Data Loss:** Local-first with SwiftData (backup strategy in v1.1)
- **StoreKit Issues:** Stub implementation allows testing without sandbox
- **Performance:** Profile with Instruments, optimize SwiftData queries
- **App Review:** Follow guidelines strictly, test subscription flow thoroughly

