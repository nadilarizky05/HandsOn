//
//  TopicListViewModel.swift
//  HandsOn
//
//  Created by Nadila Rizky Amelia on 15/09/26.
//

import Foundation
import Combine

@MainActor
final class TopicListViewModel: ObservableObject {
    @Published var topics: [Topic] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let api:APIServicing
    
    init(api: APIServicing = AppEnvironment.shared.api) {
        self.api = api
    }
    
    func loadTopics() async {
        isLoading = true
        errorMessage = nil
        do {
            print("🔄 Loading topics...")
            let startTime = Date()
            topics = try await api.fetchTopics()
            let duration = Date().timeIntervalSince(startTime)
            print("✅ Topics loaded in \(String(format: "%.2f", duration))s")
        } catch {
            print("❌ Error loading topics: \(error)")
            errorMessage = (error as? ErrorMessage)?.errorDescription ?? error.localizedDescription
        }
        isLoading = false
    }
}
