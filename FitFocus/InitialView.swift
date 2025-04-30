//
//  InitialView.swift
//  FitFocus
//
//  Created by Eugene Obazee on 29/04/2025.

import SwiftUI
import FirebaseCore
import FirebaseAuth
import HealthKit
import ManagedSettings

//LOGIN CONDITIONS
//NEW USER -> onboard -> sign up -> login -> home
//RETURN USER [NOT AUTH] -> login -> home
//RETURN USER [AUTH] -> home

struct InitialView: View {
    @State private var userLoggedIn = (Auth.auth().currentUser != nil)
    @StateObject private var healthStore = HealthStore()
    @StateObject private var appManager = AppManager()
    
    var body: some View {
        VStack{
            if userLoggedIn {
                ContentView()
                    .environmentObject(healthStore)
                    .environmentObject(appManager)
                    .environmentObject(AuthenticationView())
                    .onAppear {
                        healthStore.requestAuthorization()
                    }
            }
            else {
                AuthContentView()
//                OnboardingView()
            }
            
            
        }.onAppear{
            
            Auth.auth().addStateDidChangeListener{auth, user in
            
                if (user != nil) {
                    
                    userLoggedIn = true
                } else{
                    userLoggedIn = false
                }
            }
        }
    }
}

#Preview{
    InitialView()
}


//import SwiftUI
//import FirebaseAuth
//import HealthKit
//import ManagedSettings
//
//struct InitialView: View {
//    @EnvironmentObject var authViewModel: AuthenticationViewModel
//    
//    @StateObject private var healthStore = HealthStore()
//    @StateObject private var appManager = AppManager()
//    
//    // This will check if we have a persisted login
//    private var isPersistedLogin: Bool {
//        UserDefaults.standard.bool(forKey: "isLoggedIn")
//    }
//    
//    var body: some View {
//        NavigationStack {
//            // Show the appropriate view based on authentication state
//            Group {
//                if authViewModel.state == .signedIn ||
//                    (isPersistedLogin && authViewModel.currentUser != nil) {
//                    // User is authenticated, show the Home view
//                    ContentView()
//                        .environmentObject(healthStore)
//                            .environmentObject(appManager)
//                            .onAppear {
//                                healthStore.requestAuthorization()
//                            }
//                } else {
//                    // User is not authenticated, show the Login view
//                    AuthContentView()
//                }
//            }
//            .animation(.easeInOut, value: authViewModel.state)
//        }
//        .overlay {
//            // Show loading indicator when ViewModel is loading
//            if authViewModel.isLoading {
//                LoadingView()
//            }
//        }
//        .alert(item: errorBinding) { authError in
//            Alert(
//                title: Text("Error"),
//                message: Text(authError.errorDescription ?? "An unknown error occurred"),
//                dismissButton: .default(Text("OK"))
//            )
//        }
//    }
//    
//    // Map AuthError to an Identifiable error for alerts
//    private var errorBinding: Binding<IdentifiableError?> {
//        Binding<IdentifiableError?>(
//            get: {
//                guard let error = authViewModel.error else { return nil }
//                return IdentifiableError(error: error)
//            },
//            set: { _ in authViewModel.error = nil }
//        )
//    }
//}
//
//// Helper for making errors identifiable for alerts
//struct IdentifiableError: Identifiable {
//    let id = UUID()
//    let error: AuthError
//    
//    var errorDescription: String? {
//        error.localizedDescription
//    }
//}
//
//// Preview provider for Xcode previews
//struct InitialView_Previews: PreviewProvider {
//    static var previews: some View {
//        InitialView()
//            .environmentObject(AuthenticationViewModel(
//                authRepository: FirebaseAuthRepository()
//            ))
//    }
//}
