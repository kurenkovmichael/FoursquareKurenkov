import Foundation

class MemoryVenuesStorage: VenuesStorage {

    private var venues: [String: Venue] = [:]

    func store(venues: [Venue]) {
        self.venues.removeAll()
        for venue in venues {
            self.venues[venue.identifier] = venue
        }
    }

    func restore(venueWith identifier: String) -> Venue? {
        return venues[identifier]
    }

}
