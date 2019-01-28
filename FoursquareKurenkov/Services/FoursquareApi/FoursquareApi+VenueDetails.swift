import Foundation

struct ResponseVenueDetails: Codable {
    let venue: VenueDetails?
}

extension FoursquareApi {

    func getVenueDetails(withIdentifier identifier: String,
                         completion: @escaping (ApiResult<VenueDetails>) -> Void) {
        request(path: "venues/\(identifier)",
                completion: completion) { (response: ResponseVenueDetails) -> VenueDetails? in
            return response.venue
        }
    }

}
