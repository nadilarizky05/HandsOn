//
//  APIServicing.swift
//  HandsOn
//
//  Created by Nadila Rizky Amelia on 15/09/26.
//

import Foundation

protocol APIServicing {
    func fetchTopics() async throws -> [Topic]
    func fetchQuestions(subtopic_id: String) async throws -> QuestionSet
    func submitAnswer(question_id: Int, selected_option_id:Int) async throws -> AnswerResponse
}

//ini seru, cara bacanya...
//fetchTopics: () = i don't need input, the topic will appear
//fetchQuestion: (subtopic_id) = i need subtopic_id as an input, to know witch subtopic user choose, so the questionset will appear
//submitanswer: (question_id, selected_option_id) = i need that input so i can response correctly


