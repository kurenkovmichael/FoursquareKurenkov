import UIKit

class VenueDetailsPhotoCell: UITableViewCell, ImageViewInput {

    @IBOutlet weak var photoImageView: UIImageView?
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView?

    func cellWillDisplay() {
        let width = Int(UIScreen.main.bounds.size.width * UIScreen.main.scale)
        output?.didTriggeredReadyToDisplayEvent(with: .width(width: width))
    }

    // MARK: - ImageViewInput

    var output: ImageViewOutput?

    func show(image: UIImage?) {
        activityIndicatorView?.stopAnimating()
        photoImageView?.image = image
    }

    func showPlaceholder() {
        activityIndicatorView?.stopAnimating()
        photoImageView?.image = nil
    }

    func showActivityIndicator() {
        activityIndicatorView?.startAnimating()
    }

}
