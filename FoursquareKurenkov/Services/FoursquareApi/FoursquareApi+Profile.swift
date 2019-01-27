import Foundation

struct ResponseUser: Codable {
    let user: Profile?
}

extension FoursquareApi {

    func getProfile(completion: @escaping (ApiResult<Profile>) -> Void) {
        request(path: "users/self", completion: completion) { (response: ResponseUser) -> Profile? in
            return response.user
        }
    }

}
