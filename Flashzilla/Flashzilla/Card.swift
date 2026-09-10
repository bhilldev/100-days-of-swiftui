//
//  Card.swift
//  Flashzilla
//
//  Created by Brandon Hill on 9/3/26.
//

import Foundation

struct Card: Codable, Identifiable, Equatable {
    var id = UUID()
    var prompt: String
    var answer: String

    static let example = Card(prompt: "Who played the Tenth Doctor in Doctor Who?", answer: "David Tennant")
}
