import UIKit

class LaunchRouter {

    private let rootRouter: RootRouter
    private let rootFactory: ViewControllerFactory
    private let loginFactory: ViewControllerFactory

    init(rootRouter: RootRouter,
         rootFactory: ViewControllerFactory,
         loginFactory: ViewControllerFactory) {
        self.rootRouter = rootRouter
        self.rootFactory = rootFactory
        self.loginFactory = loginFactory
    }

    private enum State {
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

        rootRouter.show(rootViewController: viewController)
        state = .shownLoginScreen
    }

    func showApplication() {
        guard state != .shownApplication else {
            return
        }

        guard let viewController = rootFactory.viewController() else {
            return
        }

        rootRouter.show(rootViewController: viewController)
        state = .shownApplication
    }

}
