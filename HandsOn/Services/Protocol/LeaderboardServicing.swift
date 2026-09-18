//
//  LeaderboardServicing.swift
//  HandsOn
//
//  Created by Nadila Rizky Amelia on 15/09/26.
//

import Foundation

protocol LeaderboardServicing {
    func fetchLeaderboard(subtopic_id: String) async throws -> [Score]
    func submitScore(subtopic_id: String, user_id: String, user_name: String, score:Int) async throws -> Score
}
