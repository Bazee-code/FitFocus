//
//  LoginView.swift
//  FitFocus
//
//  Created by Eugene Obazee on 27/04/2025.
//

import SwiftUI

struct AuthContentView: View {
    @State private var currentView: AuthView = .login
    @State private var transitionDirection: TransitionDirection = .forward
    @Environment(\.colorScheme) private var colorScheme
    
    enum AuthView {
        case login, signup, resetPassword
    }
    
    enum TransitionDirection {
        case forward, backward
    }
    
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

struct SocialSignInButton: View {
    enum SocialType {
        case apple, google
    }
    
    let type: SocialType
    let action: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            
            // Add slight delay before action and resetting the button
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                action()
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
            }
        }) {
            HStack(spacing: 12) {
                // Icon
                if type == .apple {
                    Image(systemName: "applelogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                } else {
                    // Custom Google "G" logo
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 20, height: 20)
                        
                        Text("G")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(hex: "4285F4"))
                    }
                }
                
                // Text
                Text(type == .apple ? "Sign in with Apple" : "Sign in with Google")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(type == .apple ?
                                    (colorScheme == .dark ? .white : .black) :
                                    (colorScheme == .dark ? .white : Color(hex: "4285F4")))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                Group {
                    if type == .apple {
                        colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.05)
                    } else {
                        colorScheme == .dark ? Color(hex: "242536") : .white
                    }
                }
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        type == .apple ?
                        (colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.1)) :
                        Color(hex: "4285F4").opacity(0.5),
                        lineWidth: 1
                    )
            )
            .scaleEffect(isPressed ? 0.96 : 1)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal)
    }
}

struct ModernButton: View {
    let title: String
    let action: () -> Void
    let isPrimary: Bool
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            
            // Add slight delay before action and resetting the button
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                action()
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
            }
        }) {
            Text(title)
                .fontWeight(.bold)
                .foregroundColor(isPrimary ? .white : Color(hex: "4CC2FF"))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
//                            .fill(isPrimary ?
//                                  LinearGradient(gradient: Gradient(colors: [Color(hex: "4CC2FF"), Color(hex: "0F3460")]),
//                                                 startPoint: .topLeading, endPoint: .bottomTrailing)
//                                  :
//                                  Color.clear)
                        
                        if !isPrimary {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(hex: "4CC2FF"), lineWidth: 1.5)
                        }
                    }
                )
                .shadow(color: isPrimary ? Color(hex: "4CC2FF").opacity(0.3) : Color.clear, radius: 10, x: 0, y: 5)
                .scaleEffect(isPressed ? 0.96 : 1)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal)
    }
}

struct DividerWithText: View {
    let text: String
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack {
            VStack { Divider().background(colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.1)) }
                .frame(maxWidth: .infinity)
            
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(colorScheme == .dark ? .white.opacity(0.6) : .gray)
                .padding(.horizontal, 12)
            
            VStack { Divider().background(colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.1)) }
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal)
    }
}

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showLoginAnimation = false
    @State private var showingFields = false
    @Environment(\.colorScheme) private var colorScheme
    
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
                            print("Login with: \(email), \(password)")
                        },
                        isPrimary: true
                    )
                    .opacity(showingFields ? 1 : 0)
                    .offset(y: showingFields ? 0 : 20)
                    .animation(Animation.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: showingFields)
                    .padding(.top, 10)
                }
                
                Spacer(minLength: 60)
                
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
}

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
                
                Spacer(minLength: 40)
                
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

struct ResetPasswordView: View {
    @State private var email = ""
    @State private var showResetAnimation = false
    @State private var showingFields = false
    @State private var emailSent = false
    @Environment(\.colorScheme) private var colorScheme
    
    var onBackTap: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
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
            
            if !emailSent {
                resetForm
            } else {
                confirmationView
            }
            
            Spacer()
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.4)) {
                showResetAnimation = true
            }
            
            // Slight delay for fields to appear after header
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation {
                    showingFields = true
                }
            }
        }
    }
    
    var resetForm: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text("Reset Password")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 20)
                    .opacity(showResetAnimation ? 1 : 0)
                    .offset(y: showResetAnimation ? 0 : -30)
                    .animation(Animation.spring(response: 0.5, dampingFraction: 0.8).delay(0.1), value: showResetAnimation)
                
                Text("Enter your email to receive a reset link")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .opacity(showResetAnimation ? 1 : 0)
                    .offset(y: showResetAnimation ? 0 : -20)
                    .animation(Animation.spring(response: 0.5, dampingFraction: 0.8).delay(0.2), value: showResetAnimation)
            }
            .padding(.top, 20)
            .padding(.bottom, 40)
            
            ModernTextField(placeholder: "Email", iconName: "envelope", text: $email)
                .opacity(showingFields ? 1 : 0)
                .offset(y: showingFields ? 0 : 20)
                .animation(Animation.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: showingFields)
            
            ModernButton(
                title: "SEND RESET LINK",
                action: {
                    withAnimation(.spring()) {
                        emailSent = true
                    }
                },
                isPrimary: true
            )
            .opacity(showingFields ? 1 : 0)
            .offset(y: showingFields ? 0 : 20)
            .animation(Animation.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: showingFields)
            .padding(.top, 20)
        }
    }
    
    var confirmationView: some View {
        VStack(spacing: 30) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(Color(hex: "4CC2FF"))
                .padding()
                .opacity(0.9)
                .shadow(color: Color(hex: "4CC2FF").opacity(0.5), radius: 10, x: 0, y: 0)
            
            Text("Check Your Email")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            Text("We've sent a password reset link to \(email)")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            ModernButton(
                title: "BACK TO LOGIN",
                action: onBackTap,
                isPrimary: true
            )
            .padding(.top, 30)
        }
        .padding(.horizontal)
        .transition(.asymmetric(
            insertion: .scale.combined(with: .opacity),
            removal: .scale.combined(with: .opacity)
        ))
        .animation(.spring(response: 0.6, dampingFraction: 0.7), value: emailSent)
    }
}

// Extension for placeholder in TextField
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

// Extension for hex color support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    AuthContentView()
}
