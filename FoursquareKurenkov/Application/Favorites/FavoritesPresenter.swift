import Foundation

class FavoritesPresenter: FavoritesInteractorOutput, FavoritesViewOutput {

    private weak var view: FavoritesViewInput?
    private let interactor: FavoritesInteractorInput

    init(view: FavoritesViewInput, interactor: FavoritesInteractorInput) {
        self.view = view
        self.interactor = interactor
    }

    // MARK: - FavoritesViewOutput

    func didTriggeredWillAppearEvent() {
        if let dataProvider = interactor.obtainDataProvider() {
            view?.showContentOf(dataProvider: dataProvider)
        } else {
            // Show error
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

    func favoritesLoadingFailed(withError error: FavoritesError) {
        view?.hideRefrashActivityIndicator()
        view?.hideLoadMoreActivityIndicator()
        // Show error placeholder
    }

}
