# Meadow — Product & Retention Roadmap

## North Star

**Make daily pet care tracking delightful, consistent, and insightful.**

---

## Core Value Proposition

A beautiful, distraction-free app that helps pet owners log daily care (feeding, litter, walks) and gain actionable insights—without requiring accounts, cloud dependencies, or overwhelming features.

---

## Key Metrics

| Metric | Definition | Target (v1.0+) |
|--------|------------|----------------|
| **D1 Retention** | % users returning day after install | ≥ 40% |
| **D7 Retention** | % users returning 7 days after install | ≥ 25% |
| **Weekly Active Loggers** | Users who logged ≥1 event in the past 7 days | Growing week-over-week |
| **Avg Logs / Active Day** | Mean events logged per day by active users | ≥ 2.0 |
| **Notification Opt-in Rate** | % users enabling any reminder | ≥ 30% |
| **2-Day Target Engagement** | % users who expand/interact with feeding guidance | Track baseline, then improve |

---

## Release Plan

### v1.0 — MVP+ (NOW)

**Focus:** Core tracking + gentle engagement hooks

- [x] Litter cleaning reminders (opt-in, configurable threshold: 2–7 days)
- [x] Anti-spam: max 1 reminder/day/pet, reset on event log
- [x] Playful emoji toggle for notifications (💩)
- [x] Feeding guidance: 2-day target card with logged/remaining
- [x] Disclaimer: "Estimate only — not veterinary advice"
- [ ] Deep link from notification → relevant AddEvent screen (next priority)

**Retention levers:**
- Reminder notifications bring users back after absence
- Feeding guidance creates daily check-in habit

---

### v1.1 — Light Gamification (Low Risk)

**Focus:** Positive reinforcement without pressure

- **Streaks per pet:** "Logged care today" streak counter
  - Show in pet profile and home summary
  - Gentle celebration at 7, 14, 30 days (no confetti overload)
- **Weekly recap card:** Last 7 days summary with event type icons
  - Simple visual, not dense charts
- **Microcopy polish:** Encouraging phrases ("Great job keeping up with Fluffy!")

**Retention levers:**
- Loss aversion (don't break the streak)
- Weekly recap creates anticipation/reflection point

---

### v1.2 — Personalization

**Focus:** Smarter, less intrusive reminders

- **Care plan preferences per pet:**
  - Walk frequency target (e.g., 2x/day)
  - Litter frequency target (e.g., every 3 days)
  - Feeding schedule preference
- **Smart reminder scheduling:**
  - Learn user's logging patterns
  - Only notify when user is likely to act (simple heuristics: time of day, day of week)
- **Onboarding improvements:**
  - Ask pet weight early for instant feeding guidance

**Retention levers:**
- Personalized = relevant = less notification fatigue
- Upfront value from Day 1

---

### v1.3 — Premium Expansion

**Focus:** Monetization without alienating free users

- **Advanced Insights (Premium):**
  - Trend analysis over 30/90 days
  - Anomaly detection ("Feeding down 20% this week")
  - Health correlations (optional)
- **Export/Report:**
  - PDF summary for vet visits
  - Shareable weekly snapshot
- **Premium gating strategy:**
  - Core logging: always free
  - Reminders: always free
  - Insights/export/trends: Premium
  - Consider "freemium hook": show blurred insight preview, unlock with upgrade

**Retention levers:**
- Premium users have higher LTV and retention by default
- Export creates external value (vet trust, sharing)

---

## Risks & Safeguards

### Notification Fatigue
- **Guardrail:** Max 1 litter reminder/day/pet
- **Guardrail:** Reminders are opt-in (default OFF)
- **Future:** Smart scheduling based on user patterns

### Feeding Guidance Liability
- **Guardrail:** Clear disclaimer on every guidance card
- **Guardrail:** Labeled as "estimate", never "recommendation"
- **Future:** Allow user to input actual food kcal density for accuracy

### Data Quality
- **Guardrail:** Guidance hidden if weight is missing
- **Guardrail:** Events without grams are excluded from sums (no crashes)

### Privacy
- **Principle:** No account required; data stays local or in user's iCloud (CloudKit optional)
- **Principle:** No analytics that identify individual users
- **Future:** Export-only sharing (user controls what leaves device)

---

## Architecture Notes (for Cursor)

| Layer | Tech |
|-------|------|
| UI | SwiftUI |
| State | MVVM + @Query (SwiftData) |
| Persistence | SwiftData (local, CloudKit-ready) |
| Notifications | UNUserNotificationCenter |
| Payments | StoreKit 2 |

**Key files:**
- `NotificationService.swift` — all notification logic
- `UserProfile.swift` — global settings including reminders
- `Pet.swift` — per-pet data + reminder tracking
- `FoodView.swift` — feeding guidance card + calculation
- `SettingsView.swift` — reminder toggles + configuration

---

*Last updated: v1.0 (January 2026)*
