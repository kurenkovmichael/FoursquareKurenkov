import Foundation

class FavoritesViewControllerFactory: ViewControllerFactory {

    private let rootRouter: RootRouter
    private let api: FoursquareApi
    private let coreDataStack: CoreDataStack

    init(rootRouter: RootRouter,
         api: FoursquareApi,
         coreDataStack: CoreDataStack) {
        self.rootRouter = rootRouter
        self.api = api
        self.coreDataStack = coreDataStack
    }

    func viewController() -> UIViewController? {
        let view = FavoritesViewController(nibName: "FavoritesViewController", bundle: nil)

        let storage = CoreDataVenueListStorage(name: "Favorites", coreDataStack: coreDataStack)
        let interactor = FavoritesInteractor(api: api, storage: storage)

        let venueDetailsRouter = ModalRouter(rootRouter: rootRouter,
                                             controllerFactory: VenueDetailsViewControllerFactory(api: api))
        let favoritesRouter = FavoritesRouter(venueDetailsRouter: venueDetailsRouter)
        
        let errorRouter = ErrorPoppupRouter(container: ViewContainer(delegate: view.popupView))
        let presenter = FavoritesPresenter(view: view,
                                           interactor: interactor,
                                           errorRouter: errorRouter,
                                           favoritesRouter: favoritesRouter)
        view.output = presenter
        interactor.output = presenter

        return view
    }

}
