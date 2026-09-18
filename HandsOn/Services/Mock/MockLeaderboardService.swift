//
//  MockLeaderboardService.swift
//  HandsOn
//
//  Created by Nadila Rizky Amelia on 15/09/26.
//

import Foundation

final class MockLeaderboardService: LeaderboardServicing {
    
    private var scoresBySubtopic: [String: [Score]] = [
        "variable-constanta": [
            Score(id: UUID().uuidString, userId: "seed-1", userName: "Kirana", subtopicId: "variable-constanta", score: 6),
            Score(id: UUID().uuidString, userId: "seed-2", userName: "Fajar", subtopicId: "variable-constanta", score: 5),
            Score(id: UUID().uuidString, userId: "seed-3", userName: "Bunga", subtopicId: "variable-constanta", score: 4),
        ],
        "tipe-data": [
            Score(id: UUID().uuidString, userId: "seed-1", userName: "Kirana", subtopicId: "tipe-data", score: 3),
            Score(id: UUID().uuidString, userId: "seed-2", userName: "Fajar", subtopicId: "tipe-data", score: 2),
        ],
    ]
    
    func fetchLeaderboard(subtopic_id: String) async throws -> [Score] {
        try await Task.sleep(nanoseconds: 300_000_000)
        let entries = scoresBySubtopic[subtopic_id] ?? []
        return entries.sorted { $0.score > $1.score}
    }
    
    func submitScore(subtopic_id: String, user_id: String, user_name: String, score:Int) async throws -> Score {
        try await Task.sleep(nanoseconds: 300_000_000)
        var entries = scoresBySubtopic[subtopic_id] ?? []
        
        if let index = entries.firstIndex(where: { $0.userId == user_id }) {
            if score > entries[index].score {
                let updated = Score(id: entries[index].id, userId: user_id, userName: user_name, subtopicId: subtopic_id, score: score)
                entries[index] = updated
                scoresBySubtopic[subtopic_id] = entries
                return updated
            } else {
                return entries[index]
            }
        } else {
            let newEntry = Score(id: UUID().uuidString, userId: user_id, userName: user_name, subtopicId: subtopic_id, score: score)
            entries.append(newEntry)
            scoresBySubtopic[subtopic_id] = entries
            return newEntry
        }
    }
    
    
}
