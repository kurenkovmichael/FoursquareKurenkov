import Foundation
import CoreLocation

enum LocationServiceError: Error {
    case authorizationDenied
    case locationUnknown
}

protocol LocationServiceObserver {
    func updateLocations(_ locations: [CLLocation])
    func failedUpdateLocations(with error: LocationServiceError)
}

class LocationService: NSObject, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
    }

    private(set) var locations: [CLLocation] = []

    func requestLocation() {
        let autorized = state.autorized
        state.waitsLocations = !autorized
        if autorized {
            locationManager.requestLocation()
        } else if state.canRequestAuthorization {
            locationManager.requestWhenInUseAuthorization()
        } else {
            notifyFailedUpdateLocations(with: .authorizationDenied)
        }
    }

    // MARK: - Private

    private struct State {
        var waitsLocations: Bool = false
        var authorizationStatus: CLAuthorizationStatus?

        var autorized: Bool {
            if let status = authorizationStatus {
                return status == .authorizedAlways || status == .authorizedWhenInUse
            }
            return false
        }

        var canRequestAuthorization: Bool {
            if let status = authorizationStatus {
                return status == .notDetermined
            }
            return true
        }
    }

    private var state: State = State(waitsLocations: false, authorizationStatus: nil)

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        state.authorizationStatus = status
        if state.waitsLocations {
            requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locations = locations
        notifyUpdateLocations(locations)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = locationServiceError(from: error) {
            notifyFailedUpdateLocations(with: error)
        }
    }

    func locationServiceError(from error: Error) -> LocationServiceError? {
        if let error = error as? CLError {
            print(error.localizedDescription)
            switch error.code {
            case .denied:
                return .authorizationDenied

            case .locationUnknown,
                 .network:
                return .locationUnknown

            default:
                return nil
            }
        }
        return nil
    }

    // MARK: - Observers

    private var observers: [WeakBox<LocationServiceObserver>] = []

    func add(observer: LocationServiceObserver) {
        observers.append(WeakBox(observer))
    }

    func remove(observer: LocationServiceObserver) {
        observers = observers.filter { (box) -> Bool in
            return box.value as AnyObject !== observer as AnyObject
        }
    }

    private func trimObservers() {
        observers = observers.filter { (box) -> Bool in box.value != nil }
    }

    private func notifyUpdateLocations(_ locations: [CLLocation] ) {
        trimObservers()
        for box in observers {
            if let observer = box.value {
                observer.updateLocations(locations)
            }
        }
    }

    private func notifyFailedUpdateLocations(with error: LocationServiceError) {
        trimObservers()
        for box in observers {
            if let observer = box.value {
                observer.failedUpdateLocations(with: error)
            }
        }
    }
}
