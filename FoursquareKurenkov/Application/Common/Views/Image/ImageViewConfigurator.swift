import Foundation

class ImageViewConfigurator {

    private let imagesServise: ImagesServise

    init(imagesServise: ImagesServise) {
        self.imagesServise = imagesServise
    }

    func configure(imageView: ImageViewInput, identifier: ImageIdentifier) {
        let presenter = ImagePresenter(imageIdentifier: identifier,
                                       imagesServise: imagesServise)
        presenter.view = imageView
        imageView.output = presenter
    }

}
