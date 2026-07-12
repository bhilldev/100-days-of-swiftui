//
//  ContentView.swift
//  Navigation
//
//  Created by Brandon Hill on 7/10/26.
//

import SwiftUI
import Observation


struct ContentView: View {
    @State private var title = "SwiftUI"

    var body: some View {
        NavigationStack {
            Text("Hello, world!")
                .navigationTitle($title)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
