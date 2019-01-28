import Foundation

class VenueDetailsViewControllerFactory {

    private let api: FoursquareApi
    private let imagesServise: ImagesServise

    init(api: FoursquareApi,
         imagesServise: ImagesServise) {
        self.api = api
        self.imagesServise = imagesServise
    }

    func viewController(with identifier: String) -> UIViewController? {
        let view = VenueDetailsViewController(nibName: "VenueDetailsViewController", bundle: nil)
        view.imageViewConfigurator = ImageViewConfigurator(imagesServise: imagesServise)

        let interactor = VenueDetailsInteractor(api: api,
                                                storage: MemoryVenueDetailsStorage(),
                                                identifier: identifier)

        let router = ErrorPoppupRouter(container: ViewContainer(delegate: view.popupView))
        let presenter = VenueDetailsPresenter(view: view, interactor: interactor, errorRouter: router)
        view.output = presenter
        interactor.output = presenter

        return view
    }

}
