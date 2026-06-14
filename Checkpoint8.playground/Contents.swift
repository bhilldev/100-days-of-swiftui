import Cocoa
import Foundation

protocol Building {
    var buildingType: String { get }
    var rooms: Int { get set }
    var cost: Int { get set }
    var agent: String { get set }
}
extension Building{
    
    func printSummary(){
        // Convert the raw integer into a localized currency string
        let formattedCost = cost.formatted(.currency(code: "USD"))
        print("""
            🏢 Building Summary
            ------------------
            Type:   \(buildingType)
            Rooms:  \(rooms)
            Cost:   \(formattedCost)
            Agent:  \(agent)
            """)
    }
}
struct Office : Building {
    let buildingType = "Office"
    var rooms: Int
    var cost: Int
    var agent: String
}
struct House : Building {
    let buildingType = "House"
    var rooms: Int
    var cost: Int
    var agent: String
}

//Creating some instances to test my structs.
let commercialSpace = Office(rooms: 15, cost: 950_000, agent: "Sarah Jenkins")
let familyHome = House(rooms: 4, cost: 350_000, agent: "David Miller")

commercialSpace.printSummary()
familyHome.printSummary()


