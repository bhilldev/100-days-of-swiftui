//
//  ContentView.swift
//  LayoutAndGeometry
//
//  Created by Brandon Hill on 9/14/26.
//

import SwiftUI

struct ContentView: View {
    let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]

    var body: some View {
        GeometryReader { fullView in
            ScrollView(.vertical) {
                ForEach(0..<50) { index in
                    GeometryReader { proxy in
                        Text("Row #\(index)")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .background(Color(
                                hue: min(1.0, max(0.0, proxy.frame(in: .global).minY / fullView.size.height)),
                                saturation: 0.8,
                                brightness: 0.9
                            ))
                            .rotation3DEffect(.degrees(proxy.frame(in: .global).minY - fullView.size.height / 2) / 5, axis: (x: 0, y: 1, z: 0))
                            // 1. Scale Effect: Scales smoothly from 0.5 near top to 1.0 near bottom
                            .scaleEffect(max(0.5, min(1.0, 0.5 + (proxy.frame(in: .global).minY / fullView.size.height) / 2)))
                            // 2. Opacity: Fades out to 0 before entering the top safe area
                            .opacity(max(0, min(1.0, (proxy.frame(in: .global).minY - 50) / 200)))
                    }
                    .frame(height: 40)
                }
            }
        }
    }
}
#Preview {
    ContentView()
}
