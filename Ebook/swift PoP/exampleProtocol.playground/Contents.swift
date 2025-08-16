import UIKit

protocol ManagerProtocol {
    func requestManager()
    func registerManager()
}

class Manager: ManagerProtocol {
    func requestManager() {
        print("request to Manager")
    }
    
    func registerManager() {
        print("register to Manager")
    }
    
}

class UsingManager: ManagerProtocol {
    func registerManager() {
        manager.registerManager()
    }
    
    var manager: ManagerProtocol
    
    init(manager: ManagerProtocol) {
        self.manager = manager
    }
    
    func requestManager() {
        manager.requestManager()
    }
}
let manager = Manager()
let using = UsingManager(manager: manager)
using.requestManager()
using.registerManager()
