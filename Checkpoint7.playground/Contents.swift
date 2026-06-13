import Cocoa

class Animal {
    var legs: Int
    init(legs: Int){
        self.legs = legs
    }
}
class Dog : Animal {
    init(){
        super.init(legs: 4)
    }
    func speak(){
       print("Woof!")
    }
}
class Corgi : Dog {
    override func speak(){
        print("Yip!")
    }
}
class Poodle : Dog {
    override func speak(){
        print("Ruff!")
    }
}

class Cat: Animal {
    var isTame: Bool
    
    // Drop 'legs' from the parameters, hardcode it into super.init!
    init(isTame: Bool) {
        self.isTame = isTame
        super.init(legs: 4)
    }
    
    func speak() {
        print("Meow!")
    }
}
class Persian : Cat {
    override func speak(){
        print("Purrr!")
    }
}

class Lion : Cat {
    override func speak(){
        print("Raaaawr!!!!")
    }
}

// ==========================================
// 2. TEST OBJECT GENERATION & EXECUTION
// ==========================================

print("--- 🐕 RUNNING DOG TESTS 🐕 ---")

// Iteration 1: The Base Dog
let genericDog = Dog()
print("Base Dog has \(genericDog.legs) legs.")
genericDog.speak()

// Iteration 2: The Corgi Subclass
let lowRider = Corgi()
print("Corgi has \(lowRider.legs) legs.")
lowRider.speak()

// Iteration 3: The Poodle Subclass
let fancyPoodle = Poodle()
print("Poodle has \(fancyPoodle.legs) legs.")
fancyPoodle.speak()


print("\n--- 🐈 RUNNING CAT TESTS 🐈 ---")

// Iteration 4: Base Cat - Tame Version
let houseCat = Cat(isTame: true)
print("House Cat is tame: \(houseCat.isTame) | Legs: \(houseCat.legs)")
houseCat.speak()

// Iteration 5: Base Cat - Feral Version
let alleyCat = Cat(isTame: false)
print("Alley Cat is tame: \(alleyCat.isTame) | Legs: \(alleyCat.legs)")
alleyCat.speak()

// Iteration 6: Persian Subclass (Tame)
let fancyPersian = Persian(isTame: true)
print("Persian is tame: \(fancyPersian.isTame) | Legs: \(fancyPersian.legs)")
fancyPersian.speak()

// Iteration 7: Lion Subclass (Wild!)
let safariKing = Lion(isTame: false)
print("Lion is tame: \(safariKing.isTame) | Legs: \(safariKing.legs)")
safariKing.speak()
