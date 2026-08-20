//
//  Person.swift
//  NamesToFacesApp
//
//  Created by Brandon Hill on 8/19/26.
//

import Foundation
import SwiftData
import CoreLocation // <--- 1. Add this import

@Model
final class Person {
    var id: UUID
    var name: String
    var photoData: Data?
    
    // CoreLocation storage properties
    var latitude: Double?
    var longitude: Double?
    
    // 2. Add this computed property to resolve the error:
    var coordinate: CLLocationCoordinate2D? {
        guard let latitude, let longitude else { return nil }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init(name: String, photoData: Data?, latitude: Double? = nil, longitude: Double? = nil) {
        self.id = UUID()
        self.name = name
        self.photoData = photoData
        self.latitude = latitude
        self.longitude = longitude
    }
}
