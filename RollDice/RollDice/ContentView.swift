//
//  ContentView.swift
//  RollDice
//
//  Created by Brandon Hill on 9/18/26.
//

import SwiftUI

struct ContentView: View {
    @State private var die1 = 1
    @State private var die2 = 2

    var body: some View {
        ZStack {
            // Billiard Green Background
            Color(red: 0.05, green: 0.35, blue: 0.15)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Dice Row
                HStack(spacing: 20) {
                    Text("\(die1)")
                        .font(.system(size: 70, weight: .bold))
                        .foregroundColor(.black)
                        .frame(width: 140, height: 140)
                        .background(Color.white)
                        .cornerRadius(24)
                    
                    Text("\(die2)")
                        .font(.system(size: 70, weight: .bold))
                        .foregroundColor(.black)
                        .frame(width: 140, height: 140)
                        .background(Color.white)
                        .cornerRadius(24)
                }
                
                Spacer()
                
                // Roll Button
                Button(action: rollDice) {
                    Text("Roll Dice")
                        .font(.body.weight(.medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(20)
                }
                .padding(.bottom, 20)
            }
        }
    }

    private func rollDice() {
        // Add your rolling logic here!
    }
}

#Preview {
    ContentView()
}
