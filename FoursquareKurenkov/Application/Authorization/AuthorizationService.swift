import Foundation
import Security

protocol AuthorizationServiceObserver {
    func updateAuthorization(_ state: AuthorizationService.State)
}

protocol AuthorizationServiceStorage {
    func restoreAccessCode() -> String?
    func storeAccessCode(_ accessCode: String?)
    func restoreAuthToken() -> String?
    func storeAauthToken(_ aauthToken: String?)
    func clean()
}

enum AuthorizationError: Error {
    case failAuthorizeUser(statuscode: FSOAuthStatusCode)
    case failRequestAccessCode(errorCode: FSOAuthErrorCode)
    case failRequestAccessToken(errorCode: FSOAuthErrorCode)
}

class AuthorizationService {

    private let clientId: String
    private let clientSecret: String
    private let callbackURL: String
    private let storage: AuthorizationServiceStorage

    init(clientId: String,
         clientSecret: String,
         callbackURL: String,
         storage: AuthorizationServiceStorage) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.callbackURL = callbackURL
        self.storage = storage
    }

    public enum State {
        case autorized
        case authorization
        case unauthorized(error: AuthorizationError?)
    }

    private(set) var state: State = .unauthorized(error: nil)

    var authToken: String? {
        return storage.restoreAuthToken()
    }

    func authorize() {
        set(state: .authorization)
        if let acessCode = storage.restoreAccessCode() {
            requestAccessToken(withAccessCode: acessCode)
        } else {
            authorizeUser()
        }
    }

    func resetAuthorization() {
        storage.clean()
        set(state: .unauthorized(error: nil))
    }

    func restoreState() {
        if authToken != nil {
            set(state: .autorized)
        } else {
            set(state: .unauthorized(error: nil))
        }
    }

    // MARK: Authorization

    private func authorizeUser() {
        let statuscode = FSOAuth.authorizeUser(usingClientId: clientId,
                                    nativeURICallbackString: callbackURL,
                                    universalURICallbackString: nil,
                                    allowShowingAppStore: true)

        if statuscode != FSOAuthStatusCode.success {
            let error = AuthorizationError.failAuthorizeUser(statuscode: statuscode)
            authorizationFailed(withError: error)
        }
    }

    private func requestAccessToken(withAccessCode acessCode: String) {
        let completion = { [self] (authToken: String?, requestCompleted: Bool, errorCode: FSOAuthErrorCode) in
            switch errorCode {
            case .invalidGrant:
                self.authorizeUser()
            default:
                if let authToken = authToken {
                    self.compleateAuthorizationSuccessfully(withAuthToken: authToken)
                } else {
                    let error = AuthorizationError.failRequestAccessToken(errorCode: errorCode)
                    self.authorizationFailed(withError: error)
                }
            }
        }

        FSOAuth.requestAccessToken(forCode: acessCode,
                                   clientId: clientId,
                                   callbackURIString: callbackURL,
                                   clientSecret: clientSecret,
                                   completionBlock: completion)
    }

    func handleURL(url: URL) {
        guard let callbackURL = URL(string: callbackURL),
            url.scheme == callbackURL.scheme && url.host == callbackURL.host else {
            return
        }

        var errorCode: FSOAuthErrorCode = FSOAuthErrorCode.none
        let accessCode = FSOAuth.accessCode(forFSOAuthURL: url, error: &errorCode)

        if let accessCode = accessCode, errorCode == FSOAuthErrorCode.none {
            storage.storeAccessCode(accessCode)
            requestAccessToken(withAccessCode: accessCode)
        } else {
            let error = AuthorizationError.failRequestAccessCode(errorCode: errorCode)
            authorizationFailed(withError: error)
        }
    }

    // MARK: State

    private func compleateAuthorizationSuccessfully(withAuthToken authToken: String) {
        storage.storeAauthToken(authToken)
        set(state: .autorized)
    }

    private func authorizationFailed(withError error: AuthorizationError?) {
        storage.storeAauthToken(nil)
        set(state: .unauthorized(error: error))
    }

    private func set(state: State) {
        self.state = state
        notifyUpdateAuthorization()
    }

    // MARK: Observers

    private var observers: [WeakBox<AuthorizationServiceObserver>] = []

    func add(observer: AuthorizationServiceObserver) {
        observers.append(WeakBox(observer))
    }

    func remove(observer: AuthorizationServiceObserver) {
        observers = observers.filter { (box) -> Bool in
            return box.value as AnyObject !== observer as AnyObject
        }
    }

    private func trimObservers() {
        observers = observers.filter { (box) -> Bool in box.value != nil }
    }

    private func notifyUpdateAuthorization() {
        trimObservers()
        for box in observers {
            if let observer = box.value {
                observer.updateAuthorization(state)
            }
        }
    }

}
