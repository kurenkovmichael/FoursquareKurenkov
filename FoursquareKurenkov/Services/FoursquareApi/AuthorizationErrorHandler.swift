import Foundation

class AuthorizationErrorHandler: ApiErrorHandler {

    private let authorizationService: AuthorizationService

    init(authorizationService: AuthorizationService) {
        self.authorizationService = authorizationService
    }

    func handle(error: ApiError?) {
        guard let error = error else {
            return
        }

        switch error {
        case .authorizationError:
            authorizationService.resetAuthorization()

        default:
            break
        }
    }

}
