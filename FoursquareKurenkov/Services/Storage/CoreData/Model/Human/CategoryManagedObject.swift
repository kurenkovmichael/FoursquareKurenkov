import Foundation

@objc(CategoryManagedObject)
open class CategoryManagedObject: _CategoryManagedObject {

    func fill(from category: Category) {
        identifier = category.identifier
        name = category.name
        pluralName = category.pluralName
        shortName = category.shortName
        if let icon = category.icon {
            iconPrefix = icon.prefix
            iconSuffix = icon.suffix
        } else {
            iconPrefix = nil
            iconSuffix = nil
        }
    }

    func asCategory() -> Category {
        var icon: FoursquareImageIdentifier?
        if let iconPrefix = iconPrefix, let iconSuffix = iconSuffix {
            icon = FoursquareImageIdentifier(prefix: iconPrefix, suffix: iconSuffix)
        }
        return Category(identifier: identifier,
                        name: name,
                        pluralName: pluralName,
                        shortName: shortName,
                        icon: icon)
    }

}
