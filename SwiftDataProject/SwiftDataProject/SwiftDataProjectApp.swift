//
//  SwiftDataProjectApp.swift
//  SwiftDataProject
//
//  Created by Brandon Hill on 7/24/26.
//

import SwiftUI
import SwiftData

@main
struct SwiftDataProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}
