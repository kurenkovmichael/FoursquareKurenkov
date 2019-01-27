import Foundation

struct ResponseVenues: Codable {
    let venues: [Venue]?
}

extension FoursquareApi {

    func searchVenues(latitude: Double,
                      longitude: Double,
                      radius: Int,
                      completion: @escaping (ApiResult<[Venue]>) -> Void) {

        var parameters: [String: Any] = [:]
        parameters["intent"] = "browse"
        parameters["ll"] = "\(latitude),\(longitude)"
        parameters["radius"] = radius
        parameters["limit"] = 100

        request(path: "venues/search",
                parameters: parameters,
                completion: completion) { (response: ResponseVenues) -> [Venue]? in
            return response.venues
        }
    }
}
