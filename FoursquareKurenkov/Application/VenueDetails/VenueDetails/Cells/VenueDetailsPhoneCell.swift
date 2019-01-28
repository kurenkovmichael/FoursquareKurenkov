import UIKit

class VenueDetailsPhoneCell: UITableViewCell {

    @IBOutlet weak var phoneLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        configure(phone: phone)
    }

    private var phone: String?

    func configure(phone: String?) {
        self.phone = phone
        phoneLabel?.text = phone
    }

}
