//
//  File.swift
//  NamesToFacesApp
//
//  Created by Brandon Hill on 8/19/26.
//

import SwiftUI

struct DetailView: View {
    let person: Person

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let data = person.photoData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(radius: 5)
                } else {
                    ContentUnavailableView(
                        "No Image Available",
                        systemImage: "photo",
                        description: Text("No photo stored for this contact.")
                    )
                }
                
                Text(person.name)
                    .font(.largeTitle)
                    .bold()
            }
            .padding()
        }
        .navigationTitle(person.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
