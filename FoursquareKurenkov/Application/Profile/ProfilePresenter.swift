import Foundation

class ProfilePresenter: ProfileInteractorOutput, ProfileViewOutput {

    private weak var view: ProfileViewInput?
    private let interactor: ProfileInteractorInput

    init(view: ProfileViewInput, interactor: ProfileInteractorInput) {
        self.view = view
        self.interactor = interactor
    }

    // MARK: - ProfileViewOutput

    func didTriggeredWillAppearEvent() {
        interactor.restoreProfile()
    }

    func didTriggeredPulldownEvent() {
        interactor.reloadProfile()
    }

    func didTriggeredLogoutTappedEvent() {
        interactor.logout()
    }

    // MARK: - ProfileInteractorOutput

    func profileRestoreCompleted(_ profile: Profile?) {
        DispatchQueue.main.async {
            if let profile = profile {
                let data = self.profileData(from: profile)
                self.view?.show(data: data)
            } else {
                self.view?.showEmptyPlaceholder()
                self.interactor.reloadProfile()
            }
        }
    }

    func startLoadingProfile() {
        DispatchQueue.main.async {
            self.view?.showActivityIndicator()
        }
    }

    func profileLoadingCompletedSuccessfully(_ profile: Profile) {
        DispatchQueue.main.async {
            let data = self.profileData(from: profile)
            self.view?.show(data: data)
            self.view?.hideActivityIndicator()
        }
    }

    func profileLoadingFailed(withError error: ProfileError) {
        DispatchQueue.main.async {
            self.view?.showErrorPlaceholder(error)
            self.view?.hideActivityIndicator()
        }
    }

    // MARK: - Private

    private func profileData(from profile: Profile) -> [ProfileViewData] {
        var profileData: [ProfileViewData] = []

        if let photo = profile.photo {
            profileData.append(.avatar(identifier: photo))
        }

        profileData.append(.name(firstName: profile.firstName,
                                 lastName: profile.lastName))

        for (type, content) in profile.contact {
            profileData.append(.contact(type: type, content: content))
        }

        if let bio = profile.bio, bio.count > 0 {
            profileData.append(.bio(bio: bio))
        }

        profileData.append(.logout)

        return profileData
    }
}
