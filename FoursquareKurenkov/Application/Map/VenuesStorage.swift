import Foundation

protocol VenuesStorage {
    func store(venues: [Venue])
    func restore(venueWith identifier: String) -> Venue?
}
