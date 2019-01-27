import Foundation

class MemoryProfileStorage: ProfileStorage {

    private var profile: Profile?

    func store(profile: Profile) {
        self.profile = profile
    }

    func restore() -> Profile? {
        return profile
    }

}
