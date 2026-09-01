//
//  ContentView.swift
//  Flashzilla
//
//  Created by Brandon Hill on 8/31/26.
//

import SwiftUI
import Combine

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        Text("Hello, world!")
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .active {
                    print("Active")
                } else if newPhase == .inactive {
                    print("Inactive")
                } else if newPhase == .background {
                    print("Background")
                }
            }
    }
}
#Preview {
    ContentView()
}
