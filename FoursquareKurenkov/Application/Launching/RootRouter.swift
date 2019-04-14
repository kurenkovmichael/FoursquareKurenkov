import Foundation

class RootRouter {

    private var window: UIWindow?

    func show(rootViewController viewController: UIViewController) {
        if window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
        }

        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }

    func rootViewController() -> UIViewController? {
        return window?.rootViewController
    }

}
