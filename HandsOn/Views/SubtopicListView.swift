//
//  SubtopicListView.swift
//  HandsOn
//
//  Created by Nadila Rizky Amelia on 15/09/26.
//

import SwiftUI

struct SubtopicListView: View {
    let topic: Topic
        
    private var sortedSubtopics: [Subtopic] {
        (topic.subtopics ?? []).sorted { $0.order < $1.order }
    }
    
    var body: some View {
        List(sortedSubtopics) { subtopic in
            NavigationLink(value: subtopic) {
                SubtopicRow(subtopic: subtopic)
            }
        }
        .navigationTitle(topic.name)
        .navigationDestination(for: Subtopic.self) { subtopic in
            QuestionView(subtopicId: subtopic.id, subtopicName: subtopic.name)
        }
    }
}

private struct SubtopicRow: View {
    let subtopic: Subtopic
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(subtopic.name)
                .font(.headline)
            Text("\(subtopic.totalQuestions) questions")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        SubtopicListView(
            topic: Topic(
                id: "basic-swift",
                name: "Basic Swift",
                subtopics: [
                    Subtopic(id: "tipe-data", topicId: "basic-swift", name: "Tipe Data", totalQuestions: 3, order: 1),
                    Subtopic(id: "variable-constanta", topicId: "basic-swift", name: "Variable & Constanta", totalQuestions: 6, order: 2)
                ]
            )
        )
    }
}
