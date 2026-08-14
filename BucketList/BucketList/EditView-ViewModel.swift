//
//  EditView-ViewModel.swift
//  BucketList
//
//  Created by Brandon Hill on 8/14/26.
//

import SwiftUI

extension EditView {
    enum LoadingState {
        case loading, loaded, failed
    }

    @Observable
    class ViewModel {
        var loadingState = LoadingState.loading
        var pages = [Page]()
        
        var name: String
        var description: String
        
        private let location: Location
        private let onSave: (Location) -> Void

        init(location: Location, onSave: @escaping (Location) -> Void) {
            self.location = location
            self.onSave = onSave
            self.name = location.name
            self.description = location.description
        }

        func fetchNearbyPlaces() async {
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"

            guard let url = URL(string: urlString) else {
                print("Bad URL: \(urlString)")
                loadingState = .failed
                return
            }

            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let items = try JSONDecoder().decode(Result.self, from: data)
                
                pages = items.query.pages.values.sorted()
                loadingState = .loaded
            } catch {
                loadingState = .failed
            }
        }

        func save() {
            var newLocation = location
            newLocation.id = UUID()
            newLocation.name = name
            newLocation.description = description

            onSave(newLocation)
        }
    }
}
