//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Brandon Hill on 9/21/26.
//

import SwiftUI

struct User: Identifiable {
    var id = "Taylor Swift"
}

struct ContentView: View {
    @State private var selectedUser: User? = nil
    @State private var isShowingUser = false
    
    var body: some View {
        Button("Tap Me") {
            selectedUser = User()
        }
        .sheet(item: $selectedUser) { user in
            // Attach presentationDetents HERE to the sheet's content view
            Text(user.id)
                .presentationDetents([.medium, .large])
        }
        .alert("Welcome", isPresented: $isShowingUser, presenting: selectedUser) { user in
            Button(user.id) { }
        }
    }
}

#Preview {
    ContentView()
}
