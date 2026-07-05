//
//  ContentView.swift
//  iExpense
//
//  Created by Brandon Hill on 7/3/26.
//

import SwiftUI

// MARK: - Model

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
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

// MARK: - Store

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }

    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decoded = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decoded
                return
            }
        }

        items = []
    }
}

// MARK: - View

struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    @Environment(\.locale) private var locale

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
                                    format: .currency(code: locale.currency?.identifier ?? "USD")
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
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }
            }
        }
    }

    // MARK: - Grouping

    var groupedExpenses: [String: [ExpenseItem]] {
        Dictionary(grouping: expenses.items, by: { $0.type })
    }

    // MARK: - Delete safely

    func deleteItems(type: String, offsets: IndexSet) {
        let items = groupedExpenses[type] ?? []

        for index in offsets {
            let item = items[index]

            if let originalIndex = expenses.items.firstIndex(where: { $0.id == item.id }) {
                expenses.items.remove(at: originalIndex)
            }
        }
    }
}

#Preview {
    ContentView()
}


