// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to VenueListItemManagedObject.swift instead.

import Foundation
import CoreData

public enum VenueListItemManagedObjectAttributes: String {
    case index = "index"
    case listName = "listName"
}

open class _VenueListItemManagedObject: VenueManagedObject {

    // MARK: - Class methods

    override open class func entityName () -> String {
        return "VenueListItem"
    }

    override open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _VenueListItemManagedObject.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var index: NSNumber?

    @NSManaged open
    var listName: String?

    // MARK: - Relationships

}

