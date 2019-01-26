import Foundation
import CoreLocation

class Annotation: NSObject {
    let identifier: String
    let latitude: Double
    let longitude: Double
    let title: String?
    let subtitle: String?

    init(identifier: String, latitude: Double, longitude: Double, title: String?, subtitle: String?) {
        self.identifier = identifier
        self.latitude = latitude
        self.longitude = longitude
        self.title = title
        self.subtitle = subtitle
    }
}

protocol MapViewInput: class {
    func show(annotations: [Annotation])
    func hide(annotations: [Annotation])
    func showRefreshActivityIndicator()
    func hideRefreshActivityIndicator()
    func showRedoSearchActivityIndicator()
    func hideRedoSearchActivityIndicator()
}

protocol MapViewOutput: class {
    func didTriggeredWillAppearEvent()
    func didTriggeredRefreshButtonPressedEvent()
    func didTriggeredRedoSearchButtonPressedEvent(_ coordinate: CLLocationCoordinate2D)
    func didTriggeredSelectAnnotationEvent(_ annotation: Annotation)
    func didTriggeredDeselectAnnotationEvent(_ annotation: Annotation)
}
