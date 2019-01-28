import Foundation

protocol VenueDetailsInteractorInput {
    func reload()
    func favorite()
    func unfavorite()
}

protocol VenueDetailsInteractorOutput: class {
    func startReloadingFavorites()
    func loadingCompletedSuccessfully()
    func loadingFailed(withError error: Error?)
}

class VenueDetailsInteractor: VenueDetailsInteractorInput {

    weak var output: VenueDetailsInteractorOutput?
    private let api: FoursquareApi

    private var loading: Bool = false

    init(api: FoursquareApi) {
        self.api = api
    }

    // MARK: - VenueDetailsInteractorInput

    func reload() {
        //
    }

    func favorite() {
        //
    }

    func unfavorite() {
        //
    }

}
