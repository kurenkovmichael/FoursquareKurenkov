import Foundation

extension FoursquareApi {

    func getProfile(completion: @escaping (ApiResult<Profile>) -> Void) {
        request(path: "users/self", completion: completion) { (response: FoursquareApi.ResponseUser) -> Profile? in
            return response.user
        }
    }

}
