//
//  CardView.swift
//  Flashzilla
//
//  Created by Brandon Hill on 9/3/26.
//

import SwiftUI

// Custom ViewModifier to handle background color based on drag offset
struct CardBackgroundModifier: ViewModifier {
    let offset: CGSize

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(
                        offset.width == 0
                            ? .clear
                            : (offset.width > 0 ? .green : .red)
                    )
            )
    }
}

extension View {
    func cardBackground(for offset: CGSize) -> some View {
        self.modifier(CardBackgroundModifier(offset: offset))
    }
}

struct CardView: View {
    let card: Card
    var removal: ((_ reinsert: Bool) -> Void)? = nil
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled

    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    accessibilityDifferentiateWithoutColor
                        ? .white
                        : .white
                            .opacity(1 - Double(abs(offset.width / 50)))
                )
                .background(
                    accessibilityDifferentiateWithoutColor
                        ? nil
                        : Color.clear.cardBackground(for: offset)
                )
                .shadow(radius: 10)

            VStack {
                if accessibilityVoiceOverEnabled {
                    Text(isShowingAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                } else {
                    Text(card.prompt)
                        .font(.largeTitle)
                        .foregroundStyle(.black)

                    if isShowingAnswer {
                        Text(card.answer)
                            .font(.title)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(offset.width / 5.0))
        .offset(x: offset.width * 5)
        .opacity(2 - Double(abs(offset.width / 50)))
        .accessibilityAddTraits(.isButton)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded { _ in
                    if abs(offset.width) > 100 {
                        if offset.width < 0 {
                            // Swiped left (wrong answer) -> re-insert card
                            removal?(true)
                        } else {
                            // Swiped right (correct answer) -> remove permanently
                            removal?(false)
                        }
                    } else {
                        offset = .zero
                    }
                }
        )
        .onTapGesture {
            isShowingAnswer.toggle()
        }
        .animation(.bouncy, value: offset)
    }
}

#Preview {
    CardView(card: .example)
}
