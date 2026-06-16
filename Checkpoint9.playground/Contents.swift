import Cocoa

func randomNum(arr: [Int]?) -> Int { return arr?.randomElement() ?? Int.random(in: 1...100) }
