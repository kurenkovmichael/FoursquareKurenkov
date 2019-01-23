import Foundation
import Alamofire

protocol SyncImagesCache {
    func image(for key: String) -> UIImage?
    func seve(image: UIImage, for key: String)
}

protocol AsyncImagesCache {
    func image(for key: String, completion: @escaping (UIImage?) -> Void)
    func seve(image: UIImage, for key: String)
}

class ImagesServise {

    private let syncCache: SyncImagesCache?
    private let asyncCache: AsyncImagesCache?

    init(syncCache: SyncImagesCache?, asyncCache: AsyncImagesCache?) {
        self.syncCache = syncCache
        self.asyncCache = asyncCache
    }

    enum Result {
        case image(image: UIImage)
        case failed
    }

    class Request {
        private let url: URL
        private weak var imagesServise: ImagesServise?

        init(url: URL, imagesServise: ImagesServise) {
            self.url = url
            self.imagesServise = imagesServise
        }

        private(set) var result: Result?

        var completed: Bool {
            return result != nil
        }

        func perform(with completion: @escaping (Result) -> Void) {
            guard let servise = imagesServise else {
                complete(result: .failed, completion: completion)
                return
            }

            if let image = servise.getImageFromSyncCache(for: url.absoluteString) {
                complete(result: .image(image: image), completion: completion)
                return
            }

            servise.getImageFromAsyncCache(for: url.absoluteString) { [self] (image) in
                if let image = image {
                    self.complete(result: .image(image: image), completion: completion)
                } else {
                    self.loadImage(with: completion)
                }
            }
        }

        private func loadImage(with completion: @escaping (Result) -> Void) {
            guard let servise = imagesServise else {
                complete(result: .failed, completion: completion)
                return
            }

            servise.loadImage(for: url) { [self] (result) in
                self.complete(result: result, completion: completion)
            }
        }

        private func complete(result: Result, completion: @escaping (Result) -> Void) {
            self.result = result
            completion(result)
        }
    }

    func request(url: URL) -> Request {
        return Request(url: url, imagesServise: self)
    }

    private func getImageFromSyncCache(for key: String) -> UIImage? {
        return syncCache?.image(for: key)
    }

    private func getImageFromAsyncCache(for key: String, completion: @escaping (UIImage?) -> Void) {
        guard let cache = asyncCache else {
            completion(nil)
            return
        }

        cache.image(for: key) { [self] (image) in
            if let image = image {
                self.syncCache?.seve(image: image, for: key)
            }
            completion(image)
        }
    }

    private func loadImage(for url: URL, completion: @escaping (Result) -> Void) {
        Alamofire.request(url).response { [self] (response) in
            guard let data = response.data else {
                completion(.failed)
                return
            }

            guard let image = UIImage.init(data: data) else {
                completion(.failed)
                return
            }

            self.syncCache?.seve(image: image, for: url.absoluteString)
            self.asyncCache?.seve(image: image, for: url.absoluteString)

            completion(.image(image: image))
        }
    }

}
