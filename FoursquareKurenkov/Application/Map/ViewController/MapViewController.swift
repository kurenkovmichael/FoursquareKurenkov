import UIKit
import MapKit

extension Annotation: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
    }
}

class MapViewController: UIViewController, MapViewInput, MKMapViewDelegate {

    var output: MapViewOutput!

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var popupContainerView: UIView!
    @IBOutlet weak var refreshActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var redoSearchActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var redoSearchButton: UIButton!

    let popupView = PopupContainerView()

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.userTrackingMode = .follow
        mapView.showsUserLocation = true

        refreshButton.setupAsRoundButton(radius: 24)
        redoSearchButton.setupAsRoundButton(radius: 24)

        popupView.addOn(superview: popupContainerView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.output.didTriggeredWillAppearEvent()
    }

    // MARK: - MapViewInput

    func show(annotations: [Annotation]) {
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(annotations, animated: isViewLoaded)
    }

    func hide(annotations: [Annotation]) {
        mapView.removeAnnotations(annotations)
    }

    func showRefreshActivityIndicator() {
        refreshButton.isEnabled = false
        redoSearchButton.isEnabled = false
        refreshButton.setImage(UIImage(), for: .normal)
        refreshActivityIndicatorView.startAnimating()
    }

    func hideRefreshActivityIndicator() {
        refreshButton.isEnabled = true
        redoSearchButton.isEnabled = true
        refreshButton.setImage(UIImage(named: "location"), for: .normal)
        refreshActivityIndicatorView.stopAnimating()
    }

    func showRedoSearchActivityIndicator() {
        refreshButton.isEnabled = false
        redoSearchButton.isEnabled = false
        redoSearchButton.setImage(UIImage(), for: .normal)
        redoSearchActivityIndicatorView.startAnimating()
    }

    func hideRedoSearchActivityIndicator() {
        refreshButton.isEnabled = true
        redoSearchButton.isEnabled = true
        redoSearchButton.setImage(UIImage(named: "navigation"), for: .normal)
        redoSearchActivityIndicatorView.stopAnimating()
    }

    // MARK: - MKMapViewDelegate

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? Annotation {
            output.didTriggeredSelectAnnotationEvent(annotation)
        }
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if let annotation = view.annotation as? Annotation {
            output.didTriggeredDeselectAnnotationEvent(annotation)
        }
    }

    // MARK: - Actions

    @IBAction func refreshButtonPressed(_ sender: Any) {
        output.didTriggeredRefreshButtonPressedEvent()
    }

    @IBAction func redoSearchButtonPressed(_ sender: Any) {
        let coordinate = mapView.centerCoordinate
        output.didTriggeredRedoSearchButtonPressedEvent(coordinate)
    }

}
