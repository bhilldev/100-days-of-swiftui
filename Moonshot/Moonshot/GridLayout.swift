//
//  GridLayout.swift
//  Moonshot
//
//  Created by Brandon Hill on 7/9/26.
//

import SwiftUI

struct GridLayout: View {
    let missions: [Mission]

    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]

    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(missions) { mission in
                // Pass the selection as data; ContentView decides which screen to show.
                NavigationLink(value: mission) {
                    MissionCardView(mission: mission)
                }
            }
        }
        .padding([.horizontal, .bottom])
    }
}

#Preview {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")

    return NavigationStack {
        ScrollView {
            GridLayout(missions: missions)
        }
        // This preview has its own NavigationStack, so it needs its own destination rule.
        .navigationDestination(for: Mission.self) { mission in
            MissionView(mission: mission, astronauts: astronauts)
        }
        .background(.darkBackground)
        .preferredColorScheme(.dark)
    }
}
