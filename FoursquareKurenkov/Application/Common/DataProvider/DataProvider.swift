import Foundation

enum DataProviderChange {
    case insert(index: Int)
    case delete(index: Int)
    case move(oldIndex: Int, newIndex: Int)
    case update(index: Int)
}

class DataProvider<DataItem>: NSObject {

    func item(at index: Int) -> DataItem? {
        fatalError("\(#function) --> you tried to call abstract method. Check your subclass implementation")
    }

    var numberOfObjects: Int {
        fatalError("\(#function) --> you tried to call abstract method. Check your subclass implementation")
    }

    var isEmpty: Bool {
        return numberOfObjects == 0
    }

    var willChangeDataBlock: ((DataProvider<DataItem>) -> Void)?
    var didChangeDataBlock: ((DataProvider<DataItem>) -> Void)?
    var itemChangeBlock: ((DataProvider<DataItem>, DataItem, DataProviderChange) -> Void)?
}
