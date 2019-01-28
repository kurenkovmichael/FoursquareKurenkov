import Foundation

enum SocialType {
    case twitter, facebook, instagram
}

enum VenueDetailsViewData {
    case photo(photo: ImageIdentifier)
    case name(name: String)
    case description(description: String)
    case rating(rating: Float, color: String?)
    case location(location: Location)
    case categories(categories: [Category])
    case phone(phone: String)
    case social(socials: SocialType, content: String)
}

protocol VenueDetailsViewInput: class {
    func show(data: [VenueDetailsViewData], likes: Bool)
    func showRefrashActivityIndicator()
    func hideRefrashActivityIndicator()
    func showFavoriteActivityIndicator()
    func hideFavoriteActivityIndicator()
}

protocol VenueDetailsViewOutput: class {
    func didTriggeredWillAppearEvent()
    func didTriggeredPulldownEvent()
    func didTriggeredFavoriteVenueEvent()
    func didTriggeredUnfavoriteVenueEvent()
}
