import UIKit

protocol DisplayNameDelegate {
    func displayName(name: String)
}

struct Person {
    var delegate: DisplayNameDelegate
    
    var firstName: String {
        didSet {
            delegate.displayName(name:  getFullName())
        }
    }
    
    var lastName: String {
        didSet {
            delegate.displayName(name:  getFullName())
        }
    }
    
    init(delegate: DisplayNameDelegate) {
        self.delegate = delegate
        self.firstName = ""
        self.lastName = ""
    }
    
    func getFullName() -> String {
        return "\(firstName) \(lastName)"
    }
}

struct MyDisplayNameDelegate: DisplayNameDelegate {
    
    func displayName(name: String) {
        print("Name: \(name)")
    }
}

var displayNameDelegate = MyDisplayNameDelegate()

var person = Person(delegate: displayNameDelegate)

person.firstName = "Dan"
///result: Name: Dan
person.lastName = "Phi"
///result: Name: Dan Phi
