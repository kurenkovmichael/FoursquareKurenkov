import Foundation
import CoreData

class ResultsControllerDataProvider<FrcType>: DataProvider<FrcType>, NSFetchedResultsControllerDelegate
where FrcType: NSManagedObject {

    private let frc: NSFetchedResultsController<FrcType>

    init(with frc: NSFetchedResultsController<FrcType>) {
        self.frc = frc
        super.init()
        frc.delegate = self
    }

    override func item(at index: Int) -> FrcType {
        return frc.object(at: IndexPath(item: index, section: 0))
    }

    override var numberOfObjects: Int {
        return frc.sections?.first?.numberOfObjects ?? 0
    }

    // MARK: - NSFetchedResultsControllerDelegate

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        willChangeDataBlock?(self)
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        if let item = anObject as? FrcType,
            let change = change(for: type, indexPath: indexPath, newIndexPath: newIndexPath) {
            itemChangeBlock?(self, item, change)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        didChangeDataBlock?(self)
    }

    // MARK: - Private

    func change(for type: NSFetchedResultsChangeType,
                indexPath: IndexPath?,
                newIndexPath: IndexPath?) -> DataProviderChange? {
        switch type {
        case .insert:
            if let index = newIndexPath?.item {
                return .insert(index: index)
            }
        case .delete:
            if let index = indexPath?.item {
                return .delete(index: index)
            }
        case .move:
            if let index = indexPath?.item, let newIndex = newIndexPath?.item {
                if index != newIndex {
                    return .move(oldIndex: index, newIndex: newIndex)
                } else {
                    return .update(index: index)
                }
            }
        case .update:
            if let index = indexPath?.item {
                return .update(index: index)
            }
        }
        return nil
    }

}
