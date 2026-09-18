//
//  SessionStore.swift
//  HandsOn
//
//  Created by Nadila Rizky Amelia on 15/09/26.
//

import Foundation
import Combine

@MainActor
final class SessionStore: ObservableObject {
    @Published var currentUser: AppUser?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isRestoringSession = true
    
    private let auth: AuthServicing
    
    init(auth: AuthServicing) {
        self.auth = auth
    }
    
    var isLoggedIn: Bool {
        currentUser != nil
    }
    
    func restoreSessionIfAvailable() async {
        isRestoringSession = true
//        currentUser = try? await auth.restoreSession()
        isRestoringSession = false
    }
    
    func signInAnonymously(user_name: String) async {
        isLoading = true
        errorMessage = nil
        do {
            currentUser = try await
            auth.signInAnonymously(user_name: user_name)
        } catch {
            errorMessage = (error as? ErrorMessage)?.errorDescription ?? error.localizedDescription
        }
        isLoading = false
    }
    
    func logout() {
        currentUser = nil
        Task {try? await auth.logout()}
    }
}
// Define AppUser model here to avoid conflicts with Supabase's User
struct AppUser: Codable, Identifiable, Hashable {
    let id: String
    let userName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userName = "user_name"
    }
}

