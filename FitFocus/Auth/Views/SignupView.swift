//
//  SignupView.swift
//  FitFocus
//
//  Created by Eugene Obazee on 28/04/2025.
//

import SwiftUI

struct SignupView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showSignupAnimation = false
    @State private var showingFields = false
    @Environment(\.colorScheme) private var colorScheme
    
    var onBackTap: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                HStack {
                    Button(action: onBackTap) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.1))
                            )
                    }
                    .padding(.leading)
                    Spacer()
                }
                .padding(.top)
                
                VStack(spacing: 8) {
                    Text("Create Account")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .opacity(showSignupAnimation ? 1 : 0)
                        .offset(y: showSignupAnimation ? 0 : -30)
                        .animation(Animation.spring(response: 0.5, dampingFraction: 0.8).delay(0.1), value: showSignupAnimation)
                    
                    Text("Sign up to get started")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.7))
                        .opacity(showSignupAnimation ? 1 : 0)
                        .offset(y: showSignupAnimation ? 0 : -20)
                        .animation(Animation.spring(response: 0.5, dampingFraction: 0.8).delay(0.2), value: showSignupAnimation)
                }
                .padding(.top, 10)
                .padding(.bottom, 40)
                
                // Form Fields
                VStack(spacing: 20) {
                    ModernTextField(placeholder: "Full Name", iconName: "person", text: $name)
                        .opacity(showingFields ? 1 : 0)
                        .offset(y: showingFields ? 0 : 20)
                        .animation(Animation.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: showingFields)
                    
                    ModernTextField(placeholder: "Email", iconName: "envelope", text: $email)
                        .opacity(showingFields ? 1 : 0)
                        .offset(y: showingFields ? 0 : 20)
                        .animation(Animation.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: showingFields)
                    
                    ModernTextField(placeholder: "Password", iconName: "lock", text: $password, isSecure: true)
                        .opacity(showingFields ? 1 : 0)
                        .offset(y: showingFields ? 0 : 20)
                        .animation(Animation.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: showingFields)
                    
                    ModernTextField(placeholder: "Confirm Password", iconName: "lock.shield", text: $confirmPassword, isSecure: true)
                        .opacity(showingFields ? 1 : 0)
                        .offset(y: showingFields ? 0 : 20)
                        .animation(Animation.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: showingFields)
                    
                    ModernButton(
                        title: "SIGN UP",
                        action: {
                            // Signup action would go here
                            print("Signup with: \(name), \(email), \(password)")
                        },
                        isPrimary: true
                    )
                    .opacity(showingFields ? 1 : 0)
                    .offset(y: showingFields ? 0 : 20)
                    .animation(Animation.spring(response: 0.6, dampingFraction: 0.8).delay(0.7), value: showingFields)
                    .padding(.top, 10)
                }
                
                Spacer(minLength: 20)
                
                // Social sign-in section
                VStack(spacing: 16) {
                    DividerWithText(text: "OR SIGN UP WITH")
                        .opacity(showingFields ? 1 : 0)
                        .animation(Animation.spring().delay(0.8), value: showingFields)
                    
                    SocialSignInButton(type: .apple) {
                        print("Apple Sign Up tapped")
                    }
                    .opacity(showingFields ? 1 : 0)
                    .offset(y: showingFields ? 0 : 20)
                    .animation(Animation.spring(response: 0.6, dampingFraction: 0.8).delay(0.9), value: showingFields)
                    
                    SocialSignInButton(type: .google) {
                        print("Google Sign Up tapped")
                    }
                    .opacity(showingFields ? 1 : 0)
                    .offset(y: showingFields ? 0 : 20)
                    .animation(Animation.spring(response: 0.6, dampingFraction: 0.8).delay(1.0), value: showingFields)
                }
                
                HStack {
                    Text("Already have an account?")
                        .foregroundColor(.white.opacity(0.7))
                    
                    Button(action: onBackTap) {
                        Text("Login")
                            .fontWeight(.semibold)
                            .foregroundColor(Color(hex: "4CC2FF"))
                    }
                }
                .opacity(showingFields ? 1 : 0)
                .animation(Animation.spring().delay(1.1), value: showingFields)
                .padding(.top, 30)
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.4)) {
                showSignupAnimation = true
            }
            
            // Slight delay for fields to appear after header
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation {
                    showingFields = true
                }
            }
        }
    }
}
