import UIKit

protocol Person {
    var firstName: String { get set }
    var lastName: String { get set }
    var birthDate: Date { get set }
    var profession: String { get }
    
    init(firstName: String, lastName: String, birthDate: Date)
}


struct SwiftProgrammer: Person {
    var firstName: String
    var lastName: String
    var birthDate: Date
    var profession: String {
        return "hehe"
    }
    
    init(firstName: String, lastName: String, birthDate: Date) {
        self.firstName = firstName
        self.lastName = lastName
        self.birthDate = birthDate
    }
}

var myPerson: Person

myPerson = SwiftProgrammer(firstName: "jon", lastName: "DanPhi", birthDate: Date())

print(myPerson)
/// result: SwiftProgrammer(firstName: "jon", lastName: "DanPhi", birthDate: 2025-06-04 13:35:45 +0000)
