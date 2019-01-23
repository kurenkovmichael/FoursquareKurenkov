import UIKit

class ProfileAvatarCell: UITableViewCell, ImageViewInput {

    @IBOutlet weak var avatarImageView: UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView?.layer.cornerRadius = 6
        avatarImageView?.layer.masksToBounds = true
    }

    func cellWillDisplay() {
        output?.didTriggeredReadyToDisplayEvent(withWidth: 120, height: 120)
    }

    // MARK: - ImageViewInput

    var output: ImageViewOutput?

    func show(image: UIImage?) {
        self.avatarImageView?.image = image
    }

    func showPlaceholder() {
        self.avatarImageView?.image = nil
    }

    func showActivityIndicator() { }

}
