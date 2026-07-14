//
//  SwiftUIView.swift
//  HabitTracker
//
//  Created by Brandon Hill on 7/14/26.
//

import SwiftUI

struct AddActivity: View {
    @Environment(\.dismiss) private var dismiss

    var activities: Activities
    @State private var title = ""
    @State private var description = ""
    
    var body: some View {
        Form {
            Section("Activity") {
                TextField("Title", text: $title)
                TextField("Description", text: $description, axis: .vertical)
                    .lineLimit(3...6)
            }
        }
        .navigationTitle("New Activity")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    let activity = Activity(
                        title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                        description: description.trimmingCharacters(in: .whitespacesAndNewlines)
                    )

                    activities.items.append(activity)
                    dismiss()
                }
                .disabled(
                    title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                    description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                )
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddActivity(activities: Activities())
    }
}
