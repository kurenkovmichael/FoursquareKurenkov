import UIKit

class VenueDescriptionView: UIView {

    @IBOutlet var nameLabel: UILabel?
    @IBOutlet var categoriesLabel: UILabel?
    @IBOutlet var addressLabel: UILabel?
    @IBOutlet var separator: UIView?

    override func awakeFromNib() {
        super.awakeFromNib()
        updateContent()
    }

    private var name: String?
    private var address: [String]?
    private var categories: [String]?

    func configure(name: String?,
                   address: [String]?,
                   categories: [String]?) {
        self.name = name
        self.address = address
        self.categories = categories
        updateContent()
    }

    func updateContent() {
        nameLabel?.text = name
        let existName = !(name?.isEmpty ?? true)
        nameLabel?.isHidden = !existName

        let categoriesText = categories?.joined(separator: ", ")
        let existCategories = !(categoriesText?.isEmpty ?? true)
        categoriesLabel?.text = categoriesText
        categoriesLabel?.isHidden = !existCategories

        let addressText = address?.joined(separator: "\n")
        let existAddress = !(addressText?.isEmpty ?? true)
        addressLabel?.text = addressText
        addressLabel?.isHidden = !existAddress
        separator?.isHidden = !existAddress || (!existName && !existCategories)
    }

}

extension VenueDescriptionView {
    func configure(with venue: Venue) {
        configure(name: venue.name,
                  address: venue.location?.formattedAddress,
                  categories: venue.categories?.compactMap { (category) -> String? in
                    return category.name
            })
    }
}
