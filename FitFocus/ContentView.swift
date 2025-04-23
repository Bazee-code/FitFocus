//
//  ContentView.swift
//  FitFocus
//
//  Created by Eugene Obazee on 14/04/2025.
//

//import SwiftUI

//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundColor(.accentColor)
//            Text("Hello, world!")
//        }
//        .padding()
//    }
//}

import SwiftUI
import HealthKit
import ManagedSettings


// Main content view that manages navigation
struct ContentView: View {
    @EnvironmentObject var healthStore: HealthStore
    @EnvironmentObject var appManager: AppManager
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            StepCountView()
                .tabItem {
                    Label("Steps", systemImage: "figure.walk")
                }
                .tag(0)
            
            AppCategoryListView()
                .tabItem {
                    Label("Apps", systemImage: "app.fill")
                }
                .tag(1)
            
            RestrictedAppsView()
                .tabItem {
                    Label("Restricted", systemImage: "lock.fill")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(3)
        }
    }
}

// Class to handle HealthKit interactions
class HealthStore: ObservableObject {
    private var healthStore = HKHealthStore()
    private let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
    
    @Published var steps: Int = 0
    @Published var isAuthorized = false
    
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit is not available on this device")
            return
        }
        
        healthStore.requestAuthorization(toShare: [], read: [stepType]) { success, error in
            DispatchQueue.main.async {
                self.isAuthorized = success
                if success {
                    self.fetchTodaySteps()
                    self.startObservingStepChanges()
                }
            }
        }
    }
    
    func fetchTodaySteps() {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: now,
            options: .strictStartDate
        )
        
        let query = HKStatisticsQuery(
            quantityType: stepType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                if let error = error {
                    print("Error fetching steps: \(error.localizedDescription)")
                }
                return
            }
            
            DispatchQueue.main.async {
                self.steps = Int(sum.doubleValue(for: HKUnit.count()))
            }
        }
        
        healthStore.execute(query)
    }
    
    func startObservingStepChanges() {
        let query = HKObserverQuery(sampleType: stepType, predicate: nil) { [weak self] _, _, error in
            if let error = error {
                print("Observer query error: \(error.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async {
                self?.fetchTodaySteps()
            }
        }
        
        healthStore.execute(query)
        
        // Also enable background delivery if permission is granted
        healthStore.enableBackgroundDelivery(for: stepType, frequency: .immediate) { success, error in
            if let error = error {
                print("Failed to enable background delivery: \(error.localizedDescription)")
            }
        }
    }
}

// Class to manage app inventory and restrictions
class AppManager: ObservableObject {
    @Published var appCategories: [AppCategory] = []
    @Published var restrictedApps: [RestrictedApp] = []
    
    private let settingsManager = ManagedSettingsStore()
    
    init() {
        // In a real app, we'd populate this from the device
        // This is a mock implementation since direct app enumeration requires entitlements
        loadMockAppData()
        loadRestrictedApps()
    }
    
    private func loadMockAppData() {
        appCategories = [
            AppCategory(name: "Social", apps: [
                AppInfo(id: "com.facebook.app", name: "Facebook", icon: "bubble.left.fill"),
                AppInfo(id: "com.instagram.app", name: "Instagram", icon: "camera.fill"),
                AppInfo(id: "com.twitter.app", name: "Twitter", icon: "message.fill")
            ]),
            AppCategory(name: "Entertainment", apps: [
                AppInfo(id: "com.netflix.app", name: "Netflix", icon: "tv.fill"),
                AppInfo(id: "com.youtube.app", name: "YouTube", icon: "play.rectangle.fill"),
                AppInfo(id: "com.spotify.app", name: "Spotify", icon: "music.note")
            ]),
            AppCategory(name: "Productivity", apps: [
                AppInfo(id: "com.apple.mobilemail", name: "Mail", icon: "envelope.fill"),
                AppInfo(id: "com.apple.mobilecal", name: "Calendar", icon: "calendar"),
                AppInfo(id: "com.apple.mobilenotes", name: "Notes", icon: "note.text")
            ])
        ]
    }
    
    private func loadRestrictedApps() {
        // In a real app, we'd load this from UserDefaults or another persistence method
        // Mock data for now
        restrictedApps = [
            RestrictedApp(app: AppInfo(id: "com.facebook.app", name: "Facebook", icon: "bubble.left.fill"),
                          stepGoal: 5000)
        ]
    }
    
    func restrictApp(app: AppInfo, stepGoal: Int) {
        // Check if app is already restricted
        if let index = restrictedApps.firstIndex(where: { $0.app.id == app.id }) {
            restrictedApps[index].stepGoal = stepGoal
        } else {
            restrictedApps.append(RestrictedApp(app: app, stepGoal: stepGoal))
        }
        
        // Save to persistence
        saveRestrictedApps()
        
        // In a real app, we would use FamilyControls/ManagedSettings framework
        // to actually restrict the app at the system level
        // This requires proper entitlements and user permission
    }
    
    func removeRestriction(for appID: String) {
        restrictedApps.removeAll { $0.app.id == appID }
        saveRestrictedApps()
        
        // In a real app, this would remove the system-level restriction
    }
    
    func checkAccess(for appID: String, currentSteps: Int) -> Bool {
        guard let restrictedApp = restrictedApps.first(where: { $0.app.id == appID }) else {
            return true // App is not restricted
        }
        
        return currentSteps >= restrictedApp.stepGoal
    }
    
    private func saveRestrictedApps() {
        // In a real app, save to UserDefaults or Core Data
        // Mock implementation
    }
}

// Data models
struct AppInfo: Identifiable, Hashable {
    let id: String
    let name: String
    let icon: String // Using SF Symbols for demo
}

struct AppCategory: Identifiable {
    let id = UUID()
    let name: String
    let apps: [AppInfo]
}

struct RestrictedApp: Identifiable {
    let id = UUID()
    let app: AppInfo
    var stepGoal: Int
}

#Preview {
    ContentView()
        .environmentObject(HealthStore())
        .environmentObject(AppManager())
}
