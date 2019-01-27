import UIKit

class FavoriteCell: UITableViewCell {

    private var venueView: VenueDescriptionView?
    private var venue: Venue?

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func configure(with venue: Venue) {
        self.venue = venue
        venueView?.configure(with: venue)
    }

    // MARK: - Private

    func setup() {
        guard venueView == nil else {
            return
        }

        venueView = VenueDescriptionView.fromDefaultNib()
        guard let venueView = venueView else {
            return
        }

        venueView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(venueView)
        contentView.topAnchor.constraint(equalTo: venueView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: venueView.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: venueView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: venueView.trailingAnchor).isActive = true

        if let venue = venue {
            venueView.configure(with: venue)
        }
    }
}
