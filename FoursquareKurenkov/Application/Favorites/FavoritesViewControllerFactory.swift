import Foundation

class FavoritesViewControllerFactory: ViewControllerFactory {

    private let api: FoursquareApi
    private let coreDataStack: CoreDataStack

    init(api: FoursquareApi, coreDataStack: CoreDataStack) {
        self.api = api
        self.coreDataStack = coreDataStack
    }

    func viewController() -> UIViewController? {
        let view = FavoritesViewController(nibName: "FavoritesViewController", bundle: nil)

        let storage = CoreDataVenueListStorage(name: "Favorites", coreDataStack: coreDataStack)
        let interactor = FavoritesInteractor(api: api, storage: storage)

        let presenter = FavoritesPresenter(view: view, interactor: interactor)
        view.output = presenter
        interactor.output = presenter

        return view
    }

}
