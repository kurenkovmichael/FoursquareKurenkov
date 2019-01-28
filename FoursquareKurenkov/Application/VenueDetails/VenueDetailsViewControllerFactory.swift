import Foundation

class VenueDetailsViewControllerFactory: ViewControllerFactory {

    private let api: FoursquareApi

    init(api: FoursquareApi) {
        self.api = api
    }

    func viewController() -> UIViewController? {
        let view = VenueDetailsViewController(nibName: "VenueDetailsViewController", bundle: nil)

        let interactor = VenueDetailsInteractor(api: api)

        let router = ErrorPoppupRouter(container: ViewContainer(delegate: view.popupView))
        let presenter = VenueDetailsPresenter(view: view, interactor: interactor, router: router)
        view.output = presenter
        interactor.output = presenter

        return view
    }

}
