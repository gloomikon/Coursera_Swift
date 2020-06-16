import Foundation

// MARK: - Bread structure

public struct Bread {
    public enum BreadType: UInt32 {
        case small = 1
        case medium
        case big
    }

    public let breadType: BreadType
    public static func make() -> Bread {
        guard let breadType = Bread.BreadType(rawValue: UInt32(arc4random_uniform(3) + 1)) else {
            fatalError("Incorrect random value")
        }

        return Bread(breadType: breadType)
    }

    public func bake() {
        let bakeTime = breadType.rawValue
        sleep(UInt32(bakeTime))
    }
}

// MARK: - Bread Storage (FILO)

public struct BreadStorage {
    private var storage: [Bread] = []

    private let mutex = NSLock()

    var count: Int {
        return storage.count
    }

    var isEmpty: Bool {
        return storage.count == 0
    }

    mutating func push(_ bread: Bread) {
        mutex.lock()
        storage.append(bread)
        print("Added \(bread.breadType) bread. There is/are \(count) piece(s) now.")
        mutex.unlock()
    }

    mutating func pop() -> Bread {
        mutex.lock()
        let bread = storage.removeLast()
        mutex.unlock()
        return bread
    }
}

var storage = BreadStorage()
var condition = NSCondition()
var doesBakeryHasBreads = false

// MARK: - Creation Thread

class CreationThread: Thread {
    override func main() {
        let timer = Timer(timeInterval: 2, repeats: true) { _ in
            guard !self.isCancelled else {
                return
            }
            condition.lock()

            let bread = Bread.make()
            storage.push(bread)

            doesBakeryHasBreads = true
            condition.signal()
            condition.unlock()
        }

        RunLoop.current.add(timer, forMode: .default)
        RunLoop.current.run()
    }
}

// MARK: - Working Thread

class WorkingThread: Thread {
    override func main() {
        while !self.isCancelled {
            condition.lock()

            while !doesBakeryHasBreads {
                condition.wait()
            }

            let bread = storage.pop()
            print("Baking the \(bread.breadType) bread. \(storage.count) piece(s) left")
            bread.bake()

            doesBakeryHasBreads = false
            condition.unlock()
        }
        print("Jobs done. There is/are \(storage.count) piece(s) left.")
    }
}

// MARK: - Example

let creationThread = CreationThread()
let workingThread = WorkingThread()
creationThread.start()
workingThread.start()
sleep(20)
creationThread.cancel()
workingThread.cancel()
