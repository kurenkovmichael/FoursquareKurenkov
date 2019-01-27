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
        resetHidePlaceholderTimer()
        router.showVenueDescription(with: annotation.identifier)
    }

    func didTriggeredDeselectAnnotationEvent(_ annotation: Annotation) {
        resetHidePlaceholderTimer()
        router.hidePlaceholder()
    }

    // MARK: - MapInteractorOutput

    private var shownAnnotations: [Annotation] = []

    func startSearchVenuesForCurrentLocation() {
        DispatchQueue.main.async {
            self.view?.showRefreshActivityIndicator()
        }
    }

    func startSearchVenuesForArbitraryLocation() {
        DispatchQueue.main.async {
            self.view?.showRedoSearchActivityIndicator()
        }
    }

    func searchVenuesCompletedSuccessfully(_ venues: [Venue]) {
        DispatchQueue.main.async {
            self.view?.hideRefreshActivityIndicator()
            self.view?.hideRedoSearchActivityIndicator()
            self.view?.hide(annotations: self.shownAnnotations)
            self.shownAnnotations = self.conver(venues: venues)
            if self.shownAnnotations.count > 0 {
                self.view?.show(annotations: self.shownAnnotations)
            } else {
                self.router.showEmptyPlaceholder()
                self.scheduleHidePlaceholderTimer()
            }
        }
    }

    func searchVenuesFailed(withError error: Error?) {
        DispatchQueue.main.async {
            self.view?.hideRefreshActivityIndicator()
            self.view?.hideRedoSearchActivityIndicator()
            self.router.showPlaceholder(withError: error)
            self.scheduleHidePlaceholderTimer()
        }
    }

    // MARK: - Private

    func conver(venues: [Venue]) -> [Annotation] {
        return venues.compactMap { (venue) -> Annotation? in
            guard let location = venue.location else {
                return nil
            }
            let category = venue.categories?.first?.name
            return Annotation(identifier: venue.identifier,
                              latitude: location.latitude,
                              longitude: location.longitude,
                              title: venue.name,
                              subtitle: category)
        }
    }

    private var hidePlaceholderTimer: Timer?

    func scheduleHidePlaceholderTimer() {
        hidePlaceholderTimer?.invalidate()
        hidePlaceholderTimer = .scheduledTimer(withTimeInterval: 5, repeats: false) { (_) in
            self.router.hidePlaceholder()
            self.resetHidePlaceholderTimer()
        }
    }

    func resetHidePlaceholderTimer() {
        self.hidePlaceholderTimer?.invalidate()
        self.hidePlaceholderTimer = nil
    }
}
