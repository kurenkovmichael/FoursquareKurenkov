import Foundation

class FavoritesViewControllerFactory: ViewControllerFactory {

    private let rootRouter: RootRouter
    private let api: FoursquareApi
    private let imagesServise: ImagesServise
    private let coreDataStack: CoreDataStack

    init(rootRouter: RootRouter,
         api: FoursquareApi,
         imagesServise: ImagesServise,
         coreDataStack: CoreDataStack) {
        self.rootRouter = rootRouter
        self.api = api
        self.imagesServise = imagesServise
        self.coreDataStack = coreDataStack
    }

    func viewController() -> UIViewController? {
        let view = FavoritesViewController(nibName: "FavoritesViewController", bundle: nil)

        let storage = CoreDataVenueListStorage(name: "Favorites", coreDataStack: coreDataStack)
        let interactor = FavoritesInteractor(api: api, storage: storage)

        let controllerFactory = VenueDetailsViewControllerFactory(api: api, imagesServise: imagesServise)

        let venueDetailsRouter = VenueDetailsRouter(rootRouter: rootRouter,
                                                    controllerFactory: controllerFactory)

        let errorRouter = ErrorPoppupRouter(container: ViewContainer(delegate: view.popupView))
        let presenter = FavoritesPresenter(view: view,
                                           interactor: interactor,
                                           errorRouter: errorRouter,
                                           venueDetailsRouter: venueDetailsRouter)
        view.output = presenter
        interactor.output = presenter

        return view
    }

}
