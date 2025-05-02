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
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

@main
struct FitFocusApp: App {
    @StateObject private var healthStore = HealthStore()
    @StateObject private var appManager = AppManager()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate


    // Create the auth repository
    @StateObject var authViewModel = AuthenticationViewModel(
        authRepository: FirebaseAuthRepository()
    )
      
    var body: some Scene {
        WindowGroup {
            InitialView()
                .environmentObject(AuthenticationViewModel(
                    authRepository: FirebaseAuthRepository()
                ))
//            ContentView()
//                .environmentObject(authViewModel)
//                .onOpenURL { url in
//                    // Handle deep links, such as those from Google Sign-In
//                    GIDSignIn.sharedInstance.handle(url)
//                }
//                .environmentObject(HealthStore())
//                .environmentObject(AppManager())
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
