import Foundation

struct Venue {
    let identifier: String
    let name: String?
    let location: Location?
    let categories: [Category]?
}

extension Venue: Codable {
    private enum CodingKeys: String, CodingKey {
        case identifier = "id", name, location, categories
    }
}
