//
//  ContentView.swift
//  Flashzilla
//
//  Created by Brandon Hill on 8/31/26.
//

import SwiftUI
import Combine

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor

    var body: some View {
        HStack {
            if differentiateWithoutColor {
                Image(systemName: "checkmark.circle")
            }

            Text("Success")
        }
        .padding()
        .background(differentiateWithoutColor ? .black : .green)
        .foregroundStyle(.white)
        .clipShape(.capsule)
    }
}
#Preview {
    ContentView()
}
