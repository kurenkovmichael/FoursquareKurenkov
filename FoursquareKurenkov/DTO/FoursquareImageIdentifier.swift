import Foundation

struct FoursquareImageIdentifier: Codable {
    let prefix: String
    let suffix: String
}

extension FoursquareImageIdentifier: ImageIdentifier {
    public func makeUrl(with size: ImageSize) -> URL? {
        let url = prefix + FoursquareApi.imageUrlSizePart(from: size) + suffix
        return URL(string: url)
    }
}
