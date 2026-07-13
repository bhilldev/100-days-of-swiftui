//
//  Astronaut.swift
//  Moonshot
//
//  Created by Brandon Hill on 7/7/26.
//

import Foundation

// Navigation values must be Hashable so SwiftUI can store them in its navigation path.
struct Astronaut: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let description: String
}
