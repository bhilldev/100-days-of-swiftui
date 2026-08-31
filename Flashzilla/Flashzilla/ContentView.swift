//
//  ContentView.swift
//  Flashzilla
//
//  Created by Brandon Hill on 8/31/26.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        VStack {
            Text("Hello")
            Spacer().frame(height: 100)
            Text("World")
        }
        .contentShape(.rect)
        .onTapGesture {
            print("VStack tapped!")
        }
    }
}

#Preview {
    ContentView()
}
