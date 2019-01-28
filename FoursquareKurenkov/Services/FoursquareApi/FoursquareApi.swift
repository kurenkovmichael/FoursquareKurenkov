import Foundation
import Alamofire

enum ApiError: Error {
    case networkError(parent: Error?)
    case invalidResponse
    case authorizationError
}

enum ApiResult<T> {
    case success(response: T)
    case fail(error: ApiError?)
}

protocol AuthTokenProvider {
    var authToken: String? { get }
}

protocol ApiErrorHandler {
    func handle(error: ApiError?)
}

class FoursquareApi {

    private let authTokenProvider: AuthTokenProvider
    private let errorHandlers: [ApiErrorHandler]
    private let baseUrl = "https://api.foursquare.com/v2/"
    private let apiVersion = "20190120"
    private let locate = "en"

    init(authTokenProvider: AuthTokenProvider, errorHandlers: [ApiErrorHandler]) {
        self.authTokenProvider = authTokenProvider
        self.errorHandlers = errorHandlers
    }

    enum Method {
        case get, post
    }

    func request<Response, Result>(path: String,
                                   method: Method = .get,
                                   parameters: [String: Any] = [:],
                                   completion: @escaping (ApiResult<Result>) -> Void,
                                   resultConverter: @escaping FoursquareApiParser<Response, Result>.ResultConverter)
        where Response: Codable {
        request(path: path,
                method: method,
                parameters: parameters,
                parser: FoursquareApiParser<Response, Result>(resultConverter: resultConverter),
                completion: completion)
    }

    func request<Response, Result>(path: String,
                                   method: Method,
                                   parameters additionalParameters: [String: Any],
                                   parser: FoursquareApiParser<Response, Result>,
                                   completion: @escaping (ApiResult<Result>) -> Void)
        where Response: Codable {
            guard let url = makeUrl(path: path) else {
                return
            }

            let requestCompletion = { [self] (response: DefaultDataResponse) in
                let result = parser.parse(response: response)

                switch result {
                case .fail(let error):
                    for errorHandler in self.errorHandlers {
                        errorHandler.handle(error: error)
                    }
                default:
                    break
                }

                completion(result)
            }

            var parameters = defaultParameters()
            for (key, value) in additionalParameters {
                parameters[key] = value
            }

            Alamofire.request(url,
                              method: conver(method: method),
                              parameters: parameters,
                              encoding: URLEncoding.default,
                              headers: nil)
                .response(completionHandler: requestCompletion)
    }

    // MARK: - Private

    private func makeUrl(path: String) -> URL? {
        var url = URL(string: self.baseUrl)
        url?.appendPathComponent(path)
        return url
    }

    private func defaultParameters() -> [String: Any] {
        var parameters = Parameters()
        if let authToken = authTokenProvider.authToken {
            parameters["oauth_token"] = authToken
        }
        parameters["v"] = apiVersion
        parameters["locale"] = locate
        return parameters
    }

    private func conver(method: Method) -> HTTPMethod {
        switch method {
        case .post:
            return HTTPMethod.post
        default:
            return HTTPMethod.get
        }
    }
}
