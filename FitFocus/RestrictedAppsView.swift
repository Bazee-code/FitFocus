//
//  RestrictedAppsView.swift
//  FitFocus
//
//  Created by Eugene Obazee on 23/04/2025.
//

import SwiftUI

struct RestrictedAppsView: View {
    @EnvironmentObject var appManager: AppManager
    @EnvironmentObject var healthStore: HealthStore
    
    var body: some View {
        NavigationView {
            if appManager.restrictedApps.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "lock.open.fill")
                        .font(.system(size: 70))
                        .foregroundColor(.gray)
                    
                    Text("No Restricted Apps")
                        .font(.title)
                        .fontWeight(.medium)
                    
                    Text("Go to Apps tab to set up step restrictions for your apps.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 40)
                }
                .navigationTitle("Restricted Apps")
            } else {
                List {
                    Section(header: Text("Current Restrictions")) {
                        ForEach(appManager.restrictedApps) { restrictedApp in
                            RestrictedAppRow(
                                restrictedApp: restrictedApp,
//                                currentSteps: healthStore.steps
                                currentSteps: 2000
                            )
                            .contextMenu {
                                Button(action: {
                                    appManager.removeRestriction(for: restrictedApp.app.id)
                                }) {
                                    Label("Remove Restriction", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .navigationTitle("Restricted Apps")
            }
        }
    }
}

struct RestrictedAppRow: View {
    let restrictedApp: RestrictedApp
    let currentSteps: Int
    
    var progress: Double {
        min(Double(currentSteps) / Double(restrictedApp.stepGoal), 1.0)
    }
    
    var isAccessible: Bool {
        currentSteps >= restrictedApp.stepGoal
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: restrictedApp.app.icon)
                    .font(.title2)
                    .frame(width: 40, height: 40)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                VStack(alignment: .leading) {
                    Text(restrictedApp.app.name)
                        .font(.headline)
                    
                    Text("Goal: \(restrictedApp.stepGoal) steps")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: isAccessible ? "lock.open.fill" : "lock.fill")
                    .foregroundColor(isAccessible ? .green : .orange)
            }
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: geometry.size.width, height: 8)
                        .opacity(0.2)
                        .foregroundColor(.gray)
                    
                    Rectangle()
                        .frame(width: geometry.size.width * progress, height: 8)
                        .foregroundColor(isAccessible ? .green : .blue)
                        .animation(.linear, value: progress)
                }
                .clipShape(RoundedRectangle(cornerRadius: 4))
            }
            .frame(height: 8)
            
            // Step status
            HStack {
                Text("\(currentSteps)/\(restrictedApp.stepGoal) steps")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if isAccessible {
                    Text("Unlocked")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.green)
                } else {
                    Text("Need \(restrictedApp.stepGoal - currentSteps) more steps")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.orange)
                }
            }
        }
        .padding(.vertical, 8)
    }
}


#Preview {
    RestrictedAppsView()
        .environmentObject(AppManager())
        .environmentObject(HealthStore())
}
