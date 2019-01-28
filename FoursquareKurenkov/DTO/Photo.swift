import Foundation

struct PhotoSource: Codable {
    let name: String
    let url: String
}

struct PhotosgGroup: Codable {
    let type: String?
    let name: String?
    let count: Int?
    let items: [Photo]?
}

struct Photos: Codable {
    let count: Int?
    let groups: [PhotosgGroup]?
}

struct Photo {
    let identifier: String
    let name: String?
    let createdAt: Int?
    let source: PhotoSource?
    let prefix: String?
    let suffix: String?
    let width: Int?
    let height: Int?
    let visibility: String?
}

extension Photo: Codable {
    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case createdAt
        case source
        case prefix
        case suffix
        case width
        case height
        case visibility
    }
}

extension Photo: ImageIdentifier {
    func makeUrl(with size: ImageSize) -> URL? {
        let url = (prefix ?? "") + FoursquareApi.imageUrlSizePart(from: size) + (suffix ?? "" )
        return URL(string: url)
    }
}
