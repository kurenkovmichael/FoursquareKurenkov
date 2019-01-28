import Foundation

protocol ImageViewInput: class {
    func show(image: UIImage?)
    func showPlaceholder()
    func showActivityIndicator()
    var output: ImageViewOutput? { get set }
}

protocol ImageViewOutput: class {
    func didTriggeredReadyToDisplayEvent(with size: ImageSize)
}
