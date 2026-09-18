//
//  MockAuthService.swift
//  HandsOn
//
//  Created by Nadila Rizky Amelia on 15/09/26.
//

import Foundation

final class MockAuthService: AuthServicing {
    private var fakeUser: AppUser?
    
    func restoreSession() async throws -> AppUser? {
        fakeUser
    }
    
    func signInAnonymously(user_name: String) async throws -> AppUser {
        try await Task.sleep(nanoseconds: 200_000_000)
        let user = AppUser(id: UUID().uuidString, userName: user_name)
        fakeUser = user
        return user
    }
    
    func logout() async throws {
        fakeUser = nil
    }
}
