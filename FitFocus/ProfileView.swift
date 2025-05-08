import SwiftUI
import SafariServices

struct ProfileView: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("stepGoal") private var stepGoal = 5000
    @State private var showingLogoutAlert = false
    @State private var showingQuickSetOptions = false
    
    // Animation properties
    @State private var profileOpacity: Double = 0
    @State private var notificationsOffset: CGFloat = 50
    @State private var stepsOffset: CGFloat = 50
    @State private var aboutOffset: CGFloat = 50
    @State private var logoutScale: CGFloat = 0.8
    
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    // App version info
    private let appVersion = "1.0.0"
    private let buildNumber = "1"
    
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
                Text("Hi \(userName)")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(authViewModel.currentUser?.email ?? "Email Not Found" )
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
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
                    ForEach([3000, 5000, 10000, 15000], id: \.self) { goal in
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
            NavigationLink(destination: HelpSupportView()) {
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
            NavigationLink(destination: PrivacyPolicyView()) {
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
                    signOut()
                },
                secondaryButton: .cancel()
            )
        }
        .padding(.bottom, 100)
    }
    
     private var userName: String {
         if let displayName = authViewModel.currentUser?.displayName, !displayName.isEmpty {
             return displayName
         } else {
             return "User"
         }
     }
                     
    private func signOut() {
        Task {
            await authViewModel.signOut()
        }
    }
}

// MARK: - Help & Support View
struct HelpSupportView: View {
    // Topics for getting started
    private let gettingStartedTopics = [
        (icon: "figure.walk", title: "Step Tracking", id: "step-tracking"),
        (icon: "bell.badge", title: "Notifications", id: "notifications"),
        (icon: "chart.bar", title: "Setting Goals", id: "goals")
    ]
    
    // Contact info
    private let emailAddress = "support@steptracker.com"
    private let twitterHandle = "@StepTrackerApp"
    private let twitterURL = "https://twitter.com/StepTrackerApp"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Getting Started Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Getting Started")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    ForEach(gettingStartedTopics, id: \.id) { topic in
                        NavigationLink(destination: TopicDetailView(topicId: topic.id)) {
                            guideItem(icon: topic.icon, title: topic.title)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
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
                    
                    // Email link
                    Button(action: {
                        if let url = URL(string: "mailto:\(emailAddress)") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        contactItem(icon: "envelope.fill", title: "Email Support", detail: emailAddress)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // Twitter link
                    Button(action: {
                        if let url = URL(string: twitterURL) {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        contactItem(icon: "bubble.left.fill", title: "Twitter", detail: twitterHandle)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // FAQ (navigates to new view)
                    NavigationLink(destination: FAQView()) {
                        contactItem(icon: "questionmark.circle.fill", title: "FAQ", detail: "Browse common questions")
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 5)
            }
            .padding()
        }
        .navigationTitle("Help & Support")
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }
    
    private func guideItem(icon: String, title: String) -> some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.caption)
        }
        .padding(.vertical, 8)
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
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            Image(systemName: "arrow.right")
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Topic Detail View
struct TopicDetailView: View {
    let topicId: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Topic content
                topicContent
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 5)
            }
            .padding()
        }
        .navigationTitle(titleForTopic)
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }
    
    private var titleForTopic: String {
        switch topicId {
        case "step-tracking": return "Step Tracking"
        case "notifications": return "Notifications"
        case "goals": return "Setting Goals"
        default: return "Topic"
        }
    }
    
    private var topicContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Image(systemName: iconForTopic)
                .font(.system(size: 48))
                .foregroundColor(.blue)
                .padding(.bottom, 8)
            
            Text(titleForTopic)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(contentForTopic)
                .font(.body)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
                .frame(height: 20)
            
            if let bulletPoints = bulletPointsForTopic {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(bulletPoints, id: \.self) { point in
                        HStack(alignment: .top) {
                            Text("•")
                                .font(.title3)
                                .foregroundColor(.blue)
                            Text(point)
                                .font(.body)
                        }
                    }
                }
            }
        }
    }
    
    private var iconForTopic: String {
        switch topicId {
        case "step-tracking": return "figure.walk"
        case "notifications": return "bell.badge"
        case "goals": return "chart.bar"
        default: return "questionmark"
        }
    }
    
    private var contentForTopic: String {
        switch topicId {
        case "step-tracking":
            return "Step tracking allows you to monitor your daily physical activity. Our app uses your device's motion sensors to count steps accurately throughout the day."
        case "notifications":
            return "Notifications help you stay on track with your fitness goals. You can customize which notifications you receive and when they appear."
        case "goals":
            return "Setting achievable step goals is essential for maintaining motivation and tracking your progress over time."
        default:
            return "Information about this topic will be available soon."
        }
    }
    
    private var bulletPointsForTopic: [String]? {
        switch topicId {
        case "step-tracking":
            return [
                "Allow health permissions when prompted to enable step tracking",
                "Keep your phone with you throughout the day for accurate counts",
                "The app syncs with Apple Health to ensure consistency",
                "View your step history in daily, weekly, and monthly charts"
            ]
        case "notifications":
            return [
                "Morning reminders help you start your day with intention",
                "Progress alerts let you know when you're halfway to your goal",
                "Achievement notifications celebrate your success",
                "All notifications can be customized in the app settings"
            ]
        case "goals":
            return [
                "Start with a realistic baseline (5,000 steps is often recommended)",
                "Gradually increase your goal as you build consistency",
                "You can set different goals for weekdays and weekends",
                "The app will suggest adjustments based on your activity patterns"
            ]
        default:
            return nil
        }
    }
}

// MARK: - FAQ View
struct FAQView: View {
    private let faqs = [
        (question: "How accurate is the step counter?",
         answer: "Our step counter is highly accurate and syncs with Apple Health data. The accuracy depends on how consistently you carry your device throughout the day."),
        (question: "Can I connect with friends?",
         answer: "Yes! You can add friends through the social tab and participate in challenges together."),
        (question: "How do I export my data?",
         answer: "Go to Settings > Data Management > Export Data to download your activity history in CSV format."),
        (question: "Does the app work without internet?",
         answer: "Yes, the app will continue tracking steps offline. It will sync your data when you reconnect to the internet.")
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(faqs, id: \.question) { faq in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(faq.question)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(faq.answer)
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        Divider()
                            .padding(.top, 8)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("FAQ")
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }
}

// MARK: - Privacy Policy View
struct PrivacyPolicyView: View {
    var body: some View {
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
        .navigationTitle("Privacy Policy")
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
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
#Preview {
    ProfileView()
        .environmentObject(AuthenticationViewModel())
}
