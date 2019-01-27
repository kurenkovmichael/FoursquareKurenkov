import Foundation

class VenueDescriptionFactory {

    func venueDescriptionView(with venue: Venue) -> UIView? {
        guard let view = VenueDescriptionView.fromDefaultNib() else {
            return nil
        }

        view.configure(with: venue)
        return view
    }

}
