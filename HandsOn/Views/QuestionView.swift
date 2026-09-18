//
//  QuestionView.swift
//  HandsOn
//
//  Created by Nadila Rizky Amelia on 15/09/26.
//

import SwiftUI

struct QuestionView: View {
    let subtopicId: String
    let subtopicName: String
    
    @StateObject private var vm: QuestionViewModel
    @State private var showLeaderboard = false
    
    init(subtopicId: String, subtopicName: String) {
        self.subtopicId = subtopicId
        self.subtopicName = subtopicName
        _vm = StateObject(wrappedValue: QuestionViewModel(subtopicId: subtopicId))
    }
    
    var body: some View {
        contentView
            .navigationTitle(subtopicName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showLeaderboard = true
                    } label: {
                        Image(systemName: "trophy")
                    }
                }
            }
            .navigationDestination(isPresented: $showLeaderboard) {
                LeaderboardView(subtopicId: subtopicId, subtopicName: subtopicName)
            }
            .task {
//                UserDefaultStore.saveLastOpenedSubtopic(id: subtopicId, name: subtopicName)
                await vm.load()
            }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if vm.isLoading {
            ProgressView("Loading Questions...")
        } else if let errorMessage = vm.errorMessage {
            ErrorStateView(message: errorMessage) {
                Task { await vm.load()}
            }
        } else if vm.didFinishQuiz {
            FinishedQuizView(
                correctCount: vm.correctCount,
                total: vm.questionSet?.totalQuestions ?? 0,
                message: vm.scoreSubmitMessage,
                onViewLeaderboard: {showLeaderboard = true}
            )
        } else if vm.questionSet?.questions.isEmpty ?? true {
            VStack(spacing: 8) {
                Image(systemName: "tray")
                    .font(.system(size: 32))
                    .foregroundStyle(.secondary)
                Text("No questions available for this subtopic yet.")
                    .foregroundStyle(.secondary)
            }
        } else if let question = vm.currentQuestion {
            QuestionContent(
                question: question,
                progressLabel: vm.progressLabel,
                selectedOptionId: vm.selectedOptionId,
                isAnswerRevealed: vm.isAnswerRevealed,
                isLastQuestion: vm.isLastQuestion,
                isCorrect: vm.isCorrect,
                onSelect: vm.selectedOption,
                onPrimaryAction: vm.primaryAction
            )
        }
    }
}

private struct QuestionContent: View {
    let question: Question
    let progressLabel: String
    let selectedOptionId: Int?
    let isAnswerRevealed: Bool
    let isLastQuestion: Bool
    let isCorrect: (Int) -> Bool
    let onSelect: (Int) -> Void
    let onPrimaryAction: () -> Void
    
    @State private var isHintShown = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing:20){
                Text(progressLabel)
                    .font(.headline)
                
                Text(question.question)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                DisclosureGroup("Hint: Click to show", isExpanded: $isHintShown) {
                    Text(question.hint)
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
                }
                .font(.subheadline.italic())
                
                VStack(spacing: 12) {
                    ForEach(question.options ?? []) {option in
                        OptionRow(
                            index: (question.options ?? []).firstIndex(of:option).map { $0 + 1 } ?? 0,
                            option: option,
                            isSelected: selectedOptionId == option.id,
                            isRevealed: isAnswerRevealed,
                            isCorrect: isCorrect(option.id)
                        ) {
                            onSelect(option.id)
                        }
                    }
                }
                if isAnswerRevealed {
                    Button(isLastQuestion ? "Finish" : "Next Question", action: onPrimaryAction)
                        .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)
                }
            }
            .padding()
        }
    }
}

private struct OptionRow: View {
    let index: Int
    let option: Option
    let isSelected: Bool
    let isRevealed: Bool
    let isCorrect: Bool
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Option \(index):")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Button(action: action) {
                Text(option.code)
                    .font(.system(.body, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(backgroundColor)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(isRevealed)
        }
    }
    
    private var backgroundColor: Color {
        guard isRevealed else {
            return Color.black.opacity(0.85)
        }
        if isCorrect {
            return .green
        }
        if isSelected {
            return .red
        }
        return Color.black.opacity(0.4)
    }
}

private struct FinishedQuizView: View {
    let correctCount: Int
    let total: Int
    let message: String?
    let onViewLeaderboard: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 48))
                .foregroundStyle(.green)
            
            Text("\(correctCount)/\(total) correct")
                .font(.title2)
                .fontWeight(.bold)

            if let message {
                Text(message)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
            }

            Button("View Leaderboard", action: onViewLeaderboard)
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        QuestionView(subtopicId: "variables-constants", subtopicName: "Variables & Constants")
    }
    .environmentObject(SessionStore(auth: MockAuthService()))
}
