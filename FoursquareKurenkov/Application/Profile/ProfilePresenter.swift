import Foundation

class ProfilePresenter: ProfileInteractorOutput, ProfileViewOutput {

    private weak var view: ProfileViewInput?
    private let interactor: ProfileInteractorInput
    private let router: ErrorPoppupRouter

    init(view: ProfileViewInput, interactor: ProfileInteractorInput, router: ErrorPoppupRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
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
                self.router.hidePoppup()
            } else {
                self.view?.show(data: [])
                self.interactor.reloadProfile()
            }
        }
    }

    func startLoadingProfile() {
        DispatchQueue.main.async {
            self.view?.showActivityIndicator()
            self.router.hidePoppup()
        }
    }

    func profileLoadingCompletedSuccessfully(_ profile: Profile) {
        DispatchQueue.main.async {
            let data = self.profileData(from: profile)
            self.view?.show(data: data)
            self.view?.hideActivityIndicator()
        }
    }

    func profileLoadingFailed(withError error: Error?) {
        DispatchQueue.main.async {
            self.view?.hideActivityIndicator()
            self.router.showPoppup(withError: error)
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
            if let type = contactType(for: type) {
                profileData.append(.contact(type: type, content: content))
            }
        }

        if let bio = profile.bio, bio.count > 0 {
            profileData.append(.bio(bio: bio))
        }

        profileData.append(.logout)

        return profileData
    }

    private func contactType(for name: String) -> ContactType? {
        switch name {
        case "twitter":
            return .twitter
        case "facebook":
            return .facebook
        case "email":
            return .email
        case "phone":
            return .phone
        default:
            return nil
        }
    }

}
