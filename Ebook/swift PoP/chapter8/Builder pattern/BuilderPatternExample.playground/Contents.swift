import UIKit

protocol BurgerBuilder {
    var name: String { get }
    var patties: Int { get }
    var bacon: Bool { get }
    var cheese: Bool { get }
    var pickles: Bool { get }
    var ketchup: Bool { get }
    var mustard: Bool { get }
    var lettuce: Bool { get }
    var tomato: Bool { get }
}

struct HambugerBuilder: BurgerBuilder {
    var name: String = "Burger"
    var patties: Int = 1
    var bacon: Bool = false
    var cheese: Bool = false
    var pickles: Bool = true
    var ketchup: Bool = true
    var mustard: Bool = true
    var lettuce: Bool = false
    var tomato: Bool = false
}

struct CheeseburgerBuilder: BurgerBuilder {
    var name: String = "Cheeseburger"
    var patties: Int = 1
    var bacon: Bool = false
    var cheese: Bool = true
    var pickles: Bool = true
    var ketchup: Bool = true
    var mustard: Bool = true
    var lettuce: Bool = false
    var tomato: Bool = false
}

struct Burger {
    var name: String
    var patties: Int
    var bacon: Bool
    var cheese: Bool
    var pickles: Bool
    var ketchup: Bool
    var mustard: Bool
    var lettuce: Bool
    var tomato: Bool
    init(builder: BurgerBuilder) {
        self.name = builder.name
        self.patties = builder.patties
        self.bacon = builder.bacon
        self.cheese = builder.cheese
        self.pickles = builder.pickles
        self.ketchup = builder.ketchup
        self.mustard = builder.mustard
        self.lettuce = builder.lettuce
        self.tomato = builder.tomato
    }
    func showBurger() {
        print("Name:\(name)")
        print("Patties: \(patties)")
        print("Bacon:\(bacon)")
        print("Cheese:\(cheese)")
        print("Pickles: \(pickles)")
        print("Ketchup: \(ketchup)")
        print("Mustard: \(mustard)")
        print("Lettuce: \(lettuce)")
        print("Tomato:\(tomato)")
    }
}
var myBurger = Burger(builder: HambugerBuilder())
myBurger.showBurger()
///result:
//Name:Burger
//Patties: 1
//Bacon:false
//Cheese:false
//Pickles: true
//Ketchup: true
//Mustard: true
//Lettuce: false
//Tomato:false

// Create Cheeseburger with tomatos
var myCheeseBurgerBuilder = CheeseburgerBuilder()
var myCheeseBurger = Burger(builder: myCheeseBurgerBuilder)
// Let's hold the tomatos
myCheeseBurger.tomato = false
myCheeseBurger.showBurger()
///result
//Name:Cheeseburger
//Patties: 1
//Bacon:false
//Cheese:true
//Pickles: true
//Ketchup: true
//Mustard: true
//Lettuce: false
//Tomato:false

