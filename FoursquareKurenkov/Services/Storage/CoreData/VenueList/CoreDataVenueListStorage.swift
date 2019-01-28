import Foundation
import MagicalRecord

class CoreDataVenueListStorage: VenueListStorage {

    private let name: String
    private let coreDataStack: CoreDataStack

    init(name: String, coreDataStack: CoreDataStack) {
        self.name = name
        self.coreDataStack = coreDataStack
    }

    // MARK: - VenueListStorage

    func maxOrderOfStoredItems(_ completion: @escaping (Int, Error?) -> Void) {
        coreDataStack.readAsync { context in
            let maxIndexKey = "maxIndex"
            let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
            request.entity = VenueListItemManagedObject.entity()
            request.resultType = NSFetchRequestResultType.dictionaryResultType
            request.predicate = VenueListItemManagedObject.predicate(listName: self.name)
            request.propertiesToFetch = [VenueListItemManagedObject.maxIndexExpression(resultKey: maxIndexKey)]

            var maxIndex: Int?
            do {
                let fetchResult = try context.fetch(request)
                if let result = fetchResult as? [[String: Int]],
                    let dict = result.first {
                    maxIndex = dict[maxIndexKey]
                }
            } catch {
                print("Failed to fetch max timestamp with error = \(error)")
                completion(0, error)
                return
            }
            completion(maxIndex ?? 0, nil)
        }
    }

    func store(venues venuesToStore: [Venue], offset: Int, completion: @escaping (Bool, Error?) -> Void) {
        coreDataStack.saveAsync({ context in
            let predicate = VenueListItemManagedObject.predicate(listName: self.name)
            let storedVenues = (VenueListItemManagedObject.mr_findAll(with: predicate, in: context)
                as? [VenueListItemManagedObject]) ?? []

            var venueToIdsMapping: [String: VenueListItemManagedObject] = [:]
            var venuesToDelete: [String: VenueListItemManagedObject] = [:]
            for venue in storedVenues {
                venueToIdsMapping[venue.identifier] = venue
                if let index = venue.index as? Int,
                    index >= offset {
                    venuesToDelete[venue.identifier] = venue
                }
            }

            for index in 0 ..< venuesToStore.count {
                let venue = venuesToStore[index]
                let identifier = venue.identifier

                var venueManagedObject = venueToIdsMapping[identifier]
                if venueManagedObject == nil {
                    venueManagedObject = VenueListItemManagedObject.create(witn: identifier,
                                                                           index: offset + index,
                                                                           listName: self.name,
                                                                           in: context)
                } else {
                    venuesToDelete[identifier] = nil
                }
                venueManagedObject?.fill(from: venue, in: context)
            }

            for (_, venueToDelete) in venuesToDelete {
                venueToDelete.delete(in: context)
            }

        }, completion: completion)
    }

    func delete(venue: Venue, completion: @escaping (Bool, Error?) -> Void) {
        coreDataStack.saveAsync({ context in
            let predicate = VenueListItemManagedObject.predicate(identifier: venue.identifier, listName: self.name)
            let venuesToDelete = (VenueListItemManagedObject.mr_findAll(with: predicate, in: context)
                as? [VenueListItemManagedObject]) ?? []
            for venueToDelete in venuesToDelete {
                venueToDelete.delete(in: context)
            }
        }, completion: completion)
    }

    func dataProvider() -> DataProvider<Venue>? {
        let predicate = VenueListItemManagedObject.predicate(listName: name)
        guard let frc = VenueListItemManagedObject.mr_fetchAllSorted(by: "index",
                                ascending: true, with: predicate, groupBy: nil, delegate: nil)
            as? NSFetchedResultsController<VenueListItemManagedObject> else {
            return nil
        }

        let baseDataProvider = ResultsControllerDataProvider(with: frc)
        return DataProviderProxy(with: baseDataProvider, convertItem: { (item: VenueListItemManagedObject) -> Venue? in
            return item.asVenue()
        })
    }

}
