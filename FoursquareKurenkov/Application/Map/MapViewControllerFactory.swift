import Foundation

class MapViewControllerFactory: ViewControllerFactory {

    private let rootRouter: RootRouter
    private let api: FoursquareApi
    private let locationService: LocationService

    init(rootRouter: RootRouter,
         api: FoursquareApi,
         locationService: LocationService) {
        self.rootRouter = rootRouter
        self.api = api
        self.locationService = locationService
    }

    func viewController() -> UIViewController? {
        let view = MapViewController(nibName: "MapViewController", bundle: nil)

        let storage = MemoryVenuesStorage()
        let interactor = MapInteractor(api: api,
                                       locationService: locationService,
                                       storage: storage)

        let venueDetailsRouter = ModalRouter(rootRouter: rootRouter,
                                             controllerFactory: VenueDetailsViewControllerFactory(api: api))

        let router = MapRouter(container: ViewContainer(delegate: view.popupView),
                               storage: storage,
                               venueDetailsRouter: venueDetailsRouter)
        let presenter = MapPresenter(view: view, interactor: interactor, router: router)
        view.output = presenter
        interactor.output = presenter

        return view
    }

}
