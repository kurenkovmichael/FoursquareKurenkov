import Foundation

enum ImageSize {
    case widthHeight(width: Int, height: Int)
    case original
    case cap(cap: Int)
    case width(width: Int)
    case height(height: Int)
}

protocol ImageIdentifier {
    func makeUrl(with size: ImageSize) -> URL?
}
