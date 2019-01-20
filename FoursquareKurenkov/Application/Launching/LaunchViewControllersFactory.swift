import Foundation

class LaunchViewControllersFactory {

    private let authorizationService: AuthorizationService

    init(_ authorizationService: AuthorizationService) {
        self.authorizationService = authorizationService
    }

    func authorizationViewController() -> UIViewController {
        let authorizationVC = AuthorizationViewController(nibName: "AuthorizationViewController",
                                                          bundle: nil)
        let presenter = AuthorizationPresenter.init(view: authorizationVC,
                                                    authorizationService: authorizationService)
        authorizationVC.output = presenter

        return authorizationVC
    }

    func applicationMainViewController() -> UIViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let applicationMainVC = storyboard.instantiateInitialViewController() as? ViewController {
            return applicationMainVC
        }
        return nil
    }

}
