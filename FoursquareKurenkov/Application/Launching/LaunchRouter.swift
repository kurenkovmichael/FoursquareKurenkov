import UIKit

class LaunchRouter {

    private let viewControllersFactory: LaunchViewControllersFactory

    init(viewControllersFactory: LaunchViewControllersFactory) {
        self.viewControllersFactory = viewControllersFactory
    }

    var window: UIWindow?

    enum State {
        case none
        case shownLoginScreen
        case shownApplication
    }

    private var state: State = .none

    func showLoginScreen() {
        guard state != .shownLoginScreen else {
            return
        }

        let viewController = viewControllersFactory.authorizationViewController()
        show(viewController: viewController)
        state = .shownLoginScreen
    }

    func showApplication() {
        guard state != .shownApplication else {
            return
        }

        let viewController = viewControllersFactory.applicationMainViewController()
        show(viewController: viewController)
        state = .shownApplication
    }

    private func show(viewController: UIViewController) {
        if self.window == nil {
            self.window = UIWindow(frame: UIScreen.main.bounds)
        }

        self.window?.rootViewController = viewController

        self.window?.makeKeyAndVisible()
    }

}
