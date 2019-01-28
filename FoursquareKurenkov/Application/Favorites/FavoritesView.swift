import Foundation

protocol FavoritesViewInput: class {
    func showContentOf(dataProvider: DataProvider<Venue>)
    func showRefrashActivityIndicator()
    func hideRefrashActivityIndicator()
    func showLoadMoreActivityIndicator()
    func hideLoadMoreActivityIndicator()
}

protocol FavoritesViewOutput: class {
    func didTriggeredWillAppearEvent()
    func didTriggeredPulldownEvent()
    func didTriggeredScrolledToEndEvent()
    func didTriggeredSelectVenueEvent(_ venue: Venue)
    func didTriggeredUnfavoriteVenueEvent(_ venue: Venue)
}
