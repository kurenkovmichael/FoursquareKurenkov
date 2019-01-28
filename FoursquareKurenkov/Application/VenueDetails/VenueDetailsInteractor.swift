import Foundation

protocol VenueDetailsInteractorInput {
    func reload()
    func favorite()
    func unfavorite()
}

protocol VenueDetailsInteractorOutput: class {
    func startReloading()
    func loadingCompletedSuccessfully(venue: VenueDetails)
    func loadingFailed(withError error: Error?)
    func startFavoriting()
    func favoritingCompletedSuccessfully(venue: VenueDetails)
    func favoritingFailed(withError error: Error?)
}

protocol VenueDetailsStorage {
    func store(venueDetails: VenueDetails)
    func save(favoriteValue: Bool) -> VenueDetails?
    func restore() -> VenueDetails?
}

class VenueDetailsInteractor: VenueDetailsInteractorInput {

    weak var output: VenueDetailsInteractorOutput?

    private let api: FoursquareApi
    private let storage: VenueDetailsStorage
    private let identifier: String

    private var loading: Bool = false

    init(api: FoursquareApi,
         storage: VenueDetailsStorage,
         identifier: String) {
        self.api = api
        self.storage = storage
        self.identifier = identifier
    }

    // MARK: - VenueDetailsInteractorInput

    func reload() {
        api.getVenueDetails(withIdentifier: identifier) { result in
            switch result {
            case .success(let response):
                self.storage.store(venueDetails: response)
                self.output?.loadingCompletedSuccessfully(venue: response)

            case .fail(let error):
                self.output?.loadingFailed(withError: error)
            }
        }
    }

    func favorite() {
        favorite(value: true)
    }

    func unfavorite() {
        favorite(value: false)
    }

    // MARK: - Private

    func favorite(value: Bool) {
        output?.startFavoriting()
        api.likeVenue(withIdentifier: identifier, value: value) { result in
            self.finishFavorite(value: value, result: result)
        }
    }

    func finishFavorite(value: Bool, result: ApiResult<Bool>) {
        switch result {
        case .success:
            if let venue = storage.save(favoriteValue: value) {
                output?.favoritingCompletedSuccessfully(venue: venue)
            } else {
                output?.favoritingFailed(withError: nil)
            }
        case .fail(let error):
            output?.favoritingFailed(withError: error)
        }
    }

}
