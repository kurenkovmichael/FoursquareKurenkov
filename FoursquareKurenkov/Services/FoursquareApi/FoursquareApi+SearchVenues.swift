import Foundation

struct Location: Codable {
    let address: String?
    let crossStreet: String?
    let lat: Double
    let lng: Double
    let distance: Int?
    let postalCode: String?
    let city: String?
    let state: String?
    let country: String?
    let formattedAddress: [String]?
}

struct Category: Codable {
    let identifier: String
    let name: String?
    let pluralName: String?
    let shortName: String?
    let icon: FoursquareImageIdentifier?

    private enum CodingKeys: String, CodingKey {
        case identifier = "id", name, pluralName, shortName, icon
    }
}

struct Venue: Codable {
    let identifier: String
    let name: String?
    let location: Location?
    let categories: [Category]?

    private enum CodingKeys: String, CodingKey {
        case identifier = "id", name, location, categories
    }
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
