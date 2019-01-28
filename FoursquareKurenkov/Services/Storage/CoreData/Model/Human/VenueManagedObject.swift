import Foundation

@objc(VenueManagedObject)
open class VenueManagedObject: _VenueManagedObject {

    class func predicate(listName: String) -> NSPredicate {
        return NSPredicate(format: "listName == %@", listName)
    }

    class func predicate(identifier: String, listName: String) -> NSPredicate {
        return NSPredicate(format: "identifier == %@ AND listName == %@", identifier, listName)
    }

    func fill(from venue: Venue, in context: NSManagedObjectContext) {
        name = venue.name

        if let location = venue.location {
            if self.location == nil {
                self.location = LocationManagedObject.mr_createEntity(in: context)
            }
            self.location?.fill(from: location)
        }

        for category in categories {
            if let category = category as? CategoryManagedObject {
                removeCategoriesObject(category)
                context.delete(category)
            }
        }

        for category in venue.categories ?? [] {
            if let newCategory = CategoryManagedObject.mr_createEntity(in: context) {
                newCategory.fill(from: category)
                addCategoriesObject(newCategory)
            }
        }
    }

    func asVenue() -> Venue? {
        return Venue(identifier: identifier,
                     name: name,
                     location: location?.asLocation(),
                     categories: categories.compactMap { ($0 as? CategoryManagedObject)?.asCategory() })
    }

    class func create(witn identifier: String,
                      in context: NSManagedObjectContext) -> VenueListItemManagedObject? {
        guard let newVenue = VenueListItemManagedObject.mr_createEntity(in: context) else {
            return nil
        }
        newVenue.identifier = identifier
        return newVenue
    }

    func delete(in context: NSManagedObjectContext) {
        if let location = location {
            context.delete(location)
        }
        for category in categories {
            if let category = category as? CategoryManagedObject {
                context.delete(category)
            }
        }
        context.delete(self)
    }

}
