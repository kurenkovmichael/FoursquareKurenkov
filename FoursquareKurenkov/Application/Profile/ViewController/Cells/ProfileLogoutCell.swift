import UIKit

class ProfileLogoutCell: UITableViewCell {

    @IBOutlet weak var logoutBackgroundView: UIView!
    @IBOutlet weak var logoutLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        logoutBackgroundView.layer.cornerRadius = 22
        logoutBackgroundView.backgroundColor = tintColor
    }

}
