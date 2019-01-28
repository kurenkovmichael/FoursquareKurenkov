import Foundation

struct VenueList: Codable {
    let count: Int?
    let items: [Venue]?
}

struct ResponseVenueList: Codable {
    let venues: VenueList?
}

struct Likes: Codable {
    let count: Int
}

struct ResponseLike: Codable {
    let likes: Likes?
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

    func likeVenue(withIdentifier identifier: String,
                   value: Bool,
                   completion: @escaping (ApiResult<Bool>) -> Void) {

        var parameters: [String: Any] = [:]
        parameters["set"] = value ? 1 : 0

        request(path: "venues/\(identifier)/like",
                method: .post,
                parameters: parameters,
                completion: completion,
                resultConverter: { (_: ResponseLike) -> Bool? in return true })
    }

}
