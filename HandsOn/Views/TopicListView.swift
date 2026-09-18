//
//  TopicListView.swift
//  HandsOn
//
//  Created by Nadila Rizky Amelia on 15/09/26.
//

import SwiftUI

struct TopicListView: View {
    @StateObject private var vm = TopicListViewModel()
    @EnvironmentObject private var session: SessionStore
    @State private var showEnterName = false
    
    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("HandsOn")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        accountButton
                    }
                }
                .sheet(isPresented: $showEnterName) {
                    EnterNameView()
                        .environmentObject(session)
                }
                .task {
                    await session.restoreSessionIfAvailable()
                    await vm.loadTopics()
                }
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if vm.isLoading {
            ProgressView("Loading Topics...")
        } else if let errorMessage = vm.errorMessage {
            ErrorStateView(message: errorMessage) {
                Task { await vm.loadTopics() }
            }
        } else {
            List {
                Section {
                    ForEach(vm.topics) {topic in
                        NavigationLink(value: topic) {
                            TopicRow(topic: topic)
                        }
                    }
                }
            }
            .navigationDestination(for: Topic.self) {
                topic in
                SubtopicListView(topic: topic)
            }
        }
    }
    @ViewBuilder
    private var accountButton: some View {
        if session.isRestoringSession {
            ProgressView()
        } else if let user = session.currentUser {
            Menu {
                Button("Logout", role: .destructive) {
                    session.logout()
                }
            } label: {
                Label(user.userName, systemImage: "person.crop.circle.fill")
            }
        } else {
            Button {
                showEnterName = true
            } label: {
                Label("Start", systemImage: "person.crop.circle")
            }
        }
    }
}

private struct TopicRow: View {
    let topic: Topic
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(topic.name)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct ErrorStateView: View {
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "wifi.exlcamationmark")
                .font(.system(size: 36))
                .foregroundStyle(.secondary)
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            Button("Try Again", action: retryAction)
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}


#Preview {
    TopicListView()
        .environmentObject(SessionStore(auth: MockAuthService()))
}
