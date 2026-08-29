//
//  Prospect.swift
//  HotProspects
//
//  Created by Brandon Hill on 8/24/26.
//

import Foundation
import SwiftData

@Model
class Prospect {
    var name: String
    var emailAddress: String
    var isContacted: Bool
    var createdAt: Date
    init(name: String, emailAddress: String, isContacted: Bool, createdAt: Date = Date()) {
        self.name = name
        self.emailAddress = emailAddress
        self.isContacted = isContacted
        self.createdAt = createdAt
    }
}
