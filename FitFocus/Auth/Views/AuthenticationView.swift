//
//  AuthenticationView.swift
//  FitFocus
//
//  Created by Eugene Obazee on 29/04/2025.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class AuthenticationView: ObservableObject{
    
    @Published var isLoginSuccessed = false
    @Published var currentUser: User?
    
    func signInWithGoogle(){
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: Application_utility.rootViewController) { user, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard
                let user = user?.user,
                let idToken = user.idToken else { return }
            
            let accessToken = user.accessToken
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { res, error in
                if let error = error{
                    print(error.localizedDescription)
                    return
                }
                guard let user = res?.user else { return }
                print(user)
            }
        }
        
    }
    
    func getCurrentUser() -> User? {
           return Auth.auth().currentUser
       }
    
    func logout() async throws{
        GIDSignIn.sharedInstance.signOut()
        try Auth.auth().signOut()
    }
   
}


//import SwiftUI
//import FirebaseAuth
//import Combine
//import Foundation
//
//@MainActor
//class AuthenticationViewModel: ObservableObject {
//    
//    // Published properties
//    @Published var state: SignInState = .signedOut
//    @Published var error: AuthError?
//    @Published var isLoading: Bool = false
//    @Published var signInMethod: String = "Unknown"
//    @Published var currentUser: User?
//    
//    // Dependencies
//    private let authRepository: AuthRepositoryProtocol
//    private var cancellables = Set<AnyCancellable>()
//    
//    // Initializer with dependency injection
//    init(authRepository: AuthRepositoryProtocol = FirebaseAuthRepository()) {
//        self.authRepository = authRepository
//        checkAuthenticationState()
//        setupAuthStateListener()
//    }
//    
//    // Listen for Firebase auth state changes
//    private func setupAuthStateListener() {
//        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
//            guard let self = self else { return }
//            
//            // Update current user
//            self.currentUser = user
//            
//            // Update auth state
//            self.state = user != nil ? .signedIn : .signedOut
//            
//            // Update sign in method if signed in
//            if let user = user {
//                self.determineSignInMethod(for: user)
//            }
//        }
//    }
//    
//    // Determine how the user signed in
//    private func determineSignInMethod(for user: User) {
//        if let providerData = user.providerData.first?.providerID {
//            switch providerData {
//            case "google.com":
//                signInMethod = "Google"
//            case "apple.com":
//                signInMethod = "Apple"
//            case "password":
//                signInMethod = "Email / Password"
//            default:
//                signInMethod = providerData
//            }
//        }
//    }
//    
//    // Check if user is already signed in
//    private func checkAuthenticationState() {
//        self.currentUser = authRepository.getCurrentUser()
//        
//        if currentUser != nil {
//            self.state = .signedIn
//            
//            // Try to determine sign-in method
//            if let user = currentUser {
//                determineSignInMethod(for: user)
//            }
//        } else {
//            self.state = .signedOut
//        }
//    }
//    
//    // MARK: - Authentication Methods
//    
//    /// Master login function that will handle multiple login types
//    func login(with loginOption: LoginOption) async {
//        isLoading = true
//        error = nil
//        
//        defer { isLoading = false }
//        
//        do {
//            switch loginOption {
//            case .signInWithApple:
//                try await signInWithApple()
//            case let .emailAndPassword(email, password):
//                try await signInWithEmail(email: email, password: password)
//            case .signInWithGoogle:
//                try await signInWithGoogle()
//            }
//            
//            // Save login state to UserDefaults
//            UserDefaults.standard.set(true, forKey: "isLoggedIn")
//            
//        } catch let authError as AuthError {
//            self.error = authError
//        } catch {
//            self.error = .signInFailed(description: error.localizedDescription)
//        }
//    }
//    
//    func signInWithEmail(email: String, password: String) async throws {
//        self.currentUser = try await authRepository.signInWithEmail(email: email, password: password)
//    }
//    
//    func signUp(email: String, password: String) async throws {
//        self.currentUser = try await authRepository.signUpWithEmail(email: email, password: password)
//    }
//    
//    func signInWithGoogle() async throws {
//        self.currentUser = try await authRepository.signInWithGoogle()
//    }
//    
//    func signInWithApple() async throws {
//        return try await withCheckedThrowingContinuation { continuation in
//            authRepository.signInWithApple { result in
//                switch result {
//                case .success(let user):
//                    self.currentUser = user
//                    continuation.resume()
//                case .failure(let error):
//                    continuation.resume(throwing: error)
//                }
//            }
//        }
//    }
//    
//    func signOut() async {
//        isLoading = true
//        error = nil
//        
//        do {
//            try await authRepository.signOut()
//            UserDefaults.standard.set(false, forKey: "isLoggedIn")
//            state = .signedOut
//            currentUser = nil
//        } catch {
//            self.error = error as? AuthError ?? .signOutFailed(description: error.localizedDescription)
//        }
//        
//        isLoading = false
//    }
//    
//    // MARK: - User Profile Methods
//    
//    func sendPasswordReset(email: String) async {
//        isLoading = true
//        error = nil
//        
//        do {
//            try await authRepository.sendPasswordReset(email: email)
//        } catch {
//            self.error = error as? AuthError ?? .passwordResetFailed(description: error.localizedDescription)
//        }
//        
//        isLoading = false
//    }
//    
//    func sendEmailVerification() async {
//        isLoading = true
//        error = nil
//        
//        do {
//            try await authRepository.sendEmailVerification()
//        } catch {
//            self.error = error as? AuthError
//        }
//        
//        isLoading = false
//    }
//    
//    func updateProfile(displayName: String?, photoURL: URL?) async {
//        isLoading = true
//        error = nil
//        
//        do {
//            try await authRepository.updateUserProfile(displayName: displayName, photoURL: photoURL)
//            // Refresh current user
//            self.currentUser = authRepository.getCurrentUser()
//        } catch {
//            self.error = error as? AuthError
//        }
//        
//        isLoading = false
//    }
//    
//    func updateEmail(email: String) async {
//        isLoading = true
//        error = nil
//        
//        do {
//            try await authRepository.updateEmail(email: email)
//            // Refresh current user
//            self.currentUser = authRepository.getCurrentUser()
//        } catch {
//            self.error = error as? AuthError
//        }
//        
//        isLoading = false
//    }
//    
//    func updatePassword(password: String) async {
//        isLoading = true
//        error = nil
//        
//        do {
//            try await authRepository.updatePassword(password: password)
//        } catch {
//            self.error = error as? AuthError
//        }
//        
//        isLoading = false
//    }
//    
//    func deleteAccount() async {
//        isLoading = true
//        error = nil
//        
//        do {
//            try await authRepository.deleteAccount()
//            UserDefaults.standard.set(false, forKey: "isLoggedIn")
//            state = .signedOut
//            currentUser = nil
//        } catch {
//            self.error = error as? AuthError
//        }
//        
//        isLoading = false
//    }
//    
//    func reauthenticate(email: String, password: String) async {
//        isLoading = true
//        error = nil
//        
//        do {
//            try await authRepository.reauthenticate(email: email, password: password)
//        } catch {
//            self.error = error as? AuthError
//        }
//        
//        isLoading = false
//    }
//}
//
//enum LoginOption {
//    case signInWithApple
//    case signInWithGoogle
//    case emailAndPassword(email: String, password: String)
//}
//
//enum AuthError: Error, LocalizedError {
//    case signInFailed(description: String)
//    case signUpFailed(description: String)
//    case signOutFailed(description: String)
//    case userNotFound
//    case invalidCredential
//    case noRootViewController
//    case emailNotVerified
//    case passwordResetFailed(description: String)
//    case updateProfileFailed(description: String)
//    case deleteAccountFailed(description: String)
//    case reauthenticationFailed(description: String)
//    case updateEmailFailed(description: String)
//    case updatePasswordFailed(description: String)
//    
//    var errorDescription: String? {
//        switch self {
//        case .signInFailed(let description):
//            return "Sign in failed: \(description)"
//        case .signUpFailed(let description):
//            return "Sign up failed: \(description)"
//        case .signOutFailed(let description):
//            return "Sign out failed: \(description)"
//        case .userNotFound:
//            return "User not found"
//        case .invalidCredential:
//            return "Invalid credentials"
//        case .noRootViewController:
//            return "Could not find root view controller"
//        case .emailNotVerified:
//            return "Email not verified"
//        case .passwordResetFailed(let description):
//            return "Password reset failed: \(description)"
//        case .updateProfileFailed(let description):
//            return "Failed to update profile: \(description)"
//        case .deleteAccountFailed(let description):
//            return "Failed to delete account: \(description)"
//        case .reauthenticationFailed(let description):
//            return "Reauthentication required: \(description)"
//        case .updateEmailFailed(let description):
//            return "Failed to update email: \(description)"
//        case .updatePasswordFailed(let description):
//            return "Failed to update password: \(description)"
//        }
//    }
//}
