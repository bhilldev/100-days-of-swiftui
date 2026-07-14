//
//  ContentView.swift
//  HabitTracker
//
//  Created by Brandon Hill on 7/14/26.
//

import SwiftUI
import Observation

struct Activity: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var description: String
    var completionCount = 0
}

@Observable
class Activities {
    private static let saveKey = "SavedActivities"

    var items: [Activity] {
        didSet {
            save()
        }
    }

    init() {
        guard let data = UserDefaults.standard.data(forKey: Self.saveKey),
              let savedItems = try? JSONDecoder().decode([Activity].self, from: data) else {
            items = []
            return
        }

        items = savedItems
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        UserDefaults.standard.set(data, forKey: Self.saveKey)
    }
}

struct ContentView: View {
    @State private var activities = Activities()
    @State private var selectedActivity: Activity?
    var body: some View {
        NavigationStack {
            List {
                ForEach(activities.items) { activity in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(activity.title)
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedActivity = activity
                        }

                        Button {
                            if let index = activities.items.firstIndex(
                                where: { $0.id == activity.id }
                            ) {
                                activities.items[index].completionCount += 1
                            }
                        } label: {
                            Label(
                                "\(activity.completionCount)",
                                systemImage: "plus.circle"
                            )
                        }
                        .buttonStyle(.borderless)
                    }
                }
                .onDelete { offsets in
                        activities.items.remove(atOffsets: offsets)
                    }
            }
            .navigationTitle("Habit Tracker")
            .toolbar {
                NavigationLink {
                    AddActivity(activities: activities)
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
            
        }
        .sheet(item: $selectedActivity) { activity in
            DetailsView(activity: activity, activities: activities)
                .presentationDetents([.medium, .large])
        }
    }
}
#Preview {
    ContentView()
}
