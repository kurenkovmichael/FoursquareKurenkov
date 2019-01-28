import UIKit

class VenueDetailsLocationCell: UITableViewCell {

    @IBOutlet weak var locationLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        configure(location: location)
    }

    private var location: Location?

    func configure(location: Location?) {
        self.location = location

        var addressText = location?.formattedAddress?.joined(separator: "\n")
        if addressText?.isEmpty ?? true {
            addressText = location?.address
        }
        locationLabel?.text = addressText
    }

}
