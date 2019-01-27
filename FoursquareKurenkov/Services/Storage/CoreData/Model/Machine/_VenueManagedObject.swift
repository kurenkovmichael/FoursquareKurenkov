// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to VenueManagedObject.swift instead.

import Foundation
import CoreData

public enum VenueManagedObjectAttributes: String {
    case identifier = "identifier"
    case name = "name"
}

public enum VenueManagedObjectRelationships: String {
    case categories = "categories"
    case location = "location"
}

open class _VenueManagedObject: NSManagedObject {

    // MARK: - Class methods

    open class func entityName () -> String {
        return "Venue"
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _VenueManagedObject.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var identifier: String

    @NSManaged open
    var name: String?

    // MARK: - Relationships

    @NSManaged open
    var categories: NSSet

    open func categoriesSet() -> NSMutableSet {
        return self.categories.mutableCopy() as! NSMutableSet
    }

    @NSManaged open
    var location: LocationManagedObject?

}

extension _VenueManagedObject {

    open func addCategories(_ objects: NSSet) {
        let mutable = self.categories.mutableCopy() as! NSMutableSet
        mutable.union(objects as Set<NSObject>)
        self.categories = mutable.copy() as! NSSet
    }

    open func removeCategories(_ objects: NSSet) {
        let mutable = self.categories.mutableCopy() as! NSMutableSet
        mutable.minus(objects as Set<NSObject>)
        self.categories = mutable.copy() as! NSSet
    }

    open func addCategoriesObject(_ value: CategoryManagedObject) {
        let mutable = self.categories.mutableCopy() as! NSMutableSet
        mutable.add(value)
        self.categories = mutable.copy() as! NSSet
    }

    open func removeCategoriesObject(_ value: CategoryManagedObject) {
        let mutable = self.categories.mutableCopy() as! NSMutableSet
        mutable.remove(value)
        self.categories = mutable.copy() as! NSSet
    }

}

