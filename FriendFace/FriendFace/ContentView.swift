//
//  ContentView.swift
//  FriendFace
//
//  Created by Brandon Hill on 7/27/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \User.name) private var users: [User]
    
    var body: some View {
        NavigationStack {
            List(users) { user in
                NavigationLink {
                    DetailView(user: user)
                } label: {
                    VStack(alignment: .leading) {
                        Text(user.name)
                            .font(.headline)

                        Text(user.isActive ? "Active" : "Inactive")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .task {
                await loadData()
            }
        }
    }
    func loadData() async {
        guard users.isEmpty else {
            print("Data already retrieved.")
            return
        }
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
            
            let downloadedUsers = try decoder.decode(
                [DownloadedUser].self,
                from: data
            )

            for downloadedUser in downloadedUsers {
                var storedFriends = [Friend]()

                for downloadedFriend in downloadedUser.friends {
                    let storedFriend = Friend(
                        id: downloadedFriend.id,
                        name: downloadedFriend.name
                    )

                    storedFriends.append(storedFriend)
                }

                let storedUser = User(
                    id: downloadedUser.id,
                    isActive: downloadedUser.isActive,
                    name: downloadedUser.name,
                    age: downloadedUser.age,
                    company: downloadedUser.company,
                    email: downloadedUser.email,
                    address: downloadedUser.address,
                    about: downloadedUser.about,
                    registered: downloadedUser.registered,
                    tags: downloadedUser.tags,
                    friends: storedFriends
                )

                modelContext.insert(storedUser)
            }

            try modelContext.save()
        } catch {
            print("Failed to load users: \(error.localizedDescription)")
        }
    }
}

struct DetailView: View {
    let user: User

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text(user.name)
                        .font(.title)
                        .fontWeight(.bold)

                    Text(user.isActive ? "Active" : "Inactive")
                        .foregroundStyle(
                            user.isActive ? .green : .secondary
                        )
                }
                .padding(.vertical, 4)
            }

            Section("User Information") {
                DetailRow(title: "Age", value: String(user.age))
                DetailRow(title: "Company", value: user.company)
                DetailRow(title: "Email", value: user.email)
                DetailRow(title: "Address", value: user.address)

                DetailRow(
                    title: "Registered",
                    value: user.registered.formatted(
                        date: .long,
                        time: .omitted
                    )
                )
            }

            Section("About") {
                Text(user.about)
            }

            Section("Tags") {
                ForEach(user.tags, id: \.self) { tag in
                    Text(tag)
                }
            }

            Section("Friends") {
                ForEach(user.friends) { friend in
                    Text(friend.name)
                }
            }
        }
        .navigationTitle(user.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [User.self, Friend.self], inMemory: true)
}
