import Foundation

class MapRouter {

    private let container: ViewContainer
    private let storage: VenuesStorage

    init(container: ViewContainer, storage: VenuesStorage) {
        self.container = container
        self.storage = storage
    }

    func showVenueDescription(with identifier: String) {
        if let venue = storage.restore(venueWith: identifier),
           let view = VenueDescriptionView.venueDescriptionView(with: venue) {
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

}
