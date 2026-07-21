//
//  File.swift
//  Bookworm
//
//  Created by Brandon Hill on 7/20/26.
//

import Foundation
import SwiftData

@Model
class Student {
    var id: UUID
    var name: String

    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}
