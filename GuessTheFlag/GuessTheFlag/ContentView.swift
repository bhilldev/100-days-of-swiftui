//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Brandon Hill on 6/21/26.
//

import SwiftUI

struct ContentView: View {
    @State private var showingAlert = false
    
    var body: some View {
        Button("Show Alert") {
            showingAlert = true
        }
        .alert("Important message", isPresented: $showingAlert) {
            Button("OK") { }
        }
    }
}

#Preview {
    ContentView()
}
