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
                Color(hex: "#0F3460"),
                Color(hex:"16213E"),
                Color(hex: "#FFA62B")
            ]),
            startPoint: animateGradient ? .topLeading : .bottomTrailing,
            endPoint: animateGradient ? .bottomTrailing : .center
        )
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.linear(duration: 5.0).repeatForever(autoreverses: true)) {
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
