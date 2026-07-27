//
//  ContentView.swift
//  FriendFace
//
//  Created by Brandon Hill on 7/27/26.
//

import SwiftUI

struct ContentView: View {
    @State private var users = [User]()
    
    var body: some View {
        List(users) { user in
            Text(user.name)
        }
        .task {
            await loadData()
        }
    }
    func loadData() async {
        guard let url = URL(
            string: "https://www.hackingwithswift.com/samples/friendface.json"
        ) else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            users = try decoder.decode([User].self, from: data)
        } catch {
            print("Failed to load users: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView()
}
