import UIKit
import MapKit

extension Annotation: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
    }
}

class MapViewController: UIViewController, MapViewInput, MKMapViewDelegate, ViewContainerDelegate {

    var output: MapViewOutput!

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var popoverBackgroundView: UIView!
    @IBOutlet weak var refreshActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var redoSearchActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var redoSearchButton: UIButton!
    @IBOutlet weak var popoverContainerBottomConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.userTrackingMode = .follow
        mapView.showsUserLocation = true

        popoverBackgroundView.backgroundColor = .white
        popoverBackgroundView.layer.masksToBounds = true
        popoverBackgroundView.layer.cornerRadius = 16

        containerView.backgroundColor = .clear
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowRadius = 12
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowOffset = CGSize(width: 0, height: 6)

        refreshButton.layer.masksToBounds = true
        refreshButton.layer.cornerRadius = 24
        refreshButton.layer.borderWidth = 0.5
        refreshButton.layer.borderColor = UIColor.lightGray.cgColor
        refreshButton.tintColorDidChange()

        redoSearchButton.layer.masksToBounds = true
        redoSearchButton.layer.cornerRadius = 24
        redoSearchButton.layer.borderWidth = 0.5
        redoSearchButton.layer.borderColor = UIColor.lightGray.cgColor
        redoSearchButton.tintColorDidChange()
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

    // MARK: - ViewContainerDelegate

    private var childBottomConstraint: NSLayoutConstraint?

    func show(childView child: UIView, completion: (() -> Void)?) {
        show(view: child, on: self.containerView, addSubview: { (container: UIView, child: UIView) in
            child.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(child)
            container.topAnchor.constraint(equalTo: child.topAnchor).isActive = true
            container.leadingAnchor.constraint(equalTo: child.leadingAnchor).isActive = true
            container.trailingAnchor.constraint(equalTo: child.trailingAnchor).isActive = true
            self.childBottomConstraint = container.bottomAnchor.constraint(equalTo: child.bottomAnchor)
        }, animations: {
            self.childBottomConstraint?.isActive = true
            self.popoverContainerBottomConstraint.isActive = true
        }, completion: completion)
    }

    func hide(childView child: UIView, completion: (() -> Void)?) {
        hide(view: child, animations: {
            self.popoverContainerBottomConstraint.isActive = false
            self.childBottomConstraint?.isActive = false
        }, completion: completion)
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
