//
//  CachingAPIService.swift
//  HandsOn
//
//  Created by Nadila Rizky Amelia on 15/09/26.
//

import Foundation

final class CachingAPIService: APIServicing {
    private let wrapped: APIServicing
    private var topicCache: [Topic]?
    private var questionSetCache: [String: QuestionSet] = [:]
    
    init(wrapping service:APIServicing) {
        self.wrapped = service
    }
    
    func fetchTopics() async throws -> [Topic] {
        if let topicCache {
            return topicCache
        }
        
        let topics = try await wrapped.fetchTopics()
        topicCache = topics
        return topics
    }
    
    func fetchQuestions(subtopic_id: String) async throws -> QuestionSet {
        if let cached = questionSetCache[subtopic_id] {
            return cached
        }
        
        let set = try await wrapped.fetchQuestions(subtopic_id: subtopic_id)
        questionSetCache[subtopic_id] = set
        return set
    }
    
    func submitAnswer(question_id: Int, selected_option_id: Int) async throws -> AnswerResponse {
        try await wrapped.submitAnswer(question_id: question_id, selected_option_id: selected_option_id)
    }
    
    func clearCache() {
        topicCache = nil
        questionSetCache.removeAll()
    }
}
