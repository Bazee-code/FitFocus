//
//  ResetPasswordView.swift
//  FitFocus
//
//  Created by Eugene Obazee on 28/04/2025.
//

import SwiftUI

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

