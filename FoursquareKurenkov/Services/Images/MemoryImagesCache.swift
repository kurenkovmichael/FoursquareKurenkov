import Foundation

class MemoryImagesCache: SyncImagesCache {

    private let memCache = NSCache<AnyObject, UIImage>()

    init(countLimit: Int = 100) {
        memCache.countLimit = countLimit
    }

    // MARK: - ImagesServiseSyncCache

    func image(for key: String) -> UIImage? {
        return memCache.object(forKey: key as AnyObject)
    }

    func seve(image: UIImage, for key: String) {
        memCache.setObject(image, forKey: key as AnyObject)
    }

}
