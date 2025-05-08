import SwiftUI

struct ProfileView: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("stepGoal") private var stepGoal = 5000
    @State private var showingLogoutAlert = false
    @State private var showingQuickSetOptions = false
    @State private var showHelpScreen = false
    @State private var showPrivacyPolicy = false
    
    // Animation properties
    @State private var profileOpacity: Double = 0
    @State private var notificationsOffset: CGFloat = 50
    @State private var stepsOffset: CGFloat = 50
    @State private var aboutOffset: CGFloat = 50
    @State private var logoutScale: CGFloat = 0.8
    
    // App version info
    private let appVersion = "1.0.3"
    private let buildNumber = "42"
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile Section
                    profileSection
                        .opacity(profileOpacity)
                        .onAppear {
                            withAnimation(.easeOut(duration: 0.6)) {
                                profileOpacity = 1
                            }
                        }
                    
                    Divider()
                    
                    // Notifications Section
                    notificationsSection
                        .offset(y: notificationsOffset)
                        .onAppear {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.3)) {
                                notificationsOffset = 0
                            }
                        }
                    
                    Divider()
                    
                    // Steps Goal Section
                    stepsGoalSection
                        .offset(y: stepsOffset)
                        .onAppear {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.5)) {
                                stepsOffset = 0
                            }
                        }
                    
                    Divider()
                    
                    // About Section
                    aboutSection
                        .offset(y: aboutOffset)
                        .onAppear {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.7)) {
                                aboutOffset = 0
                            }
                        }
                    
                    Spacer()
                    
                    // Logout Button
                    logoutButton
                        .scaleEffect(logoutScale)
                        .onAppear {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.9)) {
                                logoutScale = 1
                            }
                        }
                }
                .padding()
                .navigationTitle("Profile")
                .sheet(isPresented: $showHelpScreen) {
                    HelpSupportView()
                }
                .sheet(isPresented: $showPrivacyPolicy) {
                    PrivacyPolicyView()
                }
            }
            .background(Color(.systemGroupedBackground))
            .edgesIgnoringSafeArea(.bottom)
        }
    }
    
    // MARK: - Profile Section
    private var profileSection: some View {
        HStack(spacing: 20) {
            // Profile Image
            Group {
                if let uiImage = UIImage(named: "bitmoji") {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(.blue)
                }
            }
            .frame(width: 90, height: 90)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.blue, lineWidth: 2))
            .shadow(radius: 3)
            
            // User Details
            VStack(alignment: .leading, spacing: 6) {
                Text("Eugene O.")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text("eugeneobazee2@gmail.com")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
//                Button(action: {
//                    // Edit profile action
//                }) {
//                    Text("Edit Profile")
//                        .font(.system(size: 14, weight: .medium))
//                        .foregroundColor(.white)
//                        .padding(.horizontal, 16)
//                        .padding(.vertical, 6)
//                        .background(Color.blue)
//                        .cornerRadius(20)
//                }
//                .padding(.top, 5)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - Notifications Section
    private var notificationsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "bell.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
                
                Text("Notifications")
                    .font(.headline)
                
                Spacer()
                
                Toggle("", isOn: $notificationsEnabled)
                    .labelsHidden()
            }
            
            Text("Receive push notifications for activity reminders, achievements, and updates")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - Steps Goal Section
    private var stepsGoalSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "figure.walk.circle.fill")
                    .foregroundColor(.green)
                    .font(.title2)
                
                Text("Daily Step Goal")
                    .font(.headline)
                
                Spacer()
            }
            
            Text("Set your daily step target")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                Slider(value: Binding(
                    get: { Double(stepGoal) },
                    set: { stepGoal = Int($0) }
                ), in: 1000...20000, step: 500)
                .accentColor(.green)
                
                Text("\(stepGoal)")
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.bold)
                    .frame(width: 60)
            }
            
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    showingQuickSetOptions.toggle()
                }
            }) {
                HStack {
                    Text("Quick Set")
                    Image(systemName: showingQuickSetOptions ? "chevron.up" : "chevron.down")
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.blue)
                .padding(.vertical, 4)
            }
            
            if showingQuickSetOptions {
                HStack(spacing: 12) {
                    ForEach([3000, 5000, 10000], id: \.self) { goal in
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                stepGoal = goal
                            }
                        }) {
                            Text("\(goal)")
                                .font(.system(size: 14, weight: .medium))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(stepGoal == goal ? Color.green : Color(.systemGray5))
                                .foregroundColor(stepGoal == goal ? .white : .primary)
                                .cornerRadius(12)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - About Section
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
                
                Text("About")
                    .font(.headline)
                
                Spacer()
            }
            
            // Version info
            HStack {
                Text("App Version")
                    .foregroundColor(.secondary)
                Spacer()
                Text("v\(appVersion) (\(buildNumber))")
                    .foregroundColor(.primary)
            }
            .padding(.vertical, 4)
            
            Divider()
                .padding(.vertical, 2)
            
            // Help & Support
            Button(action: {
                withAnimation {
                    showHelpScreen = true
                }
            }) {
                HStack {
                    Image(systemName: "questionmark.circle")
                        .foregroundColor(.blue)
                    Text("Help & Support")
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.vertical, 8)
            
            Divider()
                .padding(.vertical, 2)
            
            // Privacy Policy
            Button(action: {
                withAnimation {
                    showPrivacyPolicy = true
                }
            }) {
                HStack {
                    Image(systemName: "lock.shield")
                        .foregroundColor(.blue)
                    Text("Privacy Policy")
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.vertical, 8)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - Logout Button
    private var logoutButton: some View {
        Button(action: {
            withAnimation {
                showingLogoutAlert = true
            }
        }) {
            HStack {
                Text("Logout")
                    .fontWeight(.medium)
                Image(systemName: "rectangle.portrait.and.arrow.right")
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.red.opacity(0.8), Color.red]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(15)
            .shadow(color: Color.red.opacity(0.3), radius: 5, x: 0, y: 3)
        }
        .alert(isPresented: $showingLogoutAlert) {
            Alert(
                title: Text("Logout"),
                message: Text("Are you sure you want to logout?"),
                primaryButton: .destructive(Text("Logout")) {
                    // Perform logout action
                },
                secondaryButton: .cancel()
            )
        }
    }
}

// MARK: - Help & Support View
struct HelpSupportView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Getting Started Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Getting Started")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        guideItem(
                            icon: "figure.walk",
                            title: "Step Tracking",
                            description: "Allow the app to access your Health data to track steps."
                        )
                        
                        guideItem(
                            icon: "bell.badge",
                            title: "Notifications",
                            description: "Enable notifications to receive reminders and celebrate achievements."
                        )
                        
                        guideItem(
                            icon: "chart.bar",
                            title: "Setting Goals",
                            description: "Set your daily step goal in the profile section."
                        )
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 5)
                    
                    // Contact Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Contact Us")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        contactItem(
                            icon: "envelope.fill",
                            title: "Email Support",
                            detail: "support@steptracker.com"
                        )
                        
                        contactItem(
                            icon: "bubble.left.fill",
                            title: "Live Chat",
                            detail: "Available 9AM-5PM EST"
                        )
                        
                        contactItem(
                            icon: "questionmark.circle.fill",
                            title: "FAQ",
                            detail: "Browse common questions"
                        )
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 5)
                }
                .padding()
            }
            .navigationTitle("Help & Support")
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Done")
                    .fontWeight(.medium)
            })
            .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        }
    }
    
    private func guideItem(icon: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
    
    private func contactItem(icon: String, title: String, detail: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                
                Text(detail)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "arrow.right")
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Privacy Policy View
struct PrivacyPolicyView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Group {
                        Text("Privacy Policy")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.bottom, 5)
                        
                        Text("Last updated: May 1, 2025")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 20)
                        
                        policySection(
                            title: "Information We Collect",
                            content: "We collect information about your physical activity including step count, exercise duration, and other health metrics when you give us permission. We also collect basic account information and usage statistics to improve our service."
                        )
                        
                        policySection(
                            title: "How We Use Your Information",
                            content: "We use your information to provide step tracking features, personalize your experience, send you notifications (if enabled), and improve our application. We never sell your personal data to third parties."
                        )
                        
                        policySection(
                            title: "Data Storage & Security",
                            content: "All health data is stored securely using industry-standard encryption. Data is primarily stored locally on your device with encrypted backups to our secure cloud service only when you enable syncing."
                        )
                    }
                    
                    Group {
                        policySection(
                            title: "Third-Party Services",
                            content: "Our app integrates with Apple HealthKit to access and store health-related data. This integration is governed by Apple's privacy policy and your device settings."
                        )
                        
                        policySection(
                            title: "Your Rights & Choices",
                            content: "You can view, modify, or delete your data at any time through the app settings. You can also disable health tracking permissions through your device settings."
                        )
                    }
                }
                .padding()
            }
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Done")
                    .fontWeight(.medium)
            })
            .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        }
    }
    
    private func policySection(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(content)
                .font(.body)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
            
            Divider()
                .padding(.vertical, 8)
        }
    }
}

// Preview provider
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
