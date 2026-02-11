# Meadow - Xcode Project Setup Guide

## Creating the Xcode Project

Since we've created all the Swift files, you need to create the Xcode project and add them. Follow these steps:

### Step 1: Create New Xcode Project

1. Open Xcode
2. File → New → Project
3. Select **iOS** → **App**
4. Click **Next**
5. Configure:
   - **Product Name:** `Meadow`
   - **Team:** (Select your team)
   - **Organization Identifier:** (e.g., `com.yourname`)
   - **Interface:** SwiftUI
   - **Language:** Swift
   - **Storage:** SwiftData
   - **Include Tests:** Yes
6. Click **Next** and choose a location
7. Click **Create**

### Step 2: Delete Default Files

Delete the default `ContentView.swift` and `MeadowApp.swift` (we have our own versions).

### Step 3: Add Existing Files

1. In Xcode, right-click on the project root
2. Select **Add Files to "Meadow"...**
3. Navigate to the `Meadow` folder
4. Select all folders and files
5. Make sure:
   - **Copy items if needed** is UNCHECKED (files are already in place)
   - **Create groups** is selected
   - **Add to targets:** Meadow is checked
6. Click **Add**

### Step 4: Configure Project Settings

1. Select the **Meadow** project in the navigator
2. Select the **Meadow** target
3. Go to **General** tab:
   - **Deployment Info:**
     - iOS: 17.0+
     - iPad: Supported
     - Mac (Designed for iPad): Supported (for Catalyst)
4. Go to **Signing & Capabilities:**
   - Enable **App Sandbox** if needed
   - Add **In-App Purchase** capability (for StoreKit 2)
   - Add **Push Notifications** capability (for notifications)

### Step 5: Update Info.plist (if needed)

Add to Info.plist:
- **Privacy - Photo Library Usage Description:** "We need access to your photos to add pet photos."
- **Privacy - Notifications Usage Description:** "We'll send you daily reminders to log pet care events."

### Step 6: Add StoreKit Configuration (Optional, for Testing)

1. File → New → File
2. Select **StoreKit Configuration File**
3. Name it `Products.storekit`
4. Add products:
   - `meadow_premium_monthly` - Auto-Renewable Subscription - $0.99/month
   - `meadow_premium_annual` - Auto-Renewable Subscription - $9.99/year
5. In scheme editor, set StoreKit Configuration to `Products.storekit`

### Step 7: Build and Run

1. Select a simulator or device
2. Press ⌘R to build and run
3. The app should launch with the welcome screen

## Project Structure Verification

Your project should have this structure:

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
│   │   ├── InventoryRepository.swift
│   │   └── UserProfileRepository.swift
│   └── Implementations/
│       └── SwiftDataRepository.swift
├── ViewModels/
│   ├── HomeViewModel.swift
│   └── StatsViewModel.swift
├── Views/
│   ├── ContentView.swift
│   ├── WelcomeView.swift
│   ├── MainTabView.swift
│   ├── Home/
│   │   └── HomeView.swift
│   ├── Food/
│   │   └── FoodView.swift
│   ├── Paw/
│   │   └── PawView.swift
│   ├── Storage/
│   │   └── StorageView.swift
│   ├── Profile/
│   │   ├── ProfileView.swift
│   │   └── PetDetailView.swift
│   ├── AddEventView.swift
│   ├── AddPetView.swift
│   ├── AddInventoryItemView.swift
│   ├── PaywallView.swift
│   ├── SettingsView.swift
│   └── StatsView.swift
├── Services/
│   ├── SubscriptionService.swift
│   └── NotificationService.swift
└── Utilities/
    └── MockData.swift
```

## Common Issues & Fixes

### Issue: "Cannot find type 'X' in scope"
- **Fix:** Make sure all files are added to the target (check Target Membership in File Inspector)

### Issue: Preview crashes
- **Fix:** Ensure all previews use in-memory ModelContainer configurations

### Issue: StoreKit products not loading
- **Fix:** 
  - In Simulator, use the "Test Purchase" button
  - For real testing, configure StoreKit Configuration file
  - Ensure product IDs match exactly: `meadow_premium_monthly` and `meadow_premium_annual`

### Issue: SwiftData schema errors
- **Fix:** Clean build folder (⌘⇧K) and rebuild

## Next Steps

1. Build and test the app
2. Add seed data using `MockData.createSampleData()` in `MeadowApp.swift` for testing
3. Test all flows:
   - Profile creation
   - Pet creation
   - Event logging
   - Expense tracking
   - Stats viewing
   - Premium paywall
4. Fix any compilation errors
5. Test on iPhone, iPad, and Mac (Catalyst)

## Testing with Seed Data

To add seed data for testing, modify `MeadowApp.swift`:

```swift
@main
struct MeadowApp: App {
    // ... existing code ...
    
    init() {
        // ... existing initialization ...
        
        #if DEBUG
        // Add seed data for testing
        let context = modelContainer.mainContext
        MockData.createSampleData(modelContext: context)
        #endif
    }
}
```

This will populate the app with sample pets, events, and expenses when running in debug mode.

