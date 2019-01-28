import UIKit

class VenueDescriptionView: UIView {

    @IBOutlet var nameLabel: UILabel?
    @IBOutlet var categoriesLabel: UILabel?
    @IBOutlet var addressLabel: UILabel?
    @IBOutlet var separator: UIView?

    private var tapGestureRecognizer: UITapGestureRecognizer?

    override func awakeFromNib() {
        super.awakeFromNib()

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureTapped(recognizer:)))
        addGestureRecognizer(recognizer)
        tapGestureRecognizer = recognizer

        updateContent()
    }

    private var name: String?
    private var address: [String]?
    private var categories: [String]?
    private var pressHandler: ((UIView?) -> Void)?

    func configure(name: String?,
                   address: [String]?,
                   categories: [String]?,
                   pressHandler: ((UIView?) -> Void)? = nil) {
        self.name = name
        self.address = address
        self.categories = categories
        self.pressHandler = pressHandler
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

        tapGestureRecognizer?.isEnabled = pressHandler != nil
    }

    @objc func tapGestureTapped(recognizer: UITapGestureRecognizer) {
        pressHandler?(self)
    }
}

extension VenueDescriptionView {

    func configure(with venue: Venue,
                   pressHandler: ((UIView?) -> Void)? = nil) {

        let categories = venue.categories?.compactMap { (category) -> String? in
            return category.name
        }

        configure(name: venue.name,
                  address: venue.location?.formattedAddress,
                  categories: categories,
                  pressHandler: pressHandler)
    }

}
