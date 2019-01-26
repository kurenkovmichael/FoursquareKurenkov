import Foundation
import CoreLocation

class MapPresenter: MapInteractorOutput, MapViewOutput {

    private weak var view: MapViewInput?
    private let interactor: MapInteractorInput
    private let router: MapRouter

    init(view: MapViewInput, interactor: MapInteractorInput, router: MapRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    // MARK: - MapViewOutput

    func didTriggeredWillAppearEvent() {
        interactor.searchVenuesForCurrentLocation()
    }

    func didTriggeredRefreshButtonPressedEvent() {
        interactor.searchVenuesForCurrentLocation()
    }

    func didTriggeredRedoSearchButtonPressedEvent(_ coordinate: CLLocationCoordinate2D) {
        interactor.searchVenues(for: coordinate)
    }

    func didTriggeredSelectAnnotationEvent(_ annotation: Annotation) {
        resetHideViewTimer()
        router.showVenueDescription(with: annotation.identifier)
    }

    func didTriggeredDeselectAnnotationEvent(_ annotation: Annotation) {
        resetHideViewTimer()
        router.hideView()
    }

    // MARK: - MapInteractorOutput

    private var shownAnnotations: [Annotation] = []

    func startSearchVenuesForCurrentLocation() {
        view?.showRefreshActivityIndicator()
    }

    func startSearchVenuesForArbitraryLocation() {
        view?.showRedoSearchActivityIndicator()
    }

    func searchVenuesCompletedSuccessfully(_ venues: [Venue]) {
        view?.hideRefreshActivityIndicator()
        view?.hideRedoSearchActivityIndicator()
        view?.hide(annotations: shownAnnotations)
        shownAnnotations = conver(venues: venues)
        if shownAnnotations.count > 0 {
            view?.show(annotations: shownAnnotations)
        } else {
            router.showEmptyPlaceholder()
            scheduleHideViewTimer()
        }
    }

    func searchVenuesFailed(withError error: Error?) {
        view?.hideRefreshActivityIndicator()
        view?.hideRedoSearchActivityIndicator()
        router.showPlaceholder(withError: error)
        scheduleHideViewTimer()
    }

    // MARK: - Private

    func conver(venues: [Venue]) -> [Annotation] {
        return venues.compactMap { (venue) -> Annotation? in
            guard let location = venue.location else {
                return nil
            }
            let category = venue.categories?.first?.name
            return Annotation(identifier: venue.identifier,
                              latitude: location.lat,
                              longitude: location.lng,
                              title: venue.name,
                              subtitle: category)
        }
    }

    private var hideViewTimer: Timer?

    func scheduleHideViewTimer() {
        hideViewTimer?.invalidate()
        hideViewTimer = .scheduledTimer(withTimeInterval: 5, repeats: false) { (_) in
            self.router.hideView()
            self.resetHideViewTimer()
        }
    }

    func resetHideViewTimer() {
        self.hideViewTimer?.invalidate()
        self.hideViewTimer = nil
    }
}
