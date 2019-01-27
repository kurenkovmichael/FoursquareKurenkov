// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LocationManagedObject.swift instead.

import Foundation
import CoreData

public enum LocationManagedObjectAttributes: String {
    case address = "address"
    case city = "city"
    case country = "country"
    case crossStreet = "crossStreet"
    case distance = "distance"
    case formattedAddress = "formattedAddress"
    case latitude = "latitude"
    case longitude = "longitude"
    case postalCode = "postalCode"
    case state = "state"
}

public enum LocationManagedObjectRelationships: String {
    case venue = "venue"
}

open class _LocationManagedObject: NSManagedObject {

    // MARK: - Class methods

    open class func entityName () -> String {
        return "Location"
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _LocationManagedObject.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var address: String?

    @NSManaged open
    var city: String?

    @NSManaged open
    var country: String?

    @NSManaged open
    var crossStreet: String?

    @NSManaged open
    var distance: NSNumber?

    @NSManaged open
    var formattedAddress: AnyObject?

    @NSManaged open
    var latitude: NSNumber?

    @NSManaged open
    var longitude: NSNumber?

    @NSManaged open
    var postalCode: String?

    @NSManaged open
    var state: String?

    // MARK: - Relationships

    @NSManaged open
    var venue: VenueManagedObject

}

