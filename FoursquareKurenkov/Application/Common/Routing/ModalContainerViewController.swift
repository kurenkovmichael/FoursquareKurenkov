import UIKit

class ModalContainerViewController: UIViewController {

    @IBOutlet var backgroundView: UIView?
    @IBOutlet var containerView: UIView?
    @IBOutlet var closeButton: UIButton?

    private var child: UIViewController!

    class func viewController(withChild child: UIViewController) -> ModalContainerViewController {
        let viewController = ModalContainerViewController(nibName: "ModalContainerViewController",
                                                          bundle: nil)
        viewController.child = child
        return viewController
    }

    var closeHandler: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        instal(viewController: child)
    }

    private func instal(viewController child: UIViewController) {
        addChild(child)

        child.view.translatesAutoresizingMaskIntoConstraints = false
        containerView?.addSubview(child.view)
        containerView?.topAnchor.constraint(equalTo: child.view.topAnchor).isActive = true
        containerView?.bottomAnchor.constraint(equalTo: child.view.bottomAnchor).isActive = true
        containerView?.leadingAnchor.constraint(equalTo: child.view.leadingAnchor).isActive = true
        containerView?.trailingAnchor.constraint(equalTo: child.view.trailingAnchor).isActive = true

        child.didMove(toParent: self)
    }

    // MARK: - Actions

    @IBAction func closeButtonPressed(_ sender: Any) {
        if let closeHandler = closeHandler {
            closeHandler()
        } else {
            self.dismiss(animated: true)
        }
    }

}
