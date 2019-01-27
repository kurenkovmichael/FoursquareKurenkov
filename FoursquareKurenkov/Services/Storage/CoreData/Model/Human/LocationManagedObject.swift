import Foundation

@objc(LocationManagedObject)
open class LocationManagedObject: _LocationManagedObject {

    func fill(from location: Location) {
        address = location.address
        crossStreet = location.crossStreet
        latitude = location.latitude as NSNumber
        longitude = location.longitude as NSNumber
        distance = location.distance as NSNumber?
        postalCode = location.postalCode
        city = location.city
        state = location.state
        country = location.country
        formattedAddress = location.formattedAddress as AnyObject
    }

    func asLocation() -> Location? {
        guard let latitude = latitude?.doubleValue,
              let longitude = longitude?.doubleValue else {
            return nil
        }
        return Location(address: address,
                        crossStreet: crossStreet,
                        latitude: latitude,
                        longitude: longitude,
                        distance: distance?.intValue,
                        postalCode: postalCode,
                        city: city,
                        state: state,
                        country: country,
                        formattedAddress: formattedAddress as? [String])
    }

}
