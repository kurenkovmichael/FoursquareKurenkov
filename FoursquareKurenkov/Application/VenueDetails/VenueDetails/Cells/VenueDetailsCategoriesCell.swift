import UIKit

class VenueDetailsCategoriesCell: UITableViewCell {

    @IBOutlet weak var categoriesLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        configure(categories: categories)
    }

    private var categories: [Category] = []

    func configure(categories: [Category]) {
        self.categories = categories

        let categoriesNames = categories.compactMap { $0.name }
        let categoriesText = categoriesNames.joined(separator: ", ")
        categoriesLabel?.text = categoriesText
    }

}
