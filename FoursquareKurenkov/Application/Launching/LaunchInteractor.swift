import Foundation

class LaunchInteractor: AuthorizationServiceObserver {

    private let launchRouter: LaunchRouter
    private let authorizationService: AuthorizationService

    init(launchRouter: LaunchRouter,
         authorizationService: AuthorizationService) {
        self.launchRouter = launchRouter
        self.authorizationService = authorizationService
        self.authorizationService.add(observer: self)
    }

    func launchApplication() {
        authorizationService.restoreState()
        showScreen(forAuthorizationState: authorizationService.state)
    }

    private func showScreen(forAuthorizationState state: AuthorizationService.State) {
        switch state {
        case .autorized:
            launchRouter.showApplication()
        default:
            launchRouter.showLoginScreen()
        }
    }

    // MARK: AuthorizationServiceObserver

    func updateAuthorization(_ state: AuthorizationService.State) {
        showScreen(forAuthorizationState: state)
    }

}
