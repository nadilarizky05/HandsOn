//
//  MockAPIService.swift
//  HandsOn
//
//  Created by Nadila Rizky Amelia on 15/09/26.
//

import Foundation

final class MockAPIService: APIServicing {
    
    private func loadRoot() throws -> MockDataRoot {
        guard let url = Bundle.main.url(forResource: "mock_data", withExtension: "json") else {
            throw ErrorMessage.notFound
        }
        
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw ErrorMessage.network(error.localizedDescription)
        }
        
        do {
            return try JSONDecoder().decode(MockDataRoot.self, from:data )
        } catch {
            throw ErrorMessage.decodingFailed
        }
    }
    
    
    func fetchTopics() async throws -> [Topic] {
        try await Task.sleep(nanoseconds: 300_000_000)
        return try loadRoot().topics
    }
    
    func fetchQuestions(subtopic_id: String) async throws -> QuestionSet{
        try await Task.sleep(nanoseconds: 300_000_000)
        guard let set = try loadRoot().question_sets[subtopic_id] else {
            throw ErrorMessage.notFound
        }
        return set
    }
    
    func submitAnswer(question_id: Int, selected_option_id: Int) async throws -> AnswerResponse{
        try await Task.sleep(nanoseconds: 200_000_000)
        return AnswerResponse(correct: true, explanation: "This is example of MockAPIService")
    }
}
