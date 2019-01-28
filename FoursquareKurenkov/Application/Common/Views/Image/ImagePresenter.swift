import Foundation

class ImagePresenter: ImageViewOutput {

    weak var view: ImageViewInput?

    private let imageIdentifier: ImageIdentifier
    private let imagesServise: ImagesServise

    init(imageIdentifier: ImageIdentifier, imagesServise: ImagesServise) {
        self.imageIdentifier = imageIdentifier
        self.imagesServise = imagesServise
    }

    // MARK: - ImageViewOutput

    func didTriggeredReadyToDisplayEvent(with size: ImageSize) {
        guard let url = imageIdentifier.makeUrl(with: size) else {
            view?.showPlaceholder()
            return
        }

        let request = imagesServise.request(url: url)
        if let result = request.result {
            show(resultOfImageRequest: result)
        } else {
            loadImage(request: request)
        }
    }

    private func loadImage(request: ImagesServise.Request) {
        view?.showActivityIndicator()
        request.perform(with: { (result) in
            DispatchQueue.main.async {
                self.show(resultOfImageRequest: result)
            }
        })
    }

    private func show(resultOfImageRequest result: ImagesServise.Result) {
        switch result {
        case .image(let image):
            view?.show(image: image)

        case .failed:
            view?.showPlaceholder()
        }
    }

}
