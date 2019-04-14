import Foundation

struct Category {
    let identifier: String
    let name: String?
    let pluralName: String?
    let shortName: String?
    let icon: FoursquareImageIdentifier?
}

extension Category: Codable {
    private enum CodingKeys: String, CodingKey {
        case identifier = "id", name, pluralName, shortName, icon
    }
}
