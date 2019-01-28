import Foundation

class FavoritesPresenter: FavoritesInteractorOutput, FavoritesViewOutput {

    private weak var view: FavoritesViewInput?
    private let interactor: FavoritesInteractorInput
    private let router: ErrorPoppupRouter

    init(view: FavoritesViewInput, interactor: FavoritesInteractorInput, router: ErrorPoppupRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    // MARK: - FavoritesViewOutput

    func didTriggeredWillAppearEvent() {
        if let dataProvider = interactor.obtainDataProvider() {
            view?.showContentOf(dataProvider: dataProvider)
        } else {
            router.showPoppup(withError: nil)
        }
    }

    func didTriggeredPulldownEvent() {
        interactor.reloadFavorites()
    }

    func didTriggeredScrolledToEndEvent() {
        interactor.loadMoreFavorites()
    }

    func didTriggeredSelectVenueEvent(_ venue: Venue) {
        // TODO: Need omplement
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
        router.showPoppup(withError: error)
    }

    func unfavoriteailed(withError error: Error?) {
        router.showPoppup(withError: error)
    }

}
