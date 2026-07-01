//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Brandon Hill on 6/21/26.
//

import SwiftUI

struct FlagImage: View {
    var country: String
    
    var body: some View {
        Image(country)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    
    @State private var countries = [
        "Estonia", "France", "Germany", "Ireland", "Italy",
        "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"
    ].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    @State private var questionNumber = 0
    
    @State private var selectedFlag: Int? = nil
    
    @State private var animationAmount = 0.0
    
    @State private var showFinalScore = false
    
    let maxQuestion = 8
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .prominentTitle()
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedFlag = number
                            }
                            
                            withAnimation {
                                animationAmount += 360
                            }
                            
                            flagTapped(number)
                            
                        } label: {
                            FlagImage(country: countries[number])
                        }
                        .rotation3DEffect(
                            .degrees(selectedFlag == number ? animationAmount : 0),
                            axis: (x: 0, y: 1, z: 0)
                        )
                        
                        .scaleEffect(
                            selectedFlag == nil
                            ? 1.0
                            : (selectedFlag == number ? 1.0 : 0.3)
                        )
                        
                        .opacity(
                            selectedFlag == nil
                            ? 1.0
                            : (selectedFlag == number ? 1.0 : 0.3)
                        )
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(userScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(userScore)")
        }
        
        .alert("Game Over", isPresented: $showFinalScore) {
            Button("Play Again", action: resetGame)
        } message: {
            Text("Final score: \(userScore) / \(maxQuestion)")
        }
    }
    
    func flagTapped(_ number: Int) {
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 1
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
        }
        
        questionNumber += 1
        showingScore = true
    }
    
    func askQuestion() {
        
        selectedFlag = nil
        animationAmount = 0
        
        if questionNumber >= maxQuestion {
            showFinalScore = true
        } else {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
        }
    }
    
    func resetGame() {
        
        userScore = 0
        questionNumber = 0
        
        // CHANGED: also reset visual state when restarting game
        selectedFlag = nil
        animationAmount = 0
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ProminentTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundStyle(.blue)
    }
}

extension View {
    func prominentTitle() -> some View {
        modifier(ProminentTitle())
    }
}

#Preview {
    ContentView()
}
