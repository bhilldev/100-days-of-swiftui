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

    @State private var questionsPerRound = 10

    var product: Int {
        table * multiplier
    }

    var body: some View {
        VStack(spacing: 20) {

            // Question
            Text("\(table) × \(multiplier)")
                .font(.largeTitle)
                .padding(.top)

            TextField("Enter your answer", text: $userAnswer)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            Button("Check Answer") {
                checkAnswer()
            }
            .buttonStyle(.borderedProminent)

            Text("Score: \(score)")
            Text("Question \(questionCount)/\(questionsPerRound)")

            Spacer()

            // Settings section (clean grouped look)
            VStack(spacing: 12) {

                Divider()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Settings")
                        .font(.headline)

                    Stepper("Times Table: \(table)", value: $table, in: 2...12)

                    Stepper("Questions per round: \(questionsPerRound)", value: $questionsPerRound, in: 5...20)
                }
                .padding(.horizontal)
            }
            .padding(.bottom)
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

        if questionCount >= questionsPerRound {
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
        alertMessage = "Final score: \(score)/\(questionsPerRound)"

        score = 0
        questionCount = 0
        nextQuestion()
    }
}

#Preview {
    ContentView()
}
