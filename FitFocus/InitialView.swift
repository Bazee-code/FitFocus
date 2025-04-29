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
    
//    @State private var userLoggedIn: Bool = false
    @State private var currentView: AuthView = .login
    @State private var transitionDirection: TransitionDirection = .forward
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack{
            if userLoggedIn {
                ContentView()
                    .environmentObject(healthStore)
                    .environmentObject(appManager)
                    .onAppear {
                        healthStore.requestAuthorization()
                    }
            }
            else {
//                OnboardingView()
                ZStack{
                    AnimatedGradientBackground()
                    LoginView(
                        onSignupTap: {
                            transitionDirection = .forward
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                currentView = .signup
                            }
                        },
                        onForgotPasswordTap: {
                            transitionDirection = .forward
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                currentView = .resetPassword
                            }
                        }
                    )
                    .transition(transitionDirection == .forward ?
                        .asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ) :
                            .asymmetric(
                                insertion: .move(edge: .leading).combined(with: .opacity),
                                removal: .move(edge: .trailing).combined(with: .opacity)
                            ))
                }
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
