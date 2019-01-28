import UIKit

class ProfileAvatarCell: UITableViewCell, ImageViewInput {

    @IBOutlet weak var avatarImageView: UIImageView?
    @IBOutlet weak var avatarBackgroundView: UIView?
    @IBOutlet weak var avatarActivityIndicatorView: UIActivityIndicatorView?

    override func awakeFromNib() {
        super.awakeFromNib()

        avatarBackgroundView?.backgroundColor = .clear
        avatarBackgroundView?.setupShadow()

        avatarImageView?.backgroundColor = .darkGray
        avatarImageView?.layer.cornerRadius = 8
        avatarImageView?.clipsToBounds = true
    }

    func cellWillDisplay() {
        let size = Int(120 * UIScreen.main.scale)
        output?.didTriggeredReadyToDisplayEvent(with: .widthHeight(width: size, height: size))
    }

    // MARK: - ImageViewInput

    var output: ImageViewOutput?

    func show(image: UIImage?) {
        avatarActivityIndicatorView?.stopAnimating()
        avatarImageView?.image = image
    }

    func showPlaceholder() {
        avatarActivityIndicatorView?.stopAnimating()
        avatarImageView?.image = UIImage(named: "profile")
    }

    func showActivityIndicator() {
        avatarActivityIndicatorView?.startAnimating()
    }

}
