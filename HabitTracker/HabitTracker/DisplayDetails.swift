//
//  SwiftUIView.swift
//  HabitTracker
//
//  Created by Brandon Hill on 7/14/26.
//

import SwiftUI

struct DetailsView: View {
    @Environment(\.dismiss) private var dismiss

    let activity: Activity
    var activities: Activities
    @State private var title: String
    @State private var description: String

    init(activity: Activity, activities: Activities) {
        self.activity = activity
        self.activities = activities
        _title = State(initialValue: activity.title)
        _description = State(initialValue: activity.description)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("Title", text: $title)
                }

                Section("Description") {
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }

                Section("Progress") {
                    LabeledContent(
                        "Times completed",
                        value: "\(activity.completionCount)"
                    )
                }
            }
            .navigationTitle(activity.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let newActivity = Activity(
                            id: activity.id,
                            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
                            completionCount: activity.completionCount
                        )

                        if let index = activities.items.firstIndex(of: activity) {
                            activities.items[index] = newActivity
                            dismiss()
                        }
                    }
                    .disabled(
                        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                        description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    )
                }
            }
        }
    }
}

#Preview {
    DetailsView(
        activity: Activity(
            title: "Read",
            description: "Read for at least 20 minutes.",
            completionCount: 3
        ),
        activities: Activities()
    )
}
