import UIKit

class VenueDetailsSocialsCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView?
    @IBOutlet weak var contentLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        configure(type: type, content: content)
    }

    private var type: SocialType?
    private var content: String?

    func configure(type: SocialType?, content: String?) {
        self.type = type
        self.content = content

        contentLabel?.text = content
        iconImageView?.image = iconFor(type: type)
    }

    private func iconFor(type: SocialType?) -> UIImage? {
        guard let type = type else {
            return nil
        }
        switch type {
        case .twitter:
            return UIImage(named: "twitter")
        case .facebook:
            return UIImage(named: "facebook")
        case .instagram:
            return UIImage(named: "instagram")
        }
    }

}
