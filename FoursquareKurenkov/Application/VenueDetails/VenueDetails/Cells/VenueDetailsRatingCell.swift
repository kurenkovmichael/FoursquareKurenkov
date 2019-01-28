import UIKit

class VenueDetailsRatingCell: UITableViewCell {

    @IBOutlet weak var ratingLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        configure(rating: rating, color: color)
    }

    private var rating: Float = 0
    private var color: String?

    func configure(rating: Float, color: String?) {
        self.rating = rating
        self.color = color
        ratingLabel?.text = "\(rating)"

        if let color = color {
            backgroundColor = UIColor(hexString: color)
        } else {
            backgroundColor = .darkGray
        }
    }
}
