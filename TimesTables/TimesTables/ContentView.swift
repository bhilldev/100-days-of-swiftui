//
//  ContentView.swift
//  TimesTables
//
//  Created by Brandon Hill on 7/2/26.
//


import SwiftUI

struct ContentView: View {
    @State private var userAnswer = ""
    @State private var table = 5
    @State private var multiplier = Int.random(in: 1...12)

    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    @State private var score = 0
    @State private var questionCount = 0

    let maxQuestions = 10

    var product: Int {
        table * multiplier
    }

    var body: some View {
        VStack(spacing: 20) {

            Stepper("Table: \(table)", value: $table, in: 2...12)

            Text("\(table) × \(multiplier)")
                .font(.largeTitle)

            TextField("Enter your answer", text: $userAnswer)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)

            Button("Check Answer") {
                checkAnswer()
            }
            .buttonStyle(.borderedProminent)

            Text("Score: \(score)")
            Text("Question \(questionCount)/\(maxQuestions)")
        }
        .padding()
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }

    func checkAnswer() {
        let answer = Int(userAnswer) ?? 0
        questionCount += 1

        if answer == product {
            score += 1
            alertTitle = "Correct!"
            alertMessage = "Nice work 👍"
        } else {
            alertTitle = "Wrong"
            alertMessage = "Correct answer was \(product)"
        }

        userAnswer = ""

        if questionCount >= maxQuestions {
            endRound()
        } else {
            nextQuestion()
        }

        showingAlert = true
    }

    func nextQuestion() {
        multiplier = Int.random(in: 1...12)
    }

    func endRound() {
        alertTitle = "Round Complete"
        alertMessage = "Final score: \(score)/\(maxQuestions)"

        score = 0
        questionCount = 0
        nextQuestion()
    }
}

#Preview {
    ContentView()
}
