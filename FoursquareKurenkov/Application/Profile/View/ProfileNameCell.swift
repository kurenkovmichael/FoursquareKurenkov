import UIKit

class ProfileNameCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        configure(firstName: firstName, lastName: lastName)
    }

    private var firstName: String?
    private var lastName: String?

    func configure(firstName: String?, lastName: String?) {
        self.firstName = firstName
        self.lastName = lastName
        nameLabel?.text = "\(firstName ?? "") \(lastName ?? "")"
    }
}
