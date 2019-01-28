import Foundation

protocol VenueDetailsViewInput: class {
    func show(venue: Venue)
    func showRefrashActivityIndicator()
    func hideRefrashActivityIndicator()
}

protocol VenueDetailsViewOutput: class {
    func didTriggeredWillAppearEvent()
    func didTriggeredPulldownEvent()
    func didTriggeredFavoriteVenueEvent()
    func didTriggeredUnfavoriteVenueEvent()
}
