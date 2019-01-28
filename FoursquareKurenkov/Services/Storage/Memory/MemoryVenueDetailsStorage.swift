import Foundation

class MemoryVenueDetailsStorage: VenueDetailsStorage {

    private var venueDetails: VenueDetails?

    func store(venueDetails: VenueDetails) {
        self.venueDetails = venueDetails
    }

    func save(favoriteValue: Bool) -> VenueDetails? {
        guard let venueDetails = venueDetails else {
            return nil
        }

        if venueDetails.like == favoriteValue {
            return venueDetails
        }

        return VenueDetails(identifier: venueDetails.identifier,
                            name: venueDetails.name,
                            contact: venueDetails.contact,
                            location: venueDetails.location,
                            canonicalUrl: venueDetails.canonicalUrl,
                            categories: venueDetails.categories,
                            verified: venueDetails.verified,
                            url: venueDetails.url,
                            shortUrl: venueDetails.shortUrl,
                            likes: venueDetails.likes,
                            like: favoriteValue,
                            rating: venueDetails.rating,
                            ratingColor: venueDetails.ratingColor,
                            ratingSignals: venueDetails.ratingSignals,
                            photos: venueDetails.photos,
                            bestPhoto: venueDetails.bestPhoto,
                            description: venueDetails.description)
    }

    func restore() -> VenueDetails? {
        return venueDetails
    }

}
