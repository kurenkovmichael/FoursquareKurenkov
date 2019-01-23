import Foundation

struct Profile: Codable {
    let firstName: String
    let lastName: String?
    let bio: String?
    let contact: [String: String]
    let photo: FoursquareImageIdentifier?
}
