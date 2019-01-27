import Foundation

class ProfileViewControllerFactory: ViewControllerFactory {

    private let authorizationService: AuthorizationService
    private let api: FoursquareApi
    private let imagesServise: ImagesServise

    init(authorizationService: AuthorizationService,
         api: FoursquareApi,
         imagesServise: ImagesServise) {
        self.authorizationService = authorizationService
        self.api = api
        self.imagesServise = imagesServise
    }

    func viewController() -> UIViewController? {
        let view = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        view.imageViewConfigurator = ImageViewConfigurator(imagesServise: imagesServise)

        let interactor = ProfileInteractor(authorizationService: authorizationService,
                                           api: api,
                                           storage: UserDefaultsProfileStorage())

        let router = ErrorPoppupRouter(container: ViewContainer(delegate: view.popupView))
        let presenter = ProfilePresenter(view: view, interactor: interactor, router: router)
        view.output = presenter
        interactor.output = presenter

        return view
    }
}
