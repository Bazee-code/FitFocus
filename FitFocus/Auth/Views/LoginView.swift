//
//  LoginView.swift
//  FitFocus
//
//  Created by Eugene Obazee on 27/04/2025.
//

import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

//LOGOUT
//Button{
//                Task{
//                    do{
//                        try await AuthenticationView().logout()
//                    } catch let e {
//                        
//                        err = e.localizedDescription
//                    }
//                }

struct AuthContentView: View {
    @State private var currentView: AuthView = .login
    @State private var transitionDirection: TransitionDirection = .forward
    @Environment(\.colorScheme) private var colorScheme
        
    var body: some View {
        ZStack {
            // Animated background gradient
            AnimatedGradientBackground()
            
            VStack {
                switch currentView {
                case .login:
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
                    
                case .signup:
                    SignupView(
                        onBackTap: {
                            transitionDirection = .backward
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                currentView = .login
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
                    
                case .resetPassword:
                    ResetPasswordView(
                        onBackTap: {
                            transitionDirection = .backward
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                currentView = .login
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .preferredColorScheme(colorScheme)
    }
}

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var loginError = ""
    @State private var isLoggedIn = false
    
    @State private var showLoginAnimation = false
    @State private var showingFields = false
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var googleSignIn = AuthenticationView()
    
    var onSignupTap: () -> Void
    var onForgotPasswordTap: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("Welcome")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .opacity(showLoginAnimation ? 1 : 0)
                        .offset(y: showLoginAnimation ? 0 : -30)
                        .animation(Animation.spring(response: 0.5, dampingFraction: 0.8).delay(0.1), value: showLoginAnimation)
                    
                    Text("Sign in to continue")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.7))
                        .opacity(showLoginAnimation ? 1 : 0)
                        .offset(y: showLoginAnimation ? 0 : -20)
                        .animation(Animation.spring(response: 0.5, dampingFraction: 0.8).delay(0.2), value: showLoginAnimation)
                }
                .padding(.top, 60)
                .padding(.bottom, 40)
                
                // Card View for form fields
                VStack(spacing: 24) {
                    ModernTextField(placeholder: "Email", iconName: "envelope", text: $email)
                        .opacity(showingFields ? 1 : 0)
                        .offset(y: showingFields ? 0 : 20)
                        .animation(Animation.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: showingFields)
                    
                    ModernTextField(placeholder: "Password", iconName: "lock", text: $password, isSecure: true)
                        .opacity(showingFields ? 1 : 0)
                        .offset(y: showingFields ? 0 : 20)
                        .animation(Animation.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: showingFields)
                    
                    HStack {
                        Spacer()
                        Button(action: onForgotPasswordTap) {
                            Text("Forgot Password?")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(hex: "4CC2FF"))
                        }
                        .opacity(showingFields ? 1 : 0)
                        .animation(Animation.spring().delay(0.5), value: showingFields)
                        .padding(.trailing)
                    }
                    
                    ModernButton(
                        title: "LOG IN",
                        action: {
                            // Login action would go here
                            login()
                            print("Login with: \(email), \(password)")
                        },
                        isPrimary: true
                    )
                    .opacity(showingFields ? 1 : 0)
                    .offset(y: showingFields ? 0 : 20)
                    .animation(Animation.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: showingFields)
                    .padding(.top, 10)
                }
                
                Spacer(minLength: 30)
                
                // Social sign-in section
                VStack(spacing: 16) {
                    DividerWithText(text: "OR CONTINUE WITH")
                        .opacity(showingFields ? 1 : 0)
                        .animation(Animation.spring().delay(0.6), value: showingFields)
                    
                    SocialSignInButton(type: .apple) {
                        print("Apple Sign In tapped")
                    }
                    .opacity(showingFields ? 1 : 0)
                    .offset(y: showingFields ? 0 : 20)
                    .animation(Animation.spring(response: 0.6, dampingFraction: 0.8).delay(0.7), value: showingFields)
                    
                    SocialSignInButton(type: .google) {
                        print("Google Sign In tapped")
                        googleSignIn.signInWithGoogle()
                    }
                    .opacity(showingFields ? 1 : 0)
                    .offset(y: showingFields ? 0 : 20)
                    .animation(Animation.spring(response: 0.6, dampingFraction: 0.8).delay(0.8), value: showingFields)
                }
                
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.white.opacity(0.7))
                    
                    Button(action: onSignupTap) {
                        Text("Sign Up")
                            .fontWeight(.semibold)
                            .foregroundColor(Color(hex: "4CC2FF"))
                    }
                }
                .opacity(showingFields ? 1 : 0)
                .animation(Animation.spring().delay(0.9), value: showingFields)
                .padding(.top, 40)
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.4)) {
                showLoginAnimation = true
            }
            
            // Slight delay for fields to appear after header
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation {
                    showingFields = true
                }
            }
        }
    }
    
    func login() {
          Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
          
              if let error = error {
                  loginError = error.localizedDescription
              }
              
              isLoggedIn = true
          }
      }
}

#Preview {
    AuthContentView()
}
