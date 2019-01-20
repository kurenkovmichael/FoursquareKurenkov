import Foundation

final class WeakBox<T> {

    private weak var unbox: AnyObject?

    init(_ value: T) {
        unbox = value as AnyObject
    }

    var value: T? {
        return unbox as? T
    }

}
