//
//  QuestionViewModel.swift
//  HandsOn
//
//  Created by Nadila Rizky Amelia on 15/09/26.
//

import Foundation
import Combine

@MainActor
final class QuestionViewModel: ObservableObject {
    @Published var questionSet: QuestionSet?
    @Published var currentIndex = 0
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedOptionId: Int?
    @Published var isAnswerRevealed = false
    @Published var correctCount = 0
    @Published var didFinishQuiz = false
    @Published var scoreSubmitMessage: String?
    
    private let api: APIServicing
    private let leaderboard: LeaderboardServicing
    private let session: SessionStore
    private let subtopicId: String
    
    init(
        subtopicId: String,
        api: APIServicing = AppEnvironment.shared.api,
        leaderboard: LeaderboardServicing = AppEnvironment.shared.leaderboard,
        session: SessionStore = AppEnvironment.shared.session
    ){
        self.subtopicId = subtopicId
        self.api = api
        self.leaderboard = leaderboard
        self.session = session
    }
    
    var currentQuestion: Question? {
        guard let questionSet,
              questionSet.questions.indices.contains(currentIndex)
        else {
            return nil
        }
        return questionSet.questions[currentIndex]
    }
    
    var progressLabel: String {
        guard let questionSet else { return "" }
        return "Question \(currentIndex + 1)/\(questionSet.totalQuestions)"
    }
    
    var isLastQuestion: Bool {
        guard let questionSet else { return true}
        return currentIndex == questionSet.questions.count - 1
    }
    
    func load() async {
        isLoading = true
        errorMessage = nil
        do  {
            questionSet = try await
            api.fetchQuestions(subtopic_id: subtopicId)
        } catch {
            errorMessage = (error as? ErrorMessage)?.errorDescription ?? error.localizedDescription
        }
        isLoading = false
    }
    
    func selectedOption(_ optionId: Int) {
        guard !isAnswerRevealed else { return }
        selectedOptionId = optionId
        isAnswerRevealed = true
        
        if isCorrect(optionId) {
            correctCount += 1
        }
    }
    
    func isCorrect(_ optionId: Int) -> Bool{
        currentQuestion?.correctOptionId == optionId
    }
    
    func primaryAction() {
        if isLastQuestion {
            Task { await finishQuiz ()}
        } else {
            goToNext()
        }
    }
    
    private func goToNext() {
        guard let questionSet, currentIndex < questionSet.questions.count - 1 else { return }
        currentIndex += 1
        selectedOptionId = nil
        isAnswerRevealed = false
    }
    
    private func finishQuiz() async {
        guard let questionSet else { return }
        guard let user = session.currentUser else {
            scoreSubmitMessage = "Sign In to join the leaderboard. This score will not saved"
            didFinishQuiz = true
            return
        }
        
        do {
            _ = try await leaderboard.submitScore(
                subtopic_id: questionSet.subtopicId,
                user_id: user.id,
                user_name: user.userName,
                score: correctCount
            )
            scoreSubmitMessage = "Skor \(correctCount)/\(questionSet.totalQuestions) berhasil disimpan ke leaderboard"
        } catch {
            scoreSubmitMessage = (error as? ErrorMessage)?.errorDescription ?? error.localizedDescription
        }
        didFinishQuiz = true
    }
}
