//
//  FitFocusApp.swift
//  FitFocus
//
//  Created by Eugene Obazee on 14/04/2025.
//

import SwiftUI
import HealthKit
import ManagedSettings
import Firebase
import GoogleSignIn

@main

//LOGIN CONDITIONS
//NEW USER -> onboard -> sign up -> login -> home
//RETURN USER [NOT AUTH] -> login -> home
//RETURN USER [AUTH] -> home

struct FitFocusApp: App {
    @StateObject private var healthStore = HealthStore()
    @StateObject private var appManager = AppManager()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environmentObject(healthStore)
//                .environmentObject(appManager)
//                .onAppear {
//                    healthStore.requestAuthorization()
//                }
            OnboardingView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool{
        FirebaseApp.configure()
        return true
    }
    
    @available(iOS 9.0, *)
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}
