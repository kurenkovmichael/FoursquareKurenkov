import Foundation
import KeychainAccess

class KeychainAuthorizationStorage: AuthorizationServiceStorage {

    private let keychain = Keychain(service: "ru.mikhailkurenkov.foursquare.token")

    private let accessCodeKey = "AccessCode"
    private let authTokenKey = "AuthToken"

    func restoreAccessCode() -> String? {
        return keychain[accessCodeKey]
    }

    func storeAccessCode(_ accessCode: String?) {
        keychain[accessCodeKey] = accessCode
    }

    func restoreAuthToken() -> String? {
        return keychain[authTokenKey]
    }

    func storeAauthToken(_ authToken: String?) {
        keychain[authTokenKey] = authToken
    }

    func clean() {
        try? keychain.removeAll()
    }

}
