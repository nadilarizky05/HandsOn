//
//  Subtopic.swift
//  HandsOn
//
//  Created by Nadila Rizky Amelia on 14/09/26.
//

import Foundation

//Subtopic = Variable, Loop, Function, dstnya
struct Subtopic: Codable, Identifiable, Hashable {
    let id: String
    let topicId: String
    let name: String
    let totalQuestions: Int
    let order: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case topicId = "topic_id"
        case name
        case totalQuestions = "total_questions"
        case order
    }
}
