//
//  Score.swift
//  HandsOn
//
//  Created by Nadila Rizky Amelia on 14/09/26.
//

import Foundation

struct Score: Codable, Identifiable, Hashable {
    let id: String
    let userId: String
    let userName: String
    let subtopicId: String
    let score: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case userName = "user_name"
        case subtopicId = "subtopic_id"
        case score
    }
}
