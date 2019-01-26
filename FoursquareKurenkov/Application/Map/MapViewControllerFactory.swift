import Foundation

class MapViewControllerFactory: ViewControllerFactory {

    private let api: FoursquareApi
    private let locationService: LocationService

    init(api: FoursquareApi,
         locationService: LocationService) {
        self.api = api
        self.locationService = locationService
    }

    func viewController() -> UIViewController? {
        let view = MapViewController(nibName: "MapViewController", bundle: nil)

        let storage = MemoryVenuesStorage()
        let interactor = MapInteractor(api: api,
                                       locationService: locationService,
                                       storage: storage)

        let router = MapRouter(container: ViewContainer(delegate: view), storage: storage)
        let presenter = MapPresenter(view: view, interactor: interactor, router: router)
        view.output = presenter
        interactor.output = presenter

        return view
    }

}
