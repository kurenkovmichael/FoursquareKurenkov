import UIKit

class VenueDetailsViewController: UIViewController, VenueDetailsViewInput {

    var output: VenueDetailsViewOutput!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var popupContainerView: UIView!

    let popupView = PopupContainerView()
    let placeholderView = PlaceholderContainerView()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = PlaceholderView.fromDefaultNib() {
            view.configure(title: NSLocalizedString("venueDetails.placeholder.title", comment: ""),
                           subtitle: NSLocalizedString("venueDetails.placeholder.message", comment: ""))
            placeholderView.placeholderView = view
        }
        placeholderView.addOn(superview: view)
        popupView.addOn(superview: popupContainerView)
    }

    // MARK: - VenueDetailsViewInput

    func show(venue: Venue) {
        //
    }

    func showRefrashActivityIndicator() {
        //
    }

    func hideRefrashActivityIndicator() {
        //
    }

}
