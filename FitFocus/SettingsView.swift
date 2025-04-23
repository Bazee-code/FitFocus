//
//  SettingsView.swift
//  FitFocus
//
//  Created by Eugene Obazee on 23/04/2025.
//

import SwiftUI

extension Date: RawRepresentable {
    public var rawValue: String {
        self.timeIntervalSinceReferenceDate.description
    }
    
    public init?(rawValue: String) {
        self = Date(timeIntervalSinceReferenceDate: Double(rawValue) ?? 0.0)
    }
}

struct SettingsView: View {
    @AppStorage("defaultStepGoal") private var defaultStepGoal: Int = 5000
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true
    @State private var showResetAlert = false
    @EnvironmentObject var appManager: AppManager
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Step Goals")) {
                    Stepper("Default Step Goal: \(defaultStepGoal)", value: $defaultStepGoal, in: 1000...20000, step: 500)
                    
                    HStack {
                        Text("Quick Set:")
                        
                        Button("3000") { defaultStepGoal = 3000 }
                            .buttonStyle(BorderedButtonStyle())
                        
                        Button("5000") { defaultStepGoal = 5000 }
                            .buttonStyle(BorderedButtonStyle())
                        
                        Button("10000") { defaultStepGoal = 10000 }
                            .buttonStyle(BorderedButtonStyle())
                    }
                }
                
                Section(header: Text("Notifications")) {
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                    
                    if notificationsEnabled {
                        NavigationLink(destination: NotificationSettingsView()) {
                            Text("Configure Notifications")
                        }
                    }
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    NavigationLink(destination: HelpView()) {
                        Text("Help & Support")
                    }
                    
                    NavigationLink(destination: PrivacyView()) {
                        Text("Privacy Policy")
                    }
                }
                
                Section {
                    Button(action: {
                        showResetAlert = true
                    }) {
                        Text("Reset All Restrictions")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Settings")
            .alert(isPresented: $showResetAlert) {
                Alert(
                    title: Text("Reset Restrictions"),
                    message: Text("Are you sure you want to remove all app restrictions?"),
                    primaryButton: .destructive(Text("Reset")) {
                        // In a real app, we'd clear all restrictions here
                        // This is a placeholder
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

struct NotificationSettingsView: View {
    @AppStorage("goalCompletionNotifications") private var goalCompletionNotifications = true
    @AppStorage("dailyReminderNotifications") private var dailyReminderNotifications = true
    @AppStorage("reminderTime") private var reminderTime = Date()
    
    var body: some View {
        Form {
            Section(header: Text("Notification Types")) {
                Toggle("Goal Completion", isOn: $goalCompletionNotifications)
                Toggle("Daily Reminders", isOn: $dailyReminderNotifications)
            }
            
            if dailyReminderNotifications {
                Section(header: Text("Reminder Time")) {
                    DatePicker("Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                }
            }
        }
        .navigationTitle("Notifications")
    }
}

struct HelpView: View {
    var body: some View {
        List {
            Section(header: Text("Getting Started")) {
                NavigationLink("How to use StepLimit", destination: Text("Tutorial content here"))
                NavigationLink("Setting up HealthKit", destination: Text("HealthKit guide here"))
                NavigationLink("App restriction guide", destination: Text("Restriction guide here"))
            }
            
            Section(header: Text("Contact")) {
                Link("Email Support", destination: URL(string: "mailto:support@steplimit.app")!)
                Link("Twitter", destination: URL(string: "https://twitter.com/steplimitapp")!)
            }
        }
        .navigationTitle("Help & Support")
    }
}

struct PrivacyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                Text("Last Updated: April 17, 2025")
                    .foregroundColor(.secondary)
                
                Text("Step and health data privacy")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("StepLimit accesses your step count data through Apple HealthKit. This data is only used within the app to determine if you've met your step goals and is never transmitted to our servers or any third parties.")
                
                Text("App usage monitoring")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("StepLimit uses the ManagedSettings framework to monitor and limit access to apps you've selected. We do not track which apps you use or for how long beyond what is necessary for the core functionality of the app.")
                
                // Add more privacy policy sections as needed
            }
            .padding()
        }
        .navigationTitle("Privacy Policy")
    }
}

#Preview {
    SettingsView()
}
