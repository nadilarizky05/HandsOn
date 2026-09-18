//
//  AppEnvironment.swift
//  HandsOn
//
//  Created by Nadila Rizky Amelia on 15/09/26.
//

import Foundation

@MainActor
final class AppEnvironment {
    static let shared = AppEnvironment()
    
    let api: APIServicing
    let auth: AuthServicing
    let leaderboard: LeaderboardServicing
    let session: SessionStore
    
    private init() {
        api = CachingAPIService(wrapping: SupabaseAPIService())
        let authService = SupabaseAuthService()
        auth = authService
        session = SessionStore(auth: authService)
        leaderboard = SupabaseLeaderboardService()
    }
}
