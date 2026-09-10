//
//  ContentView.swift
//  Flashzilla
//
//  Created by Brandon Hill on 8/31/26.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var cards = [Card]()
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled
    @State private var isActive = true
    @State private var showingEditScreen = false


    var body: some View {
        ZStack {
            Image(decorative: "background")
                .resizable()
                .ignoresSafeArea()

            VStack {
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(.capsule)
                ZStack {
                    ForEach(cards) { card in
                        let index = index(for: card)

                        CardView(card: card) { reinsert in
                            withAnimation {
                                removeCard(at: index, reinsert: reinsert)
                            }
                        }
                        .stacked(at: index, in: cards.count)
                        .allowsHitTesting(index == cards.count - 1)
                        .accessibilityHidden(index < cards.count - 1)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)
                if cards.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundStyle(.black)
                        .clipShape(.capsule)
                }
                
            }
            .onReceive(timer) { time in
                guard isActive else { return }

                if timeRemaining > 0 {
                    timeRemaining -= 1
                }
            }
            .onChange(of: scenePhase) {
                if scenePhase == .active {
                    if cards.isEmpty == false {
                        isActive = true
                    }
                } else {
                    isActive = false
                }
            }
            VStack {
                HStack {
                    Spacer()

                    Button {
                        showingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(.circle)
                    }
                }

                Spacer()
            }
            .foregroundStyle(.white)
            .font(.largeTitle)
            .padding()
            if accessibilityDifferentiateWithoutColor || accessibilityVoiceOverEnabled {
                VStack {
                    Spacer()

                    HStack {
                        Button {
                            withAnimation {
                                removeCard(at: cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect.")

                        Spacer()

                        Button {
                            withAnimation {
                                removeCard(at: cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as being correct.")
                    }
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards, content: EditCards.init)
        .onAppear(perform: resetCards)
    }

    func removeCard(at index: Int, reinsert: Bool = false) {
        guard index >= 0 && index < cards.count else { return }

        let card = cards.remove(at: index)

        if reinsert {
            // Move the missed card to the bottom of the deck (index 0)
            cards.insert(card, at: 0)
        }

        if cards.isEmpty {
            isActive = false
        }
    }
    func index(for card: Card) -> Int {
        cards.firstIndex(where: { $0.id == card.id }) ?? 0
    }
    func resetCards() {
        timeRemaining = 100
        isActive = true
        loadData()
    }
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                cards = decoded
            }
        }
    }
    
}

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(y: offset * 10)
    }
}

#Preview {
    ContentView()
}
