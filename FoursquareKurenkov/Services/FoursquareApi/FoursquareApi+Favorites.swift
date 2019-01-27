import Foundation

struct VenueList: Codable {
    let count: Int?
    let items: [Venue]?
}

struct ResponseVenueList: Codable {
    let venues: VenueList?
}

extension FoursquareApi {

    func getVenuelikes(limit: Int, offset: Int,
                       completion: @escaping (ApiResult<VenueList>) -> Void) {

        var parameters: [String: Any] = [:]
        parameters["limit"] = limit
        parameters["offset"] = offset

        request(path: "users/self/venuelikes",
                parameters: parameters,
                completion: completion) { (response: ResponseVenueList) -> VenueList? in
            return response.venues
        }
    }

}
