//
//  Person.swift
//  NamesToFacesApp
//
//  Created by Brandon Hill on 8/19/26.
//

import Foundation
import SwiftData

@Model
final class Person {
    var id: UUID
    var name: String
    @Attribute(.externalStorage) var photoData: Data?

    init(name: String, photoData: Data?) {
        self.id = UUID()
        self.name = name
        self.photoData = photoData
    }
}
