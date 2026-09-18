//
//  ErrorMessage.swift
//  HandsOn
//
//  Created by Nadila Rizky Amelia on 14/09/26.
//

import Foundation

enum ErrorMessage: Codable, LocalizedError, Equatable {
    case notFound
    case unauthorized
    case server(Int)
    case network(String)
    case decodingFailed
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .notFound:
            return "The data you’re looking for is not available yet."
        case .unauthorized:
            return "Your session has expired. Please log in again"
        case .server(let code):
            return "The server is experiencing an issue (code \(code)). Please try again later."
        case .network(let message):
            return "Connection issue: \(message)"
        case .decodingFailed:
            return "Failed to read data from the server. Please try again"
        case .unknown:
            return "An unknown error occurred."
        }
    }
}
