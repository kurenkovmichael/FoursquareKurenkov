import Foundation

class UserDefaultsAuthorizationStorage: AuthorizationServiceStorage {

    private let userDefaults = UserDefaults()
    private let accessCodeKey = "AccessCode"
    private let authTokenKey = "AuthToken"

    func restoreAccessCode() -> String? {
        return userDefaults.string(forKey: accessCodeKey)
    }

    func storeAccessCode(_ accessCode: String?) {
        userDefaults.set(accessCode, forKey: accessCodeKey)
    }

    func restoreAuthToken() -> String? {
        return userDefaults.string(forKey: authTokenKey)
    }

    func storeAauthToken(_ aauthToken: String?) {
        userDefaults.set(aauthToken, forKey: authTokenKey)
    }

    func clean() {
        userDefaults.removeObject(forKey: accessCodeKey)
        userDefaults.removeObject(forKey: authTokenKey)
    }

}
