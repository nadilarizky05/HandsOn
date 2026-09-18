//
//  Question.swift
//  HandsOn
//
//  Created by Nadila Rizky Amelia on 14/09/26.
//

import Foundation

//Opsi Jawaban
struct Option: Codable, Identifiable, Hashable{
    let id: Int
    let questionId: Int
    let code: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case questionId = "question_id"
        case code
    }
}

//Nampilin Satu Soal
struct Question: Codable, Identifiable, Hashable{
    let id: Int
    let subtopicId: String
    let question: String
    let correctOptionId: Int
    let hint: String
    let order: Int
    let options: [Option]?  // Optional karena nested query
    
    enum CodingKeys: String, CodingKey {
        case id
        case subtopicId = "subtopic_id"
        case question
        case correctOptionId = "correct_option_id"
        case hint
        case order
        case options
    }
}

//Nampilin Satu Paket Soal (Per Subtopic)
struct QuestionSet: Codable {
    let subtopicId: String
    let subtopicName: String
    let totalQuestions: Int
    let questions: [Question]
    
    enum CodingKeys: String, CodingKey {
        case subtopicId = "subtopic_id"
        case subtopicName = "subtopic_name"
        case totalQuestions = "total_questions"
        case questions
    }
}
