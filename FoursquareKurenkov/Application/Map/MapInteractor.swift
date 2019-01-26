import Foundation
import CoreLocation

protocol MapInteractorInput: class {
    func searchVenuesForCurrentLocation()
    func searchVenues(for coordinate: CLLocationCoordinate2D)
}

protocol MapInteractorOutput: class {
    func startSearchVenuesForCurrentLocation()
    func startSearchVenuesForArbitraryLocation()
    func searchVenuesCompletedSuccessfully(_ venues: [Venue])
    func searchVenuesFailed(withError error: Error?)
}

class MapInteractor: MapInteractorInput, LocationServiceObserver {

    weak var output: MapInteractorOutput?

    private let api: FoursquareApi
    private let locationService: LocationService
    private let scanRadius: Int
    private let storage: VenuesStorage

    init(api: FoursquareApi,
         locationService: LocationService,
         scanRadius: Int = 2000,
         storage: VenuesStorage) {

        self.api = api
        self.locationService = locationService
        self.scanRadius = scanRadius
        self.storage = storage

        self.locationService.add(observer: self)
    }

    // MARK: - MapInteractorInput

    func searchVenuesForCurrentLocation() {
        output?.startSearchVenuesForCurrentLocation()
        locationService.requestLocation()
    }

    func searchVenues(for coordinate: CLLocationCoordinate2D) {
        output?.startSearchVenuesForArbitraryLocation()
        requestVenues(for: coordinate)
    }

    // MARK: - LocationServiceObserver

    func updateLocations(_ locations: [CLLocation]) {
        if let coordinate = locations.first?.coordinate {
            requestVenues(for: coordinate)
        }
    }

    func failedUpdateLocations(with error: LocationServiceError) {
        self.output?.searchVenuesFailed(withError: error)
    }

    // MARK: - Private

    private func requestVenues(for coordinate: CLLocationCoordinate2D) {
        api.searchVenues(latitude: coordinate.latitude,
                         longitude: coordinate.longitude,
                         radius: scanRadius) { (result) in
                            switch result {
                            case .success(let venues):
                                self.storage.store(venues: venues)
                                self.output?.searchVenuesCompletedSuccessfully(venues)
                            case .fail(let error):
                                self.output?.searchVenuesFailed(withError: error)
                            }
        }
    }
}
