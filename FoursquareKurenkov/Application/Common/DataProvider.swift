import Foundation
import CoreData

class DataProvider<DataItem>: NSObject {

    func item(at index: Int) -> DataItem {
        fatalError("\(#function) --> you tried to call abstract method. Check your subclass implementation")
    }

    var numberOfObjects: Int {
        fatalError("\(#function) --> you tried to call abstract method. Check your subclass implementation")
    }

    var isEmpty: Bool {
        return numberOfObjects == 0
    }

    enum Change {
        case insert(index: Int)
        case delete(index: Int)
        case move(oldIndex: Int, newIndex: Int)
        case update(index: Int)
    }

    var willChangeDataBlock: ((DataProvider<DataItem>) -> Void)?
    var didChangeDataBlock: ((DataProvider<DataItem>) -> Void)?
    var itemChangeBlock: ((DataProvider<DataItem>, DataItem, Change) -> Void)?
}

class DataProviderProxy<ExternalType, InternalType>: DataProvider<ExternalType> {

    private var dataProvider: DataProvider<InternalType>
    private var convertItem: (InternalType) -> ExternalType

    init(with dataProvider: DataProvider<InternalType>,
         convertItem: @escaping (InternalType) -> ExternalType) {
        self.dataProvider = dataProvider
        self.convertItem = convertItem
    }

    override func object(atIndex index: Int) -> ExternalType? {
        let internalItem = frc.object(at: IndexPath(item: index, section: 0))
        return convertItem(internalItem)
    }

    override var numberOfObjects: Int {
        return self.dataProvider.numberOfObjects
    }

    override var isEmpty: Bool {
        return self.dataProvider.isEmpty
    }

}
