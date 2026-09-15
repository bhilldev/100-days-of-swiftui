//
//  ContentView.swift
//  LayoutAndGeometry
//
//  Created by Brandon Hill on 9/14/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { proxy in
            Image(.example)
                .resizable()
                .scaledToFit()
                .frame(width: proxy.size.width * 0.8)
                .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
}

#Preview {
    ContentView()
}
