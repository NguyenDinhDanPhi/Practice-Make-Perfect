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

struct FootballPlayer: Person {
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
myPerson = FootballPlayer(firstName: "jon", lastName: "DanPhi", birthDate:  Date())
///result: FootballPlayer(firstName: "jon", lastName: "DanPhi", birthDate: 2025-06-04 13:35:45 +0000)
/// Nghĩa là myPerson có tính đa hình, có thể gán cho nhiều kiểu dữ liệu khác nhau (ví dụ như class/struct) miễn sao kiểu dữ liệu đó tuân thủ chung 1 protocol


var programmer = SwiftProgrammer(firstName: "Nguyen", lastName: "Phi", birthDate: Date())
var player = FootballPlayer(firstName: "DanPhi", lastName: "Phi", birthDate: Date())

var people: [Person] = []
people.append(player)
people.append(programmer)

print(people)
///result: [main.FootballPlayer(firstName: "DanPhi", lastName: "Phi", birthDate: 2025-06-05 07:08:32 +0000), main.SwiftProgrammer(firstName: "Nguyen", lastName: "Phi", birthDate: 2025-06-05 07:08:32 +0000)]
