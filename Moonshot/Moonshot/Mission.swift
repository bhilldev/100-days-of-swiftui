//
//  Mission.swift
//  Moonshot
//
//  Created by Brandon Hill on 7/7/26.
//

import Foundation

struct CrewRole: Codable {
    let name: String
    let role: String
}

// Navigation values must be Hashable so SwiftUI can store them in its navigation path.
struct Mission: Codable, Identifiable, Hashable {
    
    // Mission can synthesize Hashable only when every stored property is also Hashable.
    struct CrewRole: Codable, Hashable {
        let name: String
        let role: String
    }
    
    let id: Int
    let launchDate: Date?
    let crew: [CrewRole]
    let description: String
    
    var formattedLaunchDate: String {
        launchDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
    }
    
    var displayName: String {
        "Apollo \(id)"
    }

    var image: String {
        "apollo\(id)"
    }
}
