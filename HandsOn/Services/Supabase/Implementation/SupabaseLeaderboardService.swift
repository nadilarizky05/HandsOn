//
//  SupabaseLeaderboardService.swift
//  HandsOn
//
//  Created by Nadila Rizky Amelia on 15/09/26.
//

import Foundation
import Supabase

final class SupabaseLeaderboardService: LeaderboardServicing {
    private let client = SupabaseClientProvider.client
    
    func fetchLeaderboard(subtopic_id: String) async throws -> [Score] {
        do {
            let response = try await client
                .from("scores")
                .select()
                .eq("subtopic_id", value: subtopic_id)
                .order("score", ascending: false)
                .execute()
            
            let decoder = JSONDecoder()
            return try decoder.decode([Score].self, from: response.data)
        } catch let error as ErrorMessage {
            throw error
        } catch {
            throw ErrorMessage.network(error.localizedDescription)
        }
    }
    
    func submitScore(subtopic_id: String, user_id: String, user_name: String, score: Int) async throws -> Score {
        do {
            let existingResponse = try await client
                .from("scores")
                .select()
                .eq("subtopic_id", value: subtopic_id)
                .eq("user_id", value: user_id)
                .execute()
            
            let decoder = JSONDecoder()
            let existingEntries = try decoder.decode([Score].self, from: existingResponse.data)
            
            if let current = existingEntries.first {
                guard score > current.score else { return current }
                
                let response = try await client
                    .from("scores")
                    .update(["score": AnyJSON.integer(score), "user_name": AnyJSON.string(user_name)])
                    .eq("id", value: current.id)
                    .select()
                    .single()
                    .execute()
                
                return try decoder.decode(Score.self, from: response.data)
                
            } else {
                let response = try await client
                    .from("scores")
                    .insert([
                        "user_id": AnyJSON.string(user_id),
                        "subtopic_id": AnyJSON.string(subtopic_id),
                        "user_name": AnyJSON.string(user_name),
                        "score": AnyJSON.integer(score)
                    ])
                    .select()
                    .single()
                    .execute()
                let decoder = JSONDecoder()
                return try decoder.decode(Score.self, from: response.data)
            }
        } catch let error as ErrorMessage {
            throw error
        } catch {
            throw ErrorMessage.network(error.localizedDescription)
        }
    }
}
