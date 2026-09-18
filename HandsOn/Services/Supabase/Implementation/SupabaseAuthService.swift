//
//  SupabaseAuthService.swift
//  HandsOn
//
//  Created by Nadila Rizky Amelia on 15/09/26.
//

import Foundation
import Supabase

final class SupabaseAuthService: AuthServicing {
    private let client = SupabaseClientProvider.client
    
    func restoreSession() async throws -> AppUser? {
        do {
            let session = try await client.auth.session  // ambil session yang sudah ada
            return makeUser(from: session.user)
        } catch {
            return nil
        }
    }
    
    func signInAnonymously(user_name: String) async throws -> AppUser {
        let session = try await client.auth.signInAnonymously(
            data: ["user_name": .string(user_name)]
        )
        return makeUser(from: session.user)
    }
    
    func logout() async throws {
        try await client.auth.signOut()
    }
    
    private func makeUser(from authUser: Auth.User) -> AppUser {
        let name = authUser.userMetadata["user_name"]?.stringValue ?? "Anonymous"
        return AppUser(id: authUser.id.uuidString, userName: name)
    }
}
