import Foundation

class MapRouter {

    private let container: ViewContainer
    private let storage: VenuesStorage
    private let venueDetailsRouter: ModalRouter

    init(container: ViewContainer,
         storage: VenuesStorage,
         venueDetailsRouter: ModalRouter) {
        self.container = container
        self.storage = storage
        self.venueDetailsRouter = venueDetailsRouter
    }

    func showVenueDescription(with identifier: String) {
        let pressHandler: (UIView?) -> Void = { [weak self] sender in
            self?.showVenueDetails(from: sender)
        }

        if let venue = storage.restore(venueWith: identifier),
            let view = VenueDescriptionView.venueDescriptionView(with: venue, pressHandler: pressHandler) {
            container.show(view: view)
        }
    }

    func showEmptyPlaceholder() {
        guard let view = PlaceholderView.fromDefaultNib() else {
            return
        }
        view.configure(subtitle: NSLocalizedString("map.emptyPlaceholder", comment: ""))
        container.show(view: view)
    }

    func showPoppup(withError error: Error?) {
        guard let view = PlaceholderView.fromDefaultNib() else {
            return
        }
        view.configure(title: NSLocalizedString("error.default.title", comment: ""),
                       subtitle: NSLocalizedString("error.default.message", comment: ""))
        container.show(view: view)
    }

    func hidePoppup() {
        container.hideView()
    }

    func showVenueDetails(from view: UIView?) {
        venueDetailsRouter.show(from: view)
    }

}
