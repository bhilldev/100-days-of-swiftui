//
//  ListLayout.swift
//  Moonshot
//
//  Created by Brandon Hill on 7/9/26.
//

import SwiftUI

struct ListLayout: View {
    let astronauts: [String: Astronaut]
    let missions: [Mission]

    var body: some View {
        LazyVStack {
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
            ListLayout(astronauts: astronauts, missions: missions)
        }
        .background(.darkBackground)
        .preferredColorScheme(.dark)
    }
}
