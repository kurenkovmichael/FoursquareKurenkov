import Foundation

class VenueDetailsPresenter: VenueDetailsInteractorOutput, VenueDetailsViewOutput {

    private weak var view: VenueDetailsViewInput?
    private let interactor: VenueDetailsInteractorInput
    private let errorRouter: ErrorPoppupRouter

    init(view: VenueDetailsViewInput,
         interactor: VenueDetailsInteractorInput,
         errorRouter: ErrorPoppupRouter) {
        self.view = view
        self.interactor = interactor
        self.errorRouter = errorRouter
    }

    // MARK: - VenueDetailsViewOutput

    func didTriggeredWillAppearEvent() {
        interactor.reload()
    }

    func didTriggeredPulldownEvent() {
        interactor.reload()
    }

    func didTriggeredFavoriteVenueEvent() {
        interactor.favorite()
    }

    func didTriggeredUnfavoriteVenueEvent() {
        interactor.unfavorite()
    }

    // MARK: - VenueDetailsInteractorOutput

    func startReloading() {
        view?.showRefrashActivityIndicator()
    }

    func loadingCompletedSuccessfully(venue: VenueDetails) {
        view?.hideRefrashActivityIndicator()
        view?.show(data: viewData(from: venue), likes: venue.like)
    }

    func loadingFailed(withError error: Error?) {
        view?.hideRefrashActivityIndicator()
        errorRouter.showPoppup(withError: error)
    }

    func startFavoriting() {
        view?.showFavoriteActivityIndicator()
    }

    func favoritingCompletedSuccessfully(venue: VenueDetails) {
        view?.hideFavoriteActivityIndicator()
        view?.show(data: viewData(from: venue), likes: venue.like)
    }

    func favoritingFailed(withError error: Error?) {
        view?.hideFavoriteActivityIndicator()
        errorRouter.showPoppup(withError: error)
    }

    // MARK: - Private

    func viewData(from venue: VenueDetails) -> [VenueDetailsViewData] {
        var data: [VenueDetailsViewData] = []

        if let name = venue.name, !name.isEmpty {
            data.append(.name(name: name))
        }

        if let bestPhoto = findPhoto(in: venue) {
            data.append(.photo(photo: bestPhoto))
        }

        if let rating = venue.rating {
            data.append(.rating(rating: rating, color: venue.ratingColor))
        }

        if let description = venue.description, !description.isEmpty {
            data.append(.description(description: description))
        }

        if let location = venue.location {
            data.append(.location(location: location))
        }

        if let categories = venue.categories, !categories.isEmpty {
            data.append(.categories(categories: categories))
        }

        if let contact = venue.contact, let phone = contact.phone {
            data.append(.phone(phone: phone))
        }

        if let facebook = venue.contact?.facebook {
            data.append(.social(socials: .facebook, content: facebook))
        }

        if let twitter = venue.contact?.twitter {
            data.append(.social(socials: .twitter, content: twitter))
        }

        if let instagram = venue.contact?.instagram {
            data.append(.social(socials: .instagram, content: instagram))
        }

        return data
    }

    func findPhoto(in venue: VenueDetails) -> Photo? {
        if let bestPhoto = venue.bestPhoto {
            return bestPhoto
        }
        for group in venue.photos?.groups ?? [] {
            if let photo = group.items?.first {
                return photo
            }
        }
        return nil
    }

}
