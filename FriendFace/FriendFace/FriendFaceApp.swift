//
//  FriendFaceApp.swift
//  FriendFace
//
//  Created by Brandon Hill on 7/27/26.
//

import SwiftUI
import SwiftData

@main
struct FriendFaceApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [User.self, Friend.self])
    }
}
