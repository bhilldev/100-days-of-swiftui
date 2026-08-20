//
//  File.swift
//  NamesToFacesApp
//
//  Created by Brandon Hill on 8/19/26.
//

import SwiftUI
import MapKit

struct DetailView: View {
    let person: Person
    
    // Position camera over saved location
    @State private var position: MapCameraPosition

    init(person: Person) {
        self.person = person
        
        if let coordinate = person.coordinate {
            let region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            _position = State(initialValue: .region(region))
        } else {
            _position = State(initialValue: .automatic)
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let data = person.photoData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(radius: 5)
                }

                Text(person.name)
                    .font(.largeTitle)
                    .bold()

                // Display map pin if location was recorded
                if let coordinate = person.coordinate {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Where You Met")
                            .font(.headline)
                        
                        Map(position: $position) {
                            Annotation(person.name, coordinate: coordinate) {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.red)
                            }
                        }
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            .padding()
        }
        .navigationTitle(person.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
