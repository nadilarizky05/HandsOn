//
//  LeaderboardView.swift
//  HandsOn
//
//  Created by Nadila Rizky Amelia on 16/09/26.
//

import SwiftUI

struct LeaderboardView: View {
    let subtopicId: String
    let subtopicName: String
    
    @EnvironmentObject private var session: SessionStore
    @StateObject private var vm: LeaderboardViewModel
    
    init(subtopicId: String, subtopicName: String){
        self.subtopicId = subtopicId
        self.subtopicName = subtopicName
        _vm = StateObject(wrappedValue: LeaderboardViewModel(subtopicId: subtopicId))
    }
    
    var body: some View {
        contentView
            .navigationTitle("Leaderboard: \(subtopicName)")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await vm.load()
            }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if vm.isLoading {
            ProgressView("Loading Leaderboard...")
        } else if let errorMessage = vm.errorMessage {
            ErrorStateView(message: errorMessage) {
                Task { await vm.load() }
            }
        } else if vm.entries.isEmpty {
            VStack(spacing: 8) {
                Image(systemName: "trophy")
                    .font(.system(size: 32))
                    .foregroundStyle(.secondary)
                Text("No scores submitted yet for this topic")
                    .foregroundStyle(.secondary)
            }
        } else {
            List {
                ForEach(Array(vm.entries.enumerated()), id: \.element.id) { index, entry in
                    HStack {
                        Text("#\(index + 1)")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                            .frame(width: 36, alignment: .leading)
                        
                        Text(entry.userName)
                            .fontWeight(entry.userId == session.currentUser?.id ? .bold : .regular)
                        
                        Spacer()
                        
                        Text("\(entry.score)")
                            .font(.headline)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        LeaderboardView(subtopicId: "variables-constants", subtopicName: "Variables & Constants")
    }
    .environmentObject(SessionStore(auth: MockAuthService()))
}
