import UIKit

class VenueDetailsNameCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        configure(name: name)
    }

    private var name: String?

    func configure(name: String?) {
        self.name = name
        nameLabel?.text = name
    }

}
