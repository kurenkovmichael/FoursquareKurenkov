import Foundation

extension FoursquareApi {

    class func imageUrlSizePart(from size: ImageSize) -> String {
        switch size {
        case .widthHeight(let width, let height):
            return "\(width)x\(height)"
        case .original:
            return "original"
        case .cap(let cap):
            return "cap\(cap)"
        case .width(let width):
            return "width\(width)"
        case .height(let height):
            return "height\(height)"
        }
    }

}
