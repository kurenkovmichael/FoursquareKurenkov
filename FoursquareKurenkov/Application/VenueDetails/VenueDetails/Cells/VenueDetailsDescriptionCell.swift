import UIKit

class VenueDetailsDescriptionCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        configure(description: descr)
    }

    private var descr: String?

    func configure(description: String?) {
        self.descr = description
        descriptionLabel?.text = description
    }

}
