import Foundation

class ModalRouter {

    private let rootRouter: RootRouter
    private let controllerFactory: ViewControllerFactory

    init(rootRouter: RootRouter,
         controllerFactory: ViewControllerFactory) {
        self.rootRouter = rootRouter
        self.controllerFactory = controllerFactory
    }

    func show(from view: UIView?) {
        guard let parrent = rootRouter.rootViewController() else {
            return
        }

        guard let controller = controllerFactory.viewController() else {
            return
        }

        let container = ModalContainerViewController.viewController(withChild: controller)
        container.closeHandler = { [weak container] in
            container?.dismiss(animated: true)
        }

        parrent.present(container, animated: true)
    }
}
