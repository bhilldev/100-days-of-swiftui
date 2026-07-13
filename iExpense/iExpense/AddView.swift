//
//  AddView.swift
//  iExpense
//
//  Created by Brandon Hill on 7/4/26.
//

import SwiftUI

struct AddView: View {
    @State private var name = "New expense"
    @State private var type = "Personal"
    @State private var amount = 0.0
    @Environment(\.dismiss) private var dismiss
    @Environment(\.locale) private var locale
    
    var expenses: Expenses
    
    let types = ["Business", "Personal"]
    
    var body: some View {
        Form {
            Picker("Type", selection: $type) {
                ForEach(types, id: \.self) {
                    Text($0)
                }
            }
            TextField(
                "Amount",
                value: $amount,
                format: .currency(code: locale.currency?.identifier ?? "USD")
            )
            .keyboardType(.decimalPad)
        }
        .navigationTitle($name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            Button("Save") {
                let item = ExpenseItem(name: name, type: type, amount: amount)
                expenses.items.append(item)
                dismiss()
            }
        }
    }
}
#Preview {
    NavigationStack {
        AddView(expenses: Expenses())
    }
}
