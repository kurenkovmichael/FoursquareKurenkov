import UIKit

class FavoriteCell: UITableViewCell {

    private var venueView: VenueDescriptionView?
    private var venue: Venue?

    override func awakeFromNib() {
        super.awakeFromNib()

        venueView = VenueDescriptionView.fromDefaultNib()
        if let venueView = venueView {
            venueView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(venueView)
            contentView.topAnchor.constraint(equalTo: venueView.topAnchor).isActive = true
            contentView.bottomAnchor.constraint(equalTo: venueView.bottomAnchor).isActive = true
            contentView.leadingAnchor.constraint(equalTo: venueView.leadingAnchor).isActive = true
            contentView.trailingAnchor.constraint(equalTo: venueView.trailingAnchor).isActive = true
        }
        if let venue = venue {
            venueView?.configure(with: venue)
        }
    }

    func configure(with venue: Venue) {
        self.venue = venue
        venueView?.configure(with: venue)
    }

}
