//
//  StepCountView.swift
//  FitFocus
//
//  Created by Eugene Obazee on 23/04/2025.
//

import SwiftUI
import HealthKit
import ManagedSettings

struct StepCountView: View {
    @EnvironmentObject var healthStore: HealthStore
    @State private var animationAmount: CGFloat = 1.0
    @State private var showLoginAnimation = false
    @State private var animate = false
    @State private var showSheet = false
    @State private var flicker = false
    
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        NavigationStack{
            ZStack(alignment: .bottomTrailing) {
                VStack(spacing : 40){
                    ScrollView(showsIndicators: false){
                        VStack {
                            
                            ZStack {
                                stepCounterCard
                            }
                        }
                        .padding(.top, 10)
                        .padding(.horizontal, 10)
                        // Goal progress section
                        VStack(spacing: 20) {
                            HStack(){
                                Text("Selected Apps")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                
                            }
                            
                            VStack(spacing: 15) {
                                ForEach(appAccessStatus) { status in
                                    AppAccessStatusRow(status: status, currentSteps: healthStore.steps)
                                }
                            }
                            .padding(.horizontal)
                        }
                        Spacer()
                    }
                }
                
                Button{
                    // Haptic feedback
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.impactOccurred()

                    showSheet.toggle()
                    print("Add new app")
                } label: {
                    Image(systemName: "plus")
                      .font(.title.weight(.semibold))
                      .padding(10)
                      .background(.mint.opacity(0.6))
                      .foregroundColor(.white)
                      .clipShape(Circle())
                      .frame(width: 60, height: 70)
                      .scaleEffect(flicker ? 0.8 : 1.0)
                      .opacity(flicker ? 0.8 : 1.0)
//                      .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: flicker)
                         .onAppear {
                             flicker = true
                         }
                }
                }
            .navigationTitle("Hi \(userName)")
            .padding(.top, 30)
            .onAppear {
                if healthStore.isAuthorized {
                    healthStore.fetchTodaySteps()
                    showLoginAnimation = true
                } else {
                    healthStore.requestAuthorization()
                }
            }
            .sheet(isPresented: $showSheet) {
                BottomSheetView()
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
        }
    }
    
    private var userName: String {
        if let displayName = authViewModel.currentUser?.displayName, !displayName.isEmpty {
            return displayName
        } else {
            return "User"
        }
    }
    
    private var stepCounterCard: some View {
        VStack {
            HStack {
                Image(systemName: "figure.walk")
                            .font(.title)
                            .foregroundColor(.mint)
                            .scaleEffect(flicker ? 0.8 : 0.9)
                            .opacity(flicker ? 0.8 : 1.0)
                            .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: flicker)
                            .onAppear {
                                flicker = true
                            }
                
                Text("Today's Steps")
                    .font(.headline)
                    .padding(.horizontal, 2)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        healthStore.fetchTodaySteps()
                    }
                    print("fetched steps")
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.title3)
                }
            }
            
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 15)
                    .frame(width: 200, height: 200)
                
                Circle()
                    .trim(from: 0, to: min(CGFloat(healthStore.steps) / CGFloat(5000), 1.0))
                    .stroke(
                        Color.indigo ,
                        style: StrokeStyle(lineWidth: 15, lineCap: .round)
                    )
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 0.6), value: healthStore.steps)
                
                VStack {
                    Text("\(healthStore.steps)")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                        .contentTransition(.numericText())
                    
                    Text("steps")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            
            Text("Default Goal: 5000 steps")
                .font(.callout)
                .foregroundColor(.secondary)
                .padding(.top, 5)
            
            if healthStore.steps >= 5000 {
                Label("Goal Achieved! Apps Unlocked", systemImage: "checkmark.circle.fill")
                    .font(.callout)
                    .foregroundColor(.green)
                    .padding(.top, 5)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(white: 0.15))
                .shadow(color: Color.white.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    
    // This would normally come from the AppManager
    // Using mock data for demonstration
    var appAccessStatus: [AppStatus] {
        [
            AppStatus(appName: "Instagram", iconName: "camera.fill", goalSteps: 850),
            AppStatus(appName: "TikTok", iconName: "video.fill", goalSteps: 250),
            AppStatus(appName: "Twitter", iconName: "message.fill", goalSteps: 3000),
            AppStatus(appName: "Netflix", iconName: "tv.fill", goalSteps: 1000),
            AppStatus(appName: "Youtube", iconName: "play.rectangle.fill", goalSteps: 500),
            AppStatus(appName: "Spotify", iconName: "music.note", goalSteps: 100),
            AppStatus(appName: "Spotify", iconName: "music.note", goalSteps: 100),
            AppStatus(appName: "Spotify", iconName: "music.note", goalSteps: 100),
            AppStatus(appName: "Spotify", iconName: "music.note", goalSteps: 100),
            AppStatus(appName: "Spotify", iconName: "music.note", goalSteps: 100)
        ]
    }
}

struct BottomSheetView: View {
    var body: some View {
        VStack(spacing: 20) {
            AppCategoryListView()

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.systemBackground))
    }
}


struct AppStatus: Identifiable {
    let id = UUID()
    let appName: String
    let iconName: String
    let goalSteps: Int
}

struct AppAccessStatusRow: View {
    let status: AppStatus
    let currentSteps: Int
    
    var isAccessible: Bool {
        currentSteps >= status.goalSteps
    }
    
    var body: some View {
        HStack {
            Image(systemName: status.iconName)
                .font(.title2)
                .frame(width: 40, height: 40)
                .background(Color.mint.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.horizontal, 5)
            
            VStack(alignment: .leading) {
                Text(status.appName)
                    .font(.headline)
                    .foregroundColor(.gray)
                    .fontWeight(.semibold)
                
                Text("Goal: \(status.goalSteps) steps")
                    .font(.subheadline)
                    .foregroundColor(.gray.opacity(0.7))
            }
            
            Spacer()
            
            HStack {
                Image(systemName: isAccessible ? "lock.open.fill" : "lock.fill")
                    .foregroundColor(isAccessible ? .green : .red)
                
                Text(isAccessible ? "Unlocked" : "Locked")
                    .fontWeight(.medium)
                    .foregroundColor(isAccessible ? .green : .red)
            }
        }
        .padding()
//        .background(Color.white)
        .cornerRadius(12)
//        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(white: 0.15))
                .shadow(color: Color.white.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
}

#Preview {
    StepCountView()
        .environmentObject(HealthStore())
        .environmentObject(AuthenticationViewModel())
}
