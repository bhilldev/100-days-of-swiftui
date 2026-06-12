import Cocoa

struct Car {
    let model: String
    let numSeats: Int
    let numGears: Int
    private(set) var currentGear = 1 {
        didSet {
            print("\(model) changed gears. Current gear is \(currentGear)")
        }
    }
    
    mutating func shiftUp() {
        if currentGear < numGears {
            currentGear += 1
        } else {
            print("Already in highest gear.")
        }
    }
    
    mutating func shiftDown() {
        if currentGear > 1 {
            currentGear -= 1
        } else {
            print("Already in lowest gear.")
        }
    }
}

// --- Testing Boundaries ---
var car1 = Car(model: "911", numSeats: 2, numGears: 6)

// Try to shift down past 1st
car1.shiftDown() // Prints: Already in lowest gear.

// Shift all the way to the top
car1.shiftUp() // 2
car1.shiftUp() // 3
car1.shiftUp() // 4
car1.shiftUp() // 5
car1.shiftUp() // 6

// Try to slam it into 7th
car1.shiftUp() // Prints: Already in highest gear.
