//
//  FitFocusApp.swift
//  FitFocus
//
//  Created by Eugene Obazee on 14/04/2025.
//

import SwiftUI
import HealthKit
import ManagedSettings

@main
struct FitFocusApp: App {
    @StateObject private var healthStore = HealthStore()
    @StateObject private var appManager = AppManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(healthStore)
                .environmentObject(appManager)
                .onAppear {
                    healthStore.requestAuthorization()
                }
        }
    }
}
