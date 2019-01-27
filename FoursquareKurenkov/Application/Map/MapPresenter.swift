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
        router.showVenueDescription(with: annotation.identifier)
    }

    func didTriggeredDeselectAnnotationEvent(_ annotation: Annotation) {
        router.hidePoppup()
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
            }
        }
    }

    func searchVenuesFailed(withError error: Error?) {
        DispatchQueue.main.async {
            self.view?.hideRefreshActivityIndicator()
            self.view?.hideRedoSearchActivityIndicator()
            self.router.showPoppup(withError: error)
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

}
