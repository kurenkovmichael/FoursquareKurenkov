import UIKit

class ProfileContactCell: UITableViewCell {

    @IBOutlet weak var contactLabel: UILabel?
    @IBOutlet weak var iconImageView: UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
        configure(contact: contact, type: type)
    }

    private var contact: String?
    private var type: ContactType?

    func configure(contact: String?, type: ContactType?) {
        self.contact = contact
        self.type = type
        contactLabel?.text = contact
        iconImageView?.image = iconFor(type: type)
    }

    private func iconFor(type: ContactType?) -> UIImage? {
        guard let type = type else {
            return nil
        }
        switch type {
        case .twitter:
            return UIImage(named: "twitter")
        case .facebook:
            return UIImage(named: "facebook")
        case .email:
            return UIImage(named: "email")
        case .phone:
            return UIImage(named: "phone")
        }
    }
}
