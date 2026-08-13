//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Brandon Hill on 8/12/26.
//

import Foundation
import Observation
import CoreLocation
import LocalAuthentication

extension ContentView {
    @MainActor
    @Observable
    class ViewModel {
        let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")
        
        private(set) var locations: [Location]
        var selectedPlace: Location?
        var isUnlocked = false
        
        // 1. Add Alert State Properties
        var showAlert = false
        var alertMessage = ""
        
        func addLocation(at point: CLLocationCoordinate2D) {
            let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: point.latitude, longitude: point.longitude)
            locations.append(newLocation)
            save()
        }
        
        func update(location: Location) {
            guard let selectedPlace else { return }

            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
                save()
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?

            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places."

                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    Task { @MainActor in
                        if success {
                            self.isUnlocked = true
                        } else {
                            // 2. Set alert message on authentication failure
                            self.alertMessage = authenticationError?.localizedDescription ?? "Authentication failed."
                            self.showAlert = true
                        }
                    }
                }
            } else {
                // 3. Set alert message if hardware is unavailable/unconfigured
                self.alertMessage = error?.localizedDescription ?? "Biometrics are unavailable on this device."
                self.showAlert = true
            }
        }
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
    }
}
