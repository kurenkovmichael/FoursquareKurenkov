import Foundation

class VenueDetailsRouter {

    private let rootRouter: RootRouter
    private let controllerFactory: VenueDetailsViewControllerFactory

    init(rootRouter: RootRouter,
         controllerFactory: VenueDetailsViewControllerFactory) {
        self.rootRouter = rootRouter
        self.controllerFactory = controllerFactory
    }

    private weak var showVenueDetails: UIViewController?

    func showVenueDetails(with identifier: String, from view: UIView?) {
        guard let controller = controllerFactory.viewController(with: identifier) else {
            return
        }
        showVenueDetails = controller
        show(viewController: controller, from: view)
    }

    private func show(viewController: UIViewController, from view: UIView?) {
        guard let parrent = rootRouter.rootViewController() else {
            return
        }

        let container = UINavigationController(rootViewController: viewController)
        let closeButton = UIBarButtonItem(image: UIImage(named: "close"), style: .plain,
                                          target: self, action: #selector(closeButtonTapped(_:)))
        viewController.navigationItem.leftBarButtonItem = closeButton

        parrent.present(container, animated: true)
    }

    @objc func closeButtonTapped(_ sender: Any) {
        showVenueDetails?.navigationController?.dismiss(animated: true)
    }
}
