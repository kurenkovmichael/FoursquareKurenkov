import Foundation

class VenueDescriptionFactory {

    func venueDescriptionView(with venue: Venue) -> UIView? {
        guard let view = VenueDescriptionView.fromDefaultNib() else {
            return nil
        }

        view.configure(name: venue.name,
                       address: venue.location?.formattedAddress,
                       categories: venue.categories?.compactMap { (category) -> String? in
                        return category.name
            })
        return view
    }

}
