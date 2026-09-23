//
//  Resort.swift
//  SnowSeeker
//
//  Created by Brandon Hill on 9/23/26.
//

import Foundation

struct Resort: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let country: String
    let description: String
    let imageCredit: String
    let price: Int
    let size: Int
    let snowDepth: Int
    let elevation: Int
    let runs: Int
    let facilities: [String]

    // ADD THIS SAMPLE DATA FOR PREVIEWS:
    static let allResorts: [Resort] = Bundle.main.decode("resorts.json")
    static let example = allResorts[0]
}
