import Foundation

extension FoursquareApi {

    struct Response<Data: Codable>: Codable {
        let meta: Meta
        let response: Data?
    }

    struct Meta: Codable {
        let code: Int
        let errorDetail: String?
        let errorType: String?
    }

    struct ResponseUser: Codable {
        let user: Profile?
    }

}
