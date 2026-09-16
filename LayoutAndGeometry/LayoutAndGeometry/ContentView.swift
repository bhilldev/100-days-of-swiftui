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
                            .background(
                                colorForPosition(
                                    proxy.frame(in: .global).minY,
                                    totalHeight: fullView.size.height
                                )
                            )
                            .rotation3DEffect(
                                .degrees(proxy.frame(in: .global).minY - fullView.size.height / 2) / 5,
                                axis: (x: 0, y: 1, z: 0)
                            )
                            .scaleEffect(max(0.5, min(1.0, 0.5 + (proxy.frame(in: .global).minY / fullView.size.height) / 2)))
                            .opacity(max(0, min(1.0, (proxy.frame(in: .global).minY - 50) / 200)))
                    }
                    .frame(height: 40)
                }
            }
        }
    }
    
    /// Calculates a smoothly blended Color from the array based on scroll position.
    func colorForPosition(_ minY: CGFloat, totalHeight: CGFloat) -> Color {
        // 1. Normalize position between 0.0 (top) and 1.0 (bottom)
        let progress = max(0.0, min(1.0, minY / totalHeight))
        
        // 2. Map progress across the indices of the array
        let arrayPosition = progress * CGFloat(colors.count - 1)
        
        // 3. Find lower and upper color indices
        let currentIndex = Int(arrayPosition)
        let nextIndex = min(currentIndex + 1, colors.count - 1)
        
        // 4. Get fractional remainder between the two indices (0.0 to 1.0)
        let fraction = arrayPosition - CGFloat(currentIndex)
        
        // 5. Blend from colors[currentIndex] to colors[nextIndex]
        return blend(from: colors[currentIndex], to: colors[nextIndex], fraction: fraction)
    }
    

    /// Linear interpolation helper for SwiftUI Colors
    func blend(from start: Color, to end: Color, fraction: CGFloat) -> Color {
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        
        // Extract RGBA components into local variables
        UIColor(start).getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        UIColor(end).getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        // Interpolate between the two colors based on the fraction
        let r = r1 + (r2 - r1) * fraction
        let g = g1 + (g2 - g1) * fraction
        let b = b1 + (b2 - b1) * fraction
        let a = a1 + (a2 - a1) * fraction
        
        return Color(red: Double(r), green: Double(g), blue: Double(b), opacity: Double(a))
    }
}
#Preview {
    ContentView()
}
