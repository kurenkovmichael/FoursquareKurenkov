import UIKit

protocol AuthorizationViewInput: class {
    func showActivityIndicator()
    func hideActivityIndicator()
}

protocol AuthorizationViewOutput: class {
    func didTriggeredLoginTappedEvent()
}

class AuthorizationViewController: UIViewController, AuthorizationViewInput {

    var output: AuthorizationViewOutput!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicatorBackground: UIView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = NSLocalizedString("login.title", comment: "")
        loginButton.setTitle(NSLocalizedString("login.button", comment: ""), for: .normal)
    }

    // MARK: - AuthorizationViewInput

    func showActivityIndicator() {
        loginButton.isEnabled = false
        activityIndicatorBackground.isHidden = false
        activityIndicatorView.startAnimating()
    }

    func hideActivityIndicator() {
        activityIndicatorView.stopAnimating()
        activityIndicatorBackground.isHidden = true
        loginButton.isEnabled = true
    }

    // MARK: - Actions

    @IBAction func loginButtonPressed(_ sender: Any) {
        output.didTriggeredLoginTappedEvent()
    }

}
