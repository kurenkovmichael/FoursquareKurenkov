import Foundation

class AuthorizationPresenter: AuthorizationViewOutput, AuthorizationServiceObserver {

    private weak var view: AuthorizationViewInput?
    private let authorizationService: AuthorizationService

    init(view: AuthorizationViewInput, authorizationService: AuthorizationService) {
        self.view = view
        self.authorizationService = authorizationService
        self.authorizationService.add(observer: self)
    }

    // MARK: - AuthorizationViewOutput

    func didTriggeredLoginTappedEvent() {
        authorizationService.authorize()
    }

    // MARK: - AuthorizationServiceObserver

    func updateAuthorization(_ state: AuthorizationService.State) {
        switch authorizationService.state {
        case .requestAccessToken:
            view?.showActivityIndicator()
        default:
            view?.hideActivityIndicator()
        }
    }

}
