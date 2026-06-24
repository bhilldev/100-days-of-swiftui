//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Brandon Hill on 6/24/26.
//

import SwiftUI

enum Move: CaseIterable, Hashable {
    case rock, paper, scissors
    
    var symbol: String {
        switch self {
        case .rock:     return "circle.fill"
        case .paper:    return "hand.raised"
        case .scissors: return "scissors"
        }
    }
}

struct ContentView: View {
    
    @State private var score: Int = 0
    @State private var turns: Int = 0
    @State private var gameOver: Bool = false
    @State private var currentMove = Move.allCases.randomElement()!
    @State private var shouldWin: Bool = Bool.random()
    
    var body: some View {
        VStack {
            Image(systemName: currentMove.symbol)
                .font(.system(size: 60))
            Text(shouldWin ? "Pick a winning move" : "Pick a losing move")
                .padding()
            HStack {
                ForEach(Move.allCases, id: \.self) { move in
                    Button {
                        playerChose(move)
                    } label: {
                        Image(systemName: move.symbol)
                            .font(.largeTitle)
                            .padding()
                    }
                }
            }
            Text("Score: \(score)")
                .padding(16)
        }
        .alert("Game Over", isPresented: $gameOver) {
            Button("Play Again") {
                score = 0
                turns = 0
                currentMove = Move.allCases.randomElement()!
                shouldWin = Bool.random()
            }
        } message: {
            Text("You scored \(score) out of 10!")
        }
    }
    
    func playerChose(_ move: Move) {
        let playerWon = (move == .rock && currentMove == .scissors) ||
                        (move == .scissors && currentMove == .paper) ||
                        (move == .paper && currentMove == .rock)
        
        if (shouldWin && playerWon) || (!shouldWin && !playerWon) {
            score += 1
        }
        
        turns += 1
        if turns == 10 {
            gameOver = true
        } else {
            currentMove = Move.allCases.randomElement() ?? .rock
            shouldWin = Bool.random()
        }
    }
}

#Preview {
    ContentView()
}
