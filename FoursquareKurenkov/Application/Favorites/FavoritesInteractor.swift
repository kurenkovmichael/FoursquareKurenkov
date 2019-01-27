import Foundation

protocol FavoritesInteractorInput {
    func reloadFavorites()
    func loadMoreFavorites()
    func obtainDataProvider() -> DataProvider<Venue>?
}

protocol FavoritesInteractorOutput: class {
    func startReloadingFavorites()
    func startLoadingMoreFavorites()
    func favoritesLoadingCompletedSuccessfully()
    func favoritesLoadingFailed(withError error: Error?)
}

class FavoritesInteractor: FavoritesInteractorInput {

    weak var output: FavoritesInteractorOutput?
    private let api: FoursquareApi
    private let storage: VenueListStorage

    private var loading: Bool = false

    init(api: FoursquareApi, storage: VenueListStorage) {
        self.api = api
        self.storage = storage
    }

    // MARK: - ProfileInteractorInput

    func reloadFavorites() {
        guard !loading else {
            return
        }

        loading = true
        output?.startReloadingFavorites()
        loadFavorites(offset: 0)
    }

    func loadMoreFavorites() {
        guard !loading else {
            return
        }

        loading = true
        output?.startLoadingMoreFavorites()
        storage.maxOrderOfStoredItems { maxOrder, _ in
            self.loadFavorites(offset: maxOrder + 1)
        }
    }

    func obtainDataProvider() -> DataProvider<Venue>? {
        return storage.dataProvider()
    }

    // MARK: - Private

    private func loadFavorites(offset: Int) {
        api.getVenuelikes(limit: 5, offset: offset) { (result) in
            switch result {
            case .success(let response):
                self.storage.store(venues: response.items ?? [], offset: offset) { success, error in
                    self.finishLoading(success: success, error: error)
                }
            case .fail(let error):
                self.finishLoading(success: false, error: error)
            }
        }
    }

    private func finishLoading(success: Bool, error: Error?) {
        loading = false
        if success {
            output?.favoritesLoadingCompletedSuccessfully()
        } else {
            output?.favoritesLoadingFailed(withError: error)
        }
    }
}
