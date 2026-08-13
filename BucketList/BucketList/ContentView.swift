//
//  ContentView.swift
//  BucketList
//
//  Created by Brandon Hill on 8/5/26.
//

import SwiftUI
import MapKit

// 1. Define an enum that conforms to Hashable
enum MapType: String, CaseIterable, Identifiable {
    case standard = "Standard"
    case hybrid = "Hybrid"
    
    var id: Self { self }
    
    // Map the enum case to MapKit's MapStyle
    var style: MapStyle {
        switch self {
        case .standard: return .standard
        case .hybrid: return .hybrid
        }
    }
}

struct ContentView: View {
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
    )
    
    @State private var viewModel = ViewModel()
    // 2. Track your enum type instead of MapStyle directly
    @State private var selectedMapType: MapType = .standard
    
    var body: some View {
        Group {
            if viewModel.isUnlocked {
                VStack {
                    // 3. Picker binds to the enum and tags enum cases
                    Picker("Map Style", selection: $selectedMapType) {
                        ForEach(MapType.allCases) { mapType in
                            Text(mapType.rawValue).tag(mapType)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    MapReader { proxy in
                        Map(initialPosition: startPosition) {
                            ForEach(viewModel.locations) { location in
                                Annotation(location.name, coordinate: location.coordinate) {
                                    Image(systemName: "star.circle")
                                        .resizable()
                                        .foregroundStyle(.red)
                                        .frame(width: 44, height: 44)
                                        .background(.white)
                                        .clipShape(.circle)
                                        .onLongPressGesture {
                                            viewModel.selectedPlace = location
                                        }
                                }
                            }
                        }
                        // 4. Pass the computed MapStyle to .mapStyle()
                        .mapStyle(selectedMapType.style)
                        .onTapGesture { position in
                            if let coordinate = proxy.convert(position, from: .local) {
                                viewModel.addLocation(at: coordinate)
                            }
                        }
                        .sheet(item: $viewModel.selectedPlace) { place in
                            EditView(location: place) { newLocation in
                                viewModel.update(location: newLocation)
                            }
                        }
                    }
                }
            } else {
                Button("Unlock Places") {
                    viewModel.authenticate()
                }
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.capsule)
            }
        }
        // 5. Alert modifier bound to the ViewModel's state
        .alert("Authentication Error", isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

#Preview {
    ContentView()
}
