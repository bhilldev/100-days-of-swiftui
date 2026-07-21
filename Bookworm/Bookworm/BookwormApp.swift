//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Brandon Hill on 7/20/26.
//

import SwiftUI
import SwiftData

@main
struct BookwormApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self)
    }
}
