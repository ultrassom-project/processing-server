import Foundation

public struct FIFOQueue<T> {
    private var items: [T] = []
    
    mutating func enqueue(_ item: T) {
        items.append(item)
    }
    
    mutating func dequeue() -> T? {
        guard items.first != nil else {
            return nil
        }
        
        return items.removeFirst()
    }
    
    func size() -> Int {
        return items.count
    }
}
