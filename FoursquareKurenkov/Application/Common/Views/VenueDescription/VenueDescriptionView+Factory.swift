import Foundation

extension VenueDescriptionView {

    class func venueDescriptionView(with venue: Venue,
                                    pressHandler: ((UIView?) -> Void)? = nil) -> UIView? {
        guard let view = VenueDescriptionView.fromDefaultNib() else {
            return nil
        }

        view.configure(with: venue, pressHandler: pressHandler)
        return view
    }

}
