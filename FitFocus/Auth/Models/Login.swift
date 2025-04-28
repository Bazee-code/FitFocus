//
//  Login.swift
//  FitFocus
//
//  Created by Eugene Obazee on 27/04/2025.
//

import SwiftUI

struct AnimatedGradientBackground: View {
    @State private var animateGradient = false
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "#800000"),
                Color(hex: "#800000"),
                Color(hex:"16213E"),
            ]),
            startPoint: animateGradient ? .topLeading : .bottomTrailing,
            endPoint: animateGradient ? .bottomTrailing : .center
        )
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.linear(duration: 4.0).repeatForever(autoreverses: true)) {
                animateGradient.toggle()
            }
        }
    }
}

struct ModernTextField: View {
    let placeholder: String
    let iconName: String
    @Binding var text: String
    var isSecure: Bool = false
    @Environment(\.colorScheme) private var colorScheme
    @State private var isFocused = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if isFocused || !text.isEmpty {
                Text(placeholder)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "4CC2FF"))
                    .padding(.leading, 36)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
            
            HStack(spacing: 10) {
                Image(systemName: iconName)
                    .foregroundColor(isFocused ? Color(hex: "4CC2FF") : .gray)
                    .frame(width: 20)
                
                if isSecure {
                    SecureField("", text: $text)
                        .placeholder(when: text.isEmpty && !isFocused) {
                            Text(placeholder).foregroundColor(.gray.opacity(0.7))
                        }
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .autocapitalization(.none)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                isFocused = true
                            }
                        }
                } else {
                    TextField("", text: $text)
                        .placeholder(when: text.isEmpty && !isFocused) {
                            Text(placeholder).foregroundColor(.gray.opacity(0.7))
                        }
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .autocapitalization(.none)
                        .keyboardType(placeholder.lowercased().contains("email") ? .emailAddress : .default)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                isFocused = true
                            }
                        }
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(colorScheme == .dark ? Color(hex: "242536") : Color.white)
                    .shadow(color: isFocused ? Color(hex: "4CC2FF").opacity(0.3) : Color.black.opacity(0.05), radius: isFocused ? 5 : 3, x: 0, y: isFocused ? 3 : 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isFocused ? Color(hex: "4CC2FF") : Color.clear,
                        lineWidth: 1.5
                    )
            )
        }
        .animation(.spring(response: 0.3), value: isFocused)
        .padding(.horizontal)
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
                            .foregroundColor(colorScheme == .dark ? .red : .black)
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
                .foregroundColor(isPrimary ? .red : .black)
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
