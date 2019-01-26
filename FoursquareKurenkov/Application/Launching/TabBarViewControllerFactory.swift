import Foundation

class TabBarViewControllerFactory: ViewControllerFactory {

    private let mapFactory: ViewControllerFactory
    private let favoritesFactory: ViewControllerFactory
    private let profileFactory: ViewControllerFactory

    init(mapFactory: ViewControllerFactory,
         favoritesFactory: ViewControllerFactory,
         profileFactory: ViewControllerFactory) {
        self.mapFactory = mapFactory
        self.favoritesFactory = favoritesFactory
        self.profileFactory = profileFactory
    }

    func viewController() -> UIViewController? {
        var viewControllers: [UIViewController] = []

        if let map = mapFactory.viewController(),
            let tabBarItem = map.tabBarItem {
            tabBarItem.image = UIImage(named: "map")
            tabBarItem.title = NSLocalizedString("map.tabTitle", comment: "")
            viewControllers.append(map)
        }

        if let favorites = favoritesFactory.viewController(),
            let tabBarItem = favorites.tabBarItem {
            tabBarItem.image = UIImage(named: "favorite")
            tabBarItem.title = NSLocalizedString("favorites.tabTitle", comment: "")
            viewControllers.append(favorites)
        }

        if let profile = profileFactory.viewController(),
            let tabBarItem = profile.tabBarItem {
            tabBarItem.image = UIImage(named: "profile")
            tabBarItem.title = NSLocalizedString("profile.tabTitle", comment: "")
            viewControllers.append(profile)
        }

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = viewControllers
        return tabBarController
    }
}
