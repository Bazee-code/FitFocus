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
    
    var body: some View {
        NavigationView{
            VStack(spacing: 40) {
                ScrollView(showsIndicators: false){
                    // Step counter display
                    VStack {
            
                        ZStack {
                            Circle()
                                .stroke(Color.red.opacity(0.8), lineWidth: 20)
                                .frame(width: 200, height: 200)
                            
                            Circle()
                                .trim(from: 0, to: min(CGFloat(healthStore.steps) / 10000, 1.0))
                            
                                .stroke(
                                    Color.green.opacity(0.8),
                                    style: StrokeStyle(lineWidth: 20, lineCap: .round)
                                )
                                .frame(width: 200, height: 200)
                                .rotationEffect(.degrees(-90))
                                .animation(.easeInOut, value: healthStore.steps)
                            
                            VStack {
                                Text("\(healthStore.steps)")
                                    .font(.system(size: 50, weight: .bold, design: .rounded))
                                    .foregroundColor(.primary)
                                    .scaleEffect(animationAmount)
                                    .animation(
                                        .spring(response: 0.4, dampingFraction: 0.6)
                                        .repeatCount(1),
                                        value: healthStore.steps
                                    )
                                    .onAppear {
                                        animationAmount = 1.1
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            animationAmount = 1.0
                                        }
                                    }
                                    .onChange(of: healthStore.steps) { _ in
                                        animationAmount = 1.1
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            animationAmount = 1.0
                                        }
                                    }
                                
                                Text("steps today")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.top, 10)
                    
                    // Goal progress section
                    VStack(spacing: 20) {
                        Text("Apps selected for tracking")
                            .font(.title3)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                        
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
            .padding(.top, 30)
            .navigationTitle("Hi Eugene")
            .onAppear {
                if healthStore.isAuthorized {
                    healthStore.fetchTodaySteps()
                } else {
                    healthStore.requestAuthorization()
                }
            }
        }
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
            AppStatus(appName: "Spotify", iconName: "music.note", goalSteps: 100)
        ]
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
                .background(Color.purple.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading) {
                Text(status.appName)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Text("Goal: \(status.goalSteps) steps")
                    .font(.subheadline)
                    .foregroundColor(.gray)
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
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}


#Preview {
    StepCountView()
        .environmentObject(HealthStore())
}
