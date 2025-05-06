//
//  AppCategoryListView.swift
//  FitFocus
//
//  Created by Eugene Obazee on 23/04/2025.
//

import SwiftUI

struct AppCategoryListView: View {
    @EnvironmentObject var appManager: AppManager
    
    var body: some View {
        NavigationView {
            List {
                ForEach(appManager.appCategories) { category in
                    Section(header: Text(category.name)) {
                        ForEach(category.apps) { app in
                            NavigationLink(destination: AppDetailView(app: app)) {
                                AppRowView(app: app)
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("App Categories")
        }
    }
}

struct AppRowView: View {
    let app: AppInfo
    @EnvironmentObject var appManager: AppManager
    
    var isRestricted: Bool {
        appManager.restrictedApps.contains { $0.app.id == app.id }
    }
    
    var body: some View {
        HStack {
            Image(systemName: app.icon)
                .font(.title2)
                .frame(width: 36, height: 36)
                .background(Color.blue.opacity(0.1))
                .foregroundColor(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Text(app.name)
                .font(.body)
            
            Spacer()
            
            if isRestricted {
                Image(systemName: "lock.fill")
                    .foregroundColor(.orange)
            }
        }
    }
}

struct AppDetailView: View {
    let app: AppInfo
    @EnvironmentObject var appManager: AppManager
    @EnvironmentObject var healthStore: HealthStore
    @State private var stepGoal: Double = 5000
    @State private var isRestricted: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    private var existingRestriction: RestrictedApp? {
        appManager.restrictedApps.first { $0.app.id == app.id }
    }
    
    var body: some View {
        Form {
            Section(header: Text("App Info")) {
                HStack {
                    Image(systemName: app.icon)
                        .font(.title)
                        .frame(width: 50, height: 50)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    VStack(alignment: .leading) {
                        Text(app.name)
                            .font(.headline)
                        Text("ID: \(app.id)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Section(header: Text("Step Restriction")) {
                Toggle("Restrict App Access", isOn: $isRestricted)
                    .onChange(of: isRestricted) { newValue in
                        if !newValue {
                            appManager.removeRestriction(for: app.id)
                        }
                    }
                
                if isRestricted {
                    VStack(alignment: .leading) {
                        Text("Set Step Goal: \(Int(stepGoal))")
                        
                        Slider(value: $stepGoal, in: 1000...20000, step: 500)
                            .accentColor(.blue)
                    }
                    
                    HStack {
                        Text("Current Steps: ")
                        Spacer()
                        Text("\(healthStore.steps)")
                            .fontWeight(.bold)
                    }
                    
                    HStack {
                        Text("Steps Needed: ")
                        Spacer()
                        Text("\(max(0, Int(stepGoal) - healthStore.steps))")
                            .fontWeight(.bold)
                            .foregroundColor(healthStore.steps >= Int(stepGoal) ? .green : .orange)
                    }
                    
                    if healthStore.steps >= Int(stepGoal) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Goal achieved! App is accessible.")
                                .foregroundColor(.green)
                        }
                    } else {
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.orange)
                            Text("App is locked until step goal is met.")
                                .foregroundColor(.orange)
                        }
                    }
                    
                    Button(action: {
                        appManager.restrictApp(app: app, stepGoal: Int(stepGoal))
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save Restriction")
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(BorderedButtonStyle())
                }
            }
        }
        .navigationTitle("App Details")
        .onAppear {
            if let restriction = existingRestriction {
                isRestricted = true
                stepGoal = Double(restriction.stepGoal)
            }
        }
    }
}

#Preview {
    AppCategoryListView()
        .environmentObject(AppManager())
}
