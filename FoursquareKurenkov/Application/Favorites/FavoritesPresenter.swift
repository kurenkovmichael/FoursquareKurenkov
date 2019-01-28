import Foundation

class FavoritesPresenter: FavoritesInteractorOutput, FavoritesViewOutput {

    private weak var view: FavoritesViewInput?
    private let interactor: FavoritesInteractorInput
    private let errorRouter: ErrorPoppupRouter
    private let venueDetailsRouter: VenueDetailsRouter

    init(view: FavoritesViewInput,
         interactor: FavoritesInteractorInput,
         errorRouter: ErrorPoppupRouter,
         venueDetailsRouter: VenueDetailsRouter) {
        self.view = view
        self.interactor = interactor
        self.errorRouter = errorRouter
        self.venueDetailsRouter = venueDetailsRouter
    }

    // MARK: - FavoritesViewOutput

    func didTriggeredWillAppearEvent() {
        if let dataProvider = interactor.obtainDataProvider() {
            view?.showContentOf(dataProvider: dataProvider)
        } else {
            errorRouter.showPoppup(withError: nil)
        }
    }

    func didTriggeredPulldownEvent() {
        interactor.reloadFavorites()
    }

    func didTriggeredScrolledToEndEvent() {
        interactor.loadMoreFavorites()
    }

    func didTriggeredSelectVenueEvent(_ venue: Venue) {
        venueDetailsRouter.showVenueDetails(with: venue.identifier, from: nil)
    }

    func didTriggeredUnfavoriteVenueEvent(_ venue: Venue) {
        interactor.unfavorite(venue: venue)
    }

    // MARK: - FavoritesInteractorOutput

    func favoritesRestoreCompleted(_ profile: Any?) {
        interactor.loadMoreFavorites()
    }

    func startReloadingFavorites() {
        view?.showRefrashActivityIndicator()
    }

    func startLoadingMoreFavorites() {
        view?.showLoadMoreActivityIndicator()
    }

    func favoritesLoadingCompletedSuccessfully() {
        view?.hideRefrashActivityIndicator()
        view?.hideLoadMoreActivityIndicator()
    }

    func favoritesLoadingFailed(withError error: Error?) {
        view?.hideRefrashActivityIndicator()
        view?.hideLoadMoreActivityIndicator()
        errorRouter.showPoppup(withError: error)
    }

    func unfavoriteailed(withError error: Error?) {
        errorRouter.showPoppup(withError: error)
    }

}
