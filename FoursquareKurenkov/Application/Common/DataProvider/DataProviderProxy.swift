import Foundation

class DataProviderProxy<ExternalType, InternalType>: DataProvider<ExternalType> {

    private var dataProvider: DataProvider<InternalType>
    private var convertItem: (InternalType) -> ExternalType?

    init(with dataProvider: DataProvider<InternalType>,
         convertItem:  @escaping (InternalType) -> ExternalType?) {
        self.dataProvider = dataProvider
        self.convertItem = convertItem
        super.init()

        dataProvider.willChangeDataBlock = { [weak self] _ in
            if let self = self {
                self.willChangeDataBlock?(self as DataProvider<ExternalType>)
            }
        }
        dataProvider.itemChangeBlock = { [weak self] _, internalItem, change in
            if let self = self, let item = convertItem(internalItem) {
                self.itemChangeBlock?(self as DataProvider<ExternalType>, item, change)
            }
        }
        dataProvider.didChangeDataBlock = { [weak self] _ in
            if let self = self {
                self.didChangeDataBlock?(self as DataProvider<ExternalType>)
            }
        }
    }

    override func item(at index: Int) -> ExternalType? {
        if let internalItem = dataProvider.item(at: index) {
            return convertItem(internalItem)
        }
        return nil
    }

    override var numberOfObjects: Int {
        return self.dataProvider.numberOfObjects
    }

    override var isEmpty: Bool {
        return self.dataProvider.isEmpty
    }

}
