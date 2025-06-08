import UIKit

class MyClass {
    var name = ""
    init(name: String = "") {
        self.name = name
        print("Initializing class with name \(self.name)")
    }
    
    deinit {
        print("Deinitializing class with name \(self.name)")
    }
}

var class1ref1: MyClass? = MyClass(name: "One")
var class2ref1: MyClass? = MyClass(name: "Two")
var class2ref2: MyClass? = class2ref1

print("Setting class1ref1 to nil")
class1ref1 = nil
print("Setting class2ref1 to nil")
class2ref1 = nil
print("Setting class2ref2 to nil")
class2ref2 = nil

///result:
//Initializing class with name One
//Initializing class with name Two
//Setting class1ref1 to nil
//Deinitializing class with name One
//Setting class2ref1 to nil
//Setting class2ref2 to nil
//Deinitializing class with name Two
