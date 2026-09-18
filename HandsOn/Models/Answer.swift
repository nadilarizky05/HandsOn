//
//  Answer.swift
//  HandsOn
//
//  Created by Nadila Rizky Amelia on 14/09/26.
//

import Foundation

//Kumpul Jawaban
struct AnswerRequest: Codable {
    let question_id: Int
    let selected_option_id: Int
}

//Hasil Jawaban
struct AnswerResponse: Codable {
    let correct: Bool
    let explanation: String
}
