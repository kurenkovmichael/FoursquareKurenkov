import Foundation

@objc(VenueListItemManagedObject)
open class VenueListItemManagedObject: _VenueListItemManagedObject {

    class func create(witn identifier: String,
                      index: Int,
                      listName: String,
                      in context: NSManagedObjectContext) -> VenueListItemManagedObject? {
        guard let newVenue = super.create(witn: identifier, in: context) else {
            return nil
        }
        newVenue.index = index as NSNumber
        newVenue.listName = listName
        return newVenue
    }

    class func maxIndexExpression(resultKey: String) -> NSExpressionDescription {
        let keypathExpression = NSExpression(forKeyPath: "index")
        let maxExpression = NSExpression(forFunction: "max:", arguments: [keypathExpression])

        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = resultKey
        expressionDescription.expression = maxExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        return expressionDescription
    }
}
