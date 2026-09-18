//
//  Topic.swift
//  HandsOn
//
//  Created by Nadila Rizky Amelia on 14/09/26.
//

import Foundation

//Topic = Basic Swift, Advance Swift
struct Topic: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let subtopics: [Subtopic]?
}
