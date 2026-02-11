# Meadow - Product Backlog

## v1.1 (Post-MVP, Q2)

### Cloud Sync & Backup
- [ ] **Firebase Integration**
  - Add Firebase project setup
  - Implement cloud sync service
  - Conflict resolution strategy
  - Background sync
  - Sync status indicator in UI
  - **Priority:** High (data loss prevention)

### Inventory Enhancements
- [ ] **Low Stock Alerts**
  - Set threshold per inventory item
  - Notification when stock is low
  - Alert badge in Storage tab
  - **Priority:** Medium

### Data Export
- [ ] **Export Functionality**
  - Export expenses to CSV
  - Export care events to CSV
  - Export all data to JSON
  - Share/email export files
  - **Priority:** Medium

### Enhanced Analytics
- [ ] **Additional Chart Types**
  - Pie chart for expense categories
  - Heatmap for care event frequency
  - Trend lines with predictions
  - **Priority:** Low

### Reference Wiki Expansion
- [ ] **Curated Content**
  - Species-specific care guides
  - Feeding schedules by age
  - Common health issues
  - Emergency contacts template
  - Offline-first content
  - **Priority:** Low

---

## v1.2 (Q3)

### iOS Widgets
- [ ] **Home Screen Widgets**
  - Today's care summary (small)
  - Upcoming tasks (medium)
  - Stats overview (large)
  - Widget configuration
  - **Priority:** Medium

### Apple Watch Companion
- [ ] **Watch App**
  - View today's events
  - Quick log events (feeding, walk)
  - View pet info
  - Complications
  - **Priority:** Medium

### Localization
- [ ] **Multi-Language Support**
  - Spanish
  - French
  - German
  - Japanese
  - Localized date/number formats
  - **Priority:** Low (depends on market)

### Dark Mode Refinements
- [ ] **Enhanced Dark Mode**
  - Custom color schemes
  - Chart color adjustments
  - Improved contrast
  - **Priority:** Low

---

## v2.0 (Q4 - Major Release)

### Social Features
- [ ] **Friends & Sharing**
  - User accounts (Firebase Auth)
  - Add friends by username/email
  - Share pet profiles (privacy controls)
  - Share care milestones
  - Care reminders for friends' pets
  - **Priority:** Medium
  - **Complexity:** High (requires auth, privacy, moderation)

### Community Features
- [ ] **Community Hub**
  - Pet photo sharing (opt-in)
  - Care tips from community
  - Local pet owner groups
  - **Priority:** Low

### Advanced Analytics
- [ ] **ML-Powered Insights**
  - Predict health trends
  - Anomaly detection (unusual patterns)
  - Care recommendations
  - **Priority:** Low
  - **Complexity:** High

---

## Future Considerations (v2.1+)

### Integrations
- [ ] **Third-Party Integrations**
  - Vet clinic API (if available)
  - Pet store APIs (price tracking)
  - Health tracking devices (FitBark, etc.)
  - **Priority:** Low

### Advanced Features
- [ ] **Recurring Events**
  - Set up recurring care tasks
  - Automatic event creation
  - Custom schedules
  - **Priority:** Medium

- [ ] **Photo Albums**
  - Organize pet photos by date/event
  - Photo memories timeline
  - Share albums
  - **Priority:** Low

- [ ] **Health Records**
  - Vaccination records
  - Medication tracking
  - Vet visit notes
  - Document attachments
  - **Priority:** Medium

- [ ] **Budget Planning**
  - Monthly/yearly budget goals
  - Budget vs actual tracking
  - Category spending limits
  - **Priority:** Low

### Platform Expansion
- [ ] **Web App**
  - React/Next.js web version
  - Sync with mobile app
  - **Priority:** Low

- [ ] **Android App**
  - Kotlin + Jetpack Compose
  - Shared backend (Firebase)
  - **Priority:** Low (Apple-first strategy)

---

## Technical Debt & Improvements

### Performance
- [ ] **SwiftData Optimization**
  - Query performance tuning
  - Batch operations
  - Indexing strategy
  - **Priority:** Medium

- [ ] **Image Optimization**
  - Automatic compression
  - Thumbnail generation
  - Lazy loading
  - **Priority:** Low

### Architecture
- [ ] **Modularization**
  - Split into Swift packages
  - Feature modules
  - Shared utilities
  - **Priority:** Low

- [ ] **Testing**
  - Increase test coverage (target: 80%+)
  - UI tests for critical flows
  - Snapshot tests
  - **Priority:** Medium

### Developer Experience
- [ ] **CI/CD**
  - GitHub Actions workflow
  - Automated testing
  - TestFlight auto-deploy
  - **Priority:** Low

- [ ] **Analytics**
  - Privacy-respecting analytics (optional)
  - Feature usage tracking
  - Crash reporting
  - **Priority:** Medium

---

## Backlog Management

### Prioritization Criteria
1. **User Value:** How many users benefit?
2. **Business Value:** Revenue impact, retention
3. **Technical Risk:** Complexity, dependencies
4. **Effort:** Development time required

### Review Process
- Review backlog monthly
- Re-prioritize based on user feedback
- Remove obsolete items
- Break large items into smaller tasks

### Labels
- **Priority:** P0 (Critical), P1 (High), P2 (Medium), P3 (Low)
- **Complexity:** Simple, Medium, Complex
- **Effort:** S (Small), M (Medium), L (Large), XL (Extra Large)

---

## User-Requested Features (To Be Validated)

*This section will be populated based on user feedback post-launch.*

---

## Deprecated / Won't Do

### Explicitly Excluded
- ❌ **E-commerce:** No in-app purchases of pet products
- ❌ **Gamification:** No points, badges, achievements
- ❌ **Social Media:** Not building Instagram for pets
- ❌ **AI Chat:** No chatbot or AI assistant (for now)
- ❌ **Video Calls:** No vet consultation features

---

**Last Updated:** [Date]  
**Next Review:** Post-MVP launch

