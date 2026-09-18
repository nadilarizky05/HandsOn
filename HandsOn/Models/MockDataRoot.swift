//
//  MockDataRoot.swift
//  HandsOn
//
//  Created by Nadila Rizky Amelia on 15/09/26.
//

import Foundation

//BUAT MENTERJEMAHKAN FILE mock_data_json
struct MockDataRoot: Codable {
    let topics: [Topic]
    let question_sets: [String: QuestionSet]
}
