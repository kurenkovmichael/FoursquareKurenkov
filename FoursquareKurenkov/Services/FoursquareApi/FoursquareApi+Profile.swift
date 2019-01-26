import Foundation

struct Profile: Codable {
    let firstName: String
    let lastName: String?
    let bio: String?
    let contact: [String: String]
    let photo: FoursquareImageIdentifier?
}

extension FoursquareApi {

    func getProfile(completion: @escaping (ApiResult<Profile>) -> Void) {
        request(path: "users/self", completion: completion) { (response: FoursquareApi.ResponseUser) -> Profile? in
            return response.user
        }
    }

}
