//
//  HandsOnApp.swift
//  HandsOn
//
//  Created by Nadila Rizky Amelia on 14/09/26.
//

import SwiftUI

@main
struct HandsOnApp: App {
    var body: some Scene {
        WindowGroup {
            TopicListView()
                .environmentObject(AppEnvironment.shared.session)
        }
    }
}
