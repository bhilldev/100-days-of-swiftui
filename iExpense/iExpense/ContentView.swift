//
//  ContentView.swift
//  iExpense
//
//  Created by Brandon Hill on 7/3/26.
//

import SwiftUI
import SwiftData

// MARK: - Model

@Model
class ExpenseItem {
    var name: String
    var type: String
    var amount: Double
    init(name: String, type: String, amount: Double) {
        self.name = name
        self.type = type
        self.amount = amount
    }
}

// MARK: - Styling

extension ExpenseItem {

    var amountColor: Color {
        if amount < 10 {
            .green
        } else if amount < 100 {
            .primary
        } else {
            .red
        }
    }

    var amountWeight: Font.Weight {
        if amount < 10 {
            .regular
        } else if amount < 100 {
            .semibold
        } else {
            .bold
        }
    }
}


// MARK: - View

struct ContentView: View {
    @Query private var items: [ExpenseItem]

    @Environment(\.modelContext) private var modelContext
    @Environment(\.locale) private var locale

    @State private var sortOrder = [
        SortDescriptor(\ExpenseItem.name)
    ]

    @State private var selectedFilter = "All"

    let filters = ["All", "Business", "Personal"]

    var body: some View {
        NavigationStack {
            List {
                ForEach(groupedExpenses.keys.sorted(), id: \.self) { key in
                    Section(key) {
                        ForEach(groupedExpenses[key] ?? []) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)

                                    Text(item.type)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                Text(
                                    item.amount,
                                    format: .currency(
                                        code: locale.currency?.identifier ?? "USD"
                                    )
                                )
                                .foregroundStyle(item.amountColor)
                                .fontWeight(item.amountWeight)
                            }
                        }
                        .onDelete { offsets in
                            deleteItems(type: key, offsets: offsets)
                        }
                    }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Menu("Filter", systemImage: "line.3.horizontal.decrease.circle") {
                    Picker("Filter", selection: $selectedFilter) {
                        ForEach(filters, id: \.self) { filter in
                            Text(filter)
                                .tag(filter)
                        }
                    }
                }

                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    Button("Name") {
                        sortOrder = [
                            SortDescriptor(\ExpenseItem.name)
                        ]
                    }

                    Button("Amount") {
                        sortOrder = [
                            SortDescriptor(\ExpenseItem.amount)
                        ]
                    }
                }

                NavigationLink {
                    AddView()
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
        }
    }

    var groupedExpenses: [String: [ExpenseItem]] {
        let filteredItems = selectedFilter == "All"
            ? items
            : items.filter { $0.type == selectedFilter }

        return Dictionary(
            grouping: filteredItems.sorted(using: sortOrder),
            by: \.type
        )
    }

    func deleteItems(type: String, offsets: IndexSet) {
        let sectionItems = groupedExpenses[type] ?? []

        for index in offsets {
            modelContext.delete(sectionItems[index])
        }
    }
}

#Preview {
    let container: ModelContainer = {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(
            for: ExpenseItem.self,
            configurations: configuration
        )

        container.mainContext.insert(
            ExpenseItem(name: "Coffee", type: "Personal", amount: 4.50)
        )
        container.mainContext.insert(
            ExpenseItem(name: "Conference ticket", type: "Business", amount: 299)
        )
        container.mainContext.insert(
            ExpenseItem(name: "Groceries", type: "Personal", amount: 72.35)
        )
        container.mainContext.insert(
            ExpenseItem(name: "Office supplies", type: "Business", amount: 24.99)
        )

        return container
    }()

    ContentView()
        .modelContainer(container)
}
