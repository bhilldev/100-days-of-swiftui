//
//  GridLayout.swift
//  Moonshot
//
//  Created by Brandon Hill on 7/9/26.
//

import SwiftUI

struct GridLayout: View {
    let astronauts: [String: Astronaut]
    let missions: [Mission]

    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]

    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(missions) { mission in
                NavigationLink {
                    MissionView(mission: mission, astronauts: astronauts)
                } label: {
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
            GridLayout(astronauts: astronauts, missions: missions)
        }
        .background(.darkBackground)
        .preferredColorScheme(.dark)
    }
}
