//
//  SupabaseAPIService.swift
//  HandsOn
//
//  Created by Nadila Rizky Amelia on 15/09/26.
//

import Foundation
import Supabase

final class SupabaseAPIService: APIServicing {
    private let client = SupabaseClientProvider.client //nampung connectnya
    
    func fetchTopics() async throws -> [Topic] {
        do {
            let response = try await client
                .from("topics") //pergi ke table topics
                .select("*, subtopics(*)") //ambil semua kolom topics + nested subtopics
                .order("name") //urutkan berdasarkan nama
                .execute() //JALANIN sekarang
            
            let decoder = JSONDecoder()
            return try decoder.decode([Topic].self, from: response.data)
            
        } catch let error as ErrorMessage {
            throw error
        } catch {
            print("❌ fetchTopics raw error: \(error)")  // tambahkan ini
            throw ErrorMessage.network(error.localizedDescription)
        }
    }
    
    func fetchQuestions(subtopic_id: String) async throws -> QuestionSet {
        //Data Transfer Object
        struct SubtopicWithQuestionDTO: Decodable {
            let id: String
            let name: String
            let totalQuestions: Int
            let questions: [Question]
            
            enum CodingKeys: String, CodingKey {
                case id
                case name
                case totalQuestions = "total_questions"
                case questions
            }
        }
        
        do {
            let response = try await client
                .from("subtopics")
                .select("*, questions(*, options(*))")  // Include nested questions with options
                .eq("id", value: subtopic_id)
                .single()
                .execute()
            
            let decoder = JSONDecoder()
            let dto = try decoder.decode(SubtopicWithQuestionDTO.self, from: response.data)
            return QuestionSet(
                subtopicId: dto.id,
                subtopicName: dto.name,
                totalQuestions: dto.totalQuestions,
                questions: dto.questions.sorted { $0.order < $1.order }
            )
            
        } catch let error as ErrorMessage {
            throw error
        } catch {
            throw ErrorMessage.network(error.localizedDescription)
        }
    }
    
    func submitAnswer(question_id: Int, selected_option_id: Int) async throws -> AnswerResponse {
        //Data Transfer Object
        struct CorrectRow: Decodable {
            let correctOptionId: Int
            
            enum CodingKeys: String, CodingKey {
                case correctOptionId = "correct_option_id"
            }
        }
        
        do {
            let response = try await client
                .from("questions")
                .select("correct_option_id")
                .eq("id", value: question_id)
                .single()
                .execute()
            
            let decoder = JSONDecoder()
            let dto = try decoder.decode(CorrectRow.self, from: response.data)
            let isCorrect = dto.correctOptionId == selected_option_id
            
            return AnswerResponse(
                correct: isCorrect,
                explanation: isCorrect ? "Answer Correct!" : "Try Again"
            )
        }
    }
}
