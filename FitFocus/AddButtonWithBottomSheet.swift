import SwiftUI

struct AddButtonWithBottomSheet: View {
    @State private var showSheet = false
    @State private var flicker = false

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            // Add Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        // Haptic feedback
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()

                        showSheet.toggle()
                    }) {
                        ZStack {
                            // Outer glow (non-interactive)
                            Circle()
                                .fill(Color.mint)
                                .frame(width: 90, height: 90)
                                .scaleEffect(flicker ? 1.1 : 0.9)
                                .opacity(flicker ? 0.2 : 0.1)
                                .blur(radius: 10)
                                .allowsHitTesting(false)

                            // Inner glow
                            Circle()
                                .fill(Color.mint)
                                .frame(width: 60, height: 60)
                                .shadow(color: .mint.opacity(0.6), radius: flicker ? 20 : 8)
                                .shadow(color: .mint.opacity(0.3), radius: flicker ? 30 : 10)

                            // Plus icon
                            Image(systemName: "plus")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .frame(width: 90, height: 90) // Prevent layout shifts
                        .blendMode(.screen)
                        .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: flicker)
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            flicker = true
        }
        .sheet(isPresented: $showSheet) {
            BottomSheetView()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}

struct BottomSheetView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Bottom Sheet")
                .font(.title2)
                .padding()

            Text("Drag up for full screen or down to dismiss.")
                .multilineTextAlignment(.center)
                .padding()

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.systemBackground))
    }
}

#Preview {
    AddButtonWithBottomSheet()
}
