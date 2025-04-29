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
                    .onAppear {
                        healthStore.requestAuthorization()
                    }
            }
            else {
                AuthContentView()
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
