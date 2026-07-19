//
//  File.swift
//  CupcakeCorner
//
//  Created by Brandon Hill on 7/17/26.
//


import Foundation

@Observable
class Order: Codable {
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
        case _streetAddress = "streetAddress"
        case _city = "city"
        case _zip = "zip"
    }

    // Explicit string keys to prevent typos
    enum DefaultsKey {
        static let name = "order.name"
        static let streetAddress = "order.streetAddress"
        static let city = "order.city"
        static let zip = "order.zip"
    }

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

    // Address fields
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""

    // Manual init to read saved properties on startup
    init() {
        self.name = UserDefaults.standard.string(forKey: DefaultsKey.name) ?? ""
        self.streetAddress = UserDefaults.standard.string(forKey: DefaultsKey.streetAddress) ?? ""
        self.city = UserDefaults.standard.string(forKey: DefaultsKey.city) ?? ""
        self.zip = UserDefaults.standard.string(forKey: DefaultsKey.zip) ?? ""
    }

    // Explicit method to write current properties down to disk
    func saveAddress() {
        UserDefaults.standard.set(name, forKey: DefaultsKey.name)
        UserDefaults.standard.set(streetAddress, forKey: DefaultsKey.streetAddress)
        UserDefaults.standard.set(city, forKey: DefaultsKey.city)
        UserDefaults.standard.set(zip, forKey: DefaultsKey.zip)
    }
}
