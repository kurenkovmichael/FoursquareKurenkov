import Foundation

class VenueDetailsPresenter: VenueDetailsInteractorOutput, VenueDetailsViewOutput {

    private weak var view: VenueDetailsViewInput?
    private let interactor: VenueDetailsInteractorInput
    private let router: ErrorPoppupRouter

    init(view: VenueDetailsViewInput,
         interactor: VenueDetailsInteractorInput,
         router: ErrorPoppupRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    // MARK: - VenueDetailsViewOutput

    func didTriggeredWillAppearEvent() {
        //
    }

    func didTriggeredPulldownEvent() {
        //
    }

    func didTriggeredFavoriteVenueEvent() {
        //
    }

    func didTriggeredUnfavoriteVenueEvent() {
        //
    }

    // MARK: - VenueDetailsInteractorOutput

    func startReloadingFavorites() {
        //
    }

    func loadingCompletedSuccessfully() {
        //
    }

    func loadingFailed(withError error: Error?) {
        //
    }

}
