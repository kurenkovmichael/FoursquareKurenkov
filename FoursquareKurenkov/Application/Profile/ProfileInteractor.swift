import Foundation

protocol ProfileInteractorInput: class {
    func restoreProfile()
    func reloadProfile()
    func logout()
}

protocol ProfileInteractorOutput: class {
    func profileRestoreCompleted(_ profile: Profile?)
    func startLoadingProfile()
    func profileLoadingCompletedSuccessfully(_ profile: Profile)
    func profileLoadingFailed(withError error: Error?)
}

protocol ProfileStorage {
    func store(profile: Profile)
    func restore() -> Profile?
}

class ProfileInteractor: ProfileInteractorInput {

    weak var output: ProfileInteractorOutput?
    private let authorizationService: AuthorizationService
    private let api: FoursquareApi
    private let storage: ProfileStorage

    init(authorizationService: AuthorizationService,
         api: FoursquareApi,
         storage: ProfileStorage) {
        self.authorizationService = authorizationService
        self.api = api
        self.storage = storage
    }

    // MARK: - ProfileInteractorInput

    func restoreProfile() {
        let profile = self.storage.restore()
        self.output?.profileRestoreCompleted(profile)
    }

    func reloadProfile() {
        output?.startLoadingProfile()

        api.getProfile { [self] (response) in
            switch response {
            case .success(let profile):
                self.storage.store(profile: profile)
                self.output?.profileLoadingCompletedSuccessfully(profile)

            case .fail(let error):
                self.output?.profileLoadingFailed(withError: error)
            }
        }
    }

    func logout() {
        authorizationService.resetAuthorization()
    }

}
