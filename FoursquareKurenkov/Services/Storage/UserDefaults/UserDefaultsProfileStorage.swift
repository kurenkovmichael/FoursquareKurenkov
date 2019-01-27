import Foundation

class UserDefaultsProfileStorage: ProfileStorage {

    private let userDefaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let key = "Profile"

    func store(profile: Profile) {
        if let encoded = try? encoder.encode(profile) {
            userDefaults.setValue(encoded, forKey: key)
        }
    }

    func restore() -> Profile? {
        if let data = userDefaults.data(forKey: key),
            let person = try? decoder.decode(Profile.self, from: data) {
            return person
        }
        return  nil
    }

}
