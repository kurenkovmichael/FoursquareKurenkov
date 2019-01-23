import Foundation

class DiskImagesCache: AsyncImagesCache, SyncImagesCache {

    private let queue: DispatchQueue
    private let fileManager: FileManager
    private let directory: URL

    init(name: String, fileManager: FileManager, directory: URL) {
        self.queue = DispatchQueue(label: "ru.mikhailkurenkov.FoursquareKurenkov." + name)
        self.fileManager = fileManager
        self.directory = directory
    }

    convenience init(name: String) {
        let fileManager = FileManager()
        let directory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        self.init(name: name, fileManager: fileManager, directory: directory)
    }

    // MARK: - AsyncImagesCache, SyncImagesCache

    func image(for key: String) -> UIImage? {
        if let data = imageData(for: key) {
            return  image(from: data)
        }
        return nil
    }

    func image(for key: String, completion: @escaping (UIImage?) -> Void) {
        queue.async {
            completion(self.image(for: key))
        }
    }

    func seve(image: UIImage, for key: String) {
        queue.async {
            guard let data = self.imageToData(image: image) else {
                return
            }

            self.write(data, for: key)
        }
    }

    // MARK: - Private

    private func makeUrl(for key: String) -> URL? {
        if let fileName = fileName(for: key) {
            return directory.appendingPathComponent(fileName)
        }
        return nil
    }

    private func fileName(for key: String) -> String? {
        return key.data(using: .utf8)?.base64EncodedString()
    }

    // MARK: - Private - Files

    private func imageData(for key: String) -> Data? {
        guard let url = makeUrl(for: key) else {
            return nil
        }

        var imageData: Data?
        do {
            imageData = try Data(contentsOf: url)
        } catch {
            // Do nothing
        }
        return imageData
    }

    private func write(_ data: Data, for key: String) {
        guard let url = makeUrl(for: key) else {
            return
        }

        do {
            try data.write(to: url, options: .atomic)
        } catch {
            // Do nothing
        }
    }

    // MAKE: - Private - Image representation

    private func imageToData(image: UIImage) -> Data? {
        return image.pngData()
    }

    private func image(from data: Data) -> UIImage? {
        return UIImage(data: data)
    }

}
