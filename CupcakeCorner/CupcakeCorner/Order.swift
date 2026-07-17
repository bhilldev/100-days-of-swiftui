//
//  File.swift
//  CupcakeCorner
//
//  Created by Brandon Hill on 7/17/26.
//

import SwiftUI
import Observation

@Observable
class Order {
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]

    var type = 0
    var quantity = 3

    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
}
