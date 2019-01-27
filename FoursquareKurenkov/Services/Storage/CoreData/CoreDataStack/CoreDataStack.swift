import Foundation
import CoreData
import MagicalRecord

class CoreDataStack {

    private let storageUrl: URL
    private let readQueue: DispatchQueue

    init(name: String = "FoursquareKurenkov") {
        storageUrl = CoreDataStack.storageUrl(with: name)
        readQueue = DispatchQueue(label: "CoreDataStack.\(name)")
    }

    func setupCoreDataStack() {
        MagicalRecord.setupCoreDataStackWithAutoMigratingSqliteStore(at: storageUrl)
    }

    func readAsync(read:  @escaping (NSManagedObjectContext) -> Void) {
        readQueue.async {
            let rootContext = NSManagedObjectContext.mr_rootSaving()
            let localContext = NSManagedObjectContext.mr_context(withParent: rootContext)
            read(localContext)
            localContext.reset()
        }
    }

    func saveAsync(_ transaction: @escaping (NSManagedObjectContext) -> Void,
                   completion: ((Bool, Error?) -> Void)?) {
        MagicalRecord.save(transaction, completion: completion)
    }

    // MARK: - Private

    private class func storageUrl(with name: String) -> URL {
        let directory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        return directory.appendingPathComponent("\(name).sqlite")
    }

}
