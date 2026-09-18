//
//  User.swift
//  HandsOn
//
//  Created by Nadila Rizky Amelia on 14/09/26.
//

import Foundation

struct User: Codable, Identifiable, Hashable {
    let id: String
    let userName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userName = "user_name"
    }
}
