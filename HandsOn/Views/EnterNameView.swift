//
//  EnterNameView.swift
//  HandsOn
//
//  Created by Nadila Rizky Amelia on 16/09/26.
//

import SwiftUI

struct EnterNameView: View {
    @EnvironmentObject private var session: SessionStore
    @Environment(\.dismiss) private var dismiss
    @State private var displayName = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Your Name", text: $displayName)
                        .textContentType(.name)
                        .textInputAutocapitalization(.words)
                } footer: {
                    Text("This name will appear on the leaderboard. No email or password required.")
                }
                
                if let errorMessage = session.errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }
                }
                
                Section {
                    Button {
                        Task { await session
                            .signInAnonymously(user_name: displayName)}
                    } label : {
                        if session.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("Start")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(session.isLoading || displayName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .navigationTitle("What's your name?")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {dismiss()}
                }
            }
            .onChange(of: session.currentUser) { newValue in
                if newValue != nil {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    EnterNameView()
        .environmentObject(SessionStore(auth: MockAuthService()))
}
