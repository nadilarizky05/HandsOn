//
//  LeaderboardViewModel.swift
//  HandsOn
//
//  Created by Nadila Rizky Amelia on 15/09/26.
//

import Foundation
import Combine

@MainActor
final class LeaderboardViewModel: ObservableObject {
    @Published var entries: [Score] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let leaderboard: LeaderboardServicing
    private let subtopicId: String
    
    init(subtopicId: String, leaderboard: LeaderboardServicing = AppEnvironment.shared.leaderboard){
        self.subtopicId = subtopicId
        self.leaderboard = leaderboard
        
    }
    
    func load() async {
        isLoading = true
        errorMessage = nil
        
        do {
            entries = try await
                leaderboard.fetchLeaderboard(subtopic_id: subtopicId)
        } catch {
            errorMessage = (error as? ErrorMessage)?.errorDescription ?? error.localizedDescription
        }
        isLoading = false
    }
}
