//
//  iExpenseApp.swift
//  iExpense
//
//  Created by Brandon Hill on 7/3/26.
//

import SwiftUI
import SwiftData

@main
struct iExpenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ExpenseItem.self)
    }
}
