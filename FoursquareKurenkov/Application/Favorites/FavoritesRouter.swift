import Foundation

class FavoritesRouter {

    private let venueDetailsRouter: ModalRouter

    init(venueDetailsRouter: ModalRouter) {
        self.venueDetailsRouter = venueDetailsRouter
    }

    func showVenueDetails(from view: UIView?) {
        venueDetailsRouter.show(from: view)
    }

}
