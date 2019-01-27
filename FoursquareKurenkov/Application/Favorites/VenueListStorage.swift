import Foundation

protocol VenueListStorage {
    func maxOrderOfStoredItems(_ completion: @escaping (Int, Error?) -> Void)
    func store(venues: [Venue], offset: Int, completion: @escaping (Bool, Error?) -> Void)
    func dataProvider() -> DataProvider<Venue>?
}
