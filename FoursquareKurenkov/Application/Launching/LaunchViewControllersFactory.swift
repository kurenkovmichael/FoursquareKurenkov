import Foundation

class LaunchViewControllersFactory {

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

    func authorizationViewController() -> UIViewController {
        let view = AuthorizationViewController(nibName: "AuthorizationViewController", bundle: nil)
        let presenter = AuthorizationPresenter(view: view, authorizationService: authorizationService)
        view.output = presenter
        return view
    }

    func applicationMainViewController() -> UIViewController {

        let map = mapViewController()
        if let tabBarItem = map.tabBarItem {
            tabBarItem.image = UIImage(named: "map")
            tabBarItem.title = NSLocalizedString("profile.tabTitle", comment: "")
        }

        let favorites = favoritesViewController()
        if let tabBarItem = favorites.tabBarItem {
            tabBarItem.image = UIImage(named: "favorite")
            tabBarItem.title = NSLocalizedString("profile.tabTitle", comment: "")
        }

        let profile = profileViewController()
        if let tabBarItem = profile.tabBarItem {
            tabBarItem.image = UIImage(named: "profile")
            tabBarItem.title = NSLocalizedString("profile.tabTitle", comment: "")
        }

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [map, favorites, profile]
        return tabBarController
    }

    func mapViewController() -> UIViewController {
        return profileViewController()
    }

    func favoritesViewController() -> UIViewController {
        return profileViewController()
    }

    func profileViewController() -> UIViewController {
        let view = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        view.imageViewConfigurator = ImageViewConfigurator(imagesServise: imagesServise)

        let interactor = ProfileInteractor(authorizationService: authorizationService,
                                           api: api,
                                           storage: MemoryProfileStorage())

        let presenter = ProfilePresenter(view: view, interactor: interactor)
        view.output = presenter
        interactor.output = presenter

        return view
    }
}
