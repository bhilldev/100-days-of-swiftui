//
//  NamesToFacesAppApp.swift
//  NamesToFacesApp
//
//  Created by Brandon Hill on 8/19/26.
//

import SwiftUI
import SwiftData

@main
struct NamesToFacesAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Person.self)
    }
}
