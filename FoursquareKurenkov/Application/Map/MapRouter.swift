import Foundation

class MapRouter {

    private let container: ViewContainer
    private let storage: VenuesStorage
    private let venueViewFactory = VenueDescriptionFactory()

    init(container: ViewContainer, storage: VenuesStorage) {
        self.container = container
        self.storage = storage
    }

    func showVenueDescription(with identifier: String) {
        if let venue = storage.restore(venueWith: identifier),
           let view = venueViewFactory.venueDescriptionView(with: venue) {
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

    func showPlaceholder(withError error: Error?) {
        guard let view = PlaceholderView.fromDefaultNib() else {
            return
        }
        view.configure(subtitle: "Error: \(String(describing: error?.localizedDescription))")
        container.show(view: view)
    }

    func hideView() {
        container.hideView()
    }

}
