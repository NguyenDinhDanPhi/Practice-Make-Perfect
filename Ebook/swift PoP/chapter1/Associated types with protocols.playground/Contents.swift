import UIKit

protocol Queue {
    associatedtype QueueType
    mutating func addItem(item: QueueType)
    mutating func getItem() -> QueueType?
    func count() -> Int
}

struct IntQueue: Queue {
    var items = [Int]()
    
    mutating func addItem(item: Int) {
        items.append(item)
    }
    
    mutating func getItem() -> Int? {
        if items.count > 0 {
            return items.remove(at: 0)
        } else {
            return nil
        }
    }
    
    func count() -> Int {
        return items.count
    }
}

///result: associatedtype QueueType hoạt động tương tự generic type, nghĩa là kiểu dữ liệu do type triển khai tự định nghĩa
