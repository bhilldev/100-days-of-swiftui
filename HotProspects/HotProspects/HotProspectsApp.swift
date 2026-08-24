//
//  HotProspectsApp.swift
//  HotProspects
//
//  Created by Brandon Hill on 8/21/26.
//

import SwiftUI
import SwiftData

@main
struct HotProspectsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Prospect.self)
    }
}
