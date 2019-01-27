import Foundation

extension VenueDescriptionView {

    class func venueDescriptionView(with venue: Venue) -> UIView? {
        guard let view = VenueDescriptionView.fromDefaultNib() else {
            return nil
        }

        view.configure(with: venue)
        return view
    }

}