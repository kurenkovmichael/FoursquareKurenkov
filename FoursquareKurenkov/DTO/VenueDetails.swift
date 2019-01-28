import Foundation

struct VenueDetails {
    let identifier: String
    let name: String?
    let contact: Contact?
    let location: Location?
    let canonicalUrl: String?
    let categories: [Category]?
    let verified: Bool?
    let url: String?
    let shortUrl: String?
    let likes: Likes?
    let like: Bool
    let rating: Float?
    let ratingColor: String?
    let ratingSignals: Int?
    let photos: Photos?
    let bestPhoto: Photo?
    let description: String?
}

extension VenueDetails: Codable {
    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case contact
        case location
        case canonicalUrl
        case categories
        case verified
        case url
        case shortUrl
        case likes
        case like
        case rating
        case ratingColor
        case ratingSignals
        case photos
        case bestPhoto
        case description
    }
}
