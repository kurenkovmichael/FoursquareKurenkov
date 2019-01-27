// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CategoryManagedObject.swift instead.

import Foundation
import CoreData

public enum CategoryManagedObjectAttributes: String {
    case iconPrefix = "iconPrefix"
    case iconSuffix = "iconSuffix"
    case identifier = "identifier"
    case name = "name"
    case pluralName = "pluralName"
    case shortName = "shortName"
}

public enum CategoryManagedObjectRelationships: String {
    case venue = "venue"
}

open class _CategoryManagedObject: NSManagedObject {

    // MARK: - Class methods

    open class func entityName () -> String {
        return "Category"
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _CategoryManagedObject.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var iconPrefix: String?

    @NSManaged open
    var iconSuffix: String?

    @NSManaged open
    var identifier: String

    @NSManaged open
    var name: String?

    @NSManaged open
    var pluralName: String?

    @NSManaged open
    var shortName: String?

    // MARK: - Relationships

    @NSManaged open
    var venue: VenueManagedObject

}

