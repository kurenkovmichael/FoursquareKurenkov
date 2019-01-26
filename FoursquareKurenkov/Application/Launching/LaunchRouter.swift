import UIKit

class LaunchRouter {

    private let rootFactory: ViewControllerFactory
    private let loginFactory: ViewControllerFactory

    init(rootFactory: ViewControllerFactory,
         loginFactory: ViewControllerFactory) {
        self.rootFactory = rootFactory
        self.loginFactory = loginFactory
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

        guard let viewController = loginFactory.viewController() else {
            return
        }

        show(viewController: viewController)
        state = .shownLoginScreen
    }

    func showApplication() {
        guard state != .shownApplication else {
            return
        }

        guard let viewController = rootFactory.viewController() else {
            return
        }

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
