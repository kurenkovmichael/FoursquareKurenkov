import Foundation

class AuthorizationViewControllerFactory: ViewControllerFactory {

    private let authorizationService: AuthorizationService

    init(authorizationService: AuthorizationService) {
        self.authorizationService = authorizationService
    }

    func viewController() -> UIViewController? {
        let view = AuthorizationViewController(nibName: "AuthorizationViewController", bundle: nil)
        let presenter = AuthorizationPresenter(view: view, authorizationService: authorizationService)
        view.output = presenter
        return view
    }
}
