import Foundation

struct Location {
    let address: String?
    let crossStreet: String?
    let latitude: Double
    let longitude: Double
    let distance: Int?
    let postalCode: String?
    let city: String?
    let state: String?
    let country: String?
    let formattedAddress: [String]?
}

extension Location: Codable {
    private enum CodingKeys: String, CodingKey {
        case address
        case crossStreet
        case latitude = "lat"
        case longitude = "lng"
        case distance
        case postalCode
        case city
        case state
        case country
        case formattedAddress
    }
}
