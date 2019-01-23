import Foundation
import Alamofire

class FoursquareApiParser<ResponseType: Codable, ResultType> {

    public typealias ResultConverter = (ResponseType) -> ResultType?
    private let resultConverter: ResultConverter

    init(resultConverter: @escaping ResultConverter) {
        self.resultConverter = resultConverter
    }

    func parse(response: DefaultDataResponse) -> ApiResult<ResultType> {

        if let error = error(fromNetworkError: response.error) {
            return .fail(error: error)
        }

        guard let decodedResponse = decode(from: response.data) else {
            return .fail(error: .invalidResponse)
        }

        if let error = error(fromResponseMeta: decodedResponse.meta) {
            return .fail(error: error)
        }

        guard let response = decodedResponse.response,
            let result = resultConverter(response) else {
                return .fail(error: .invalidResponse)
        }

        return .success(response: result)
    }

    private func error(fromNetworkError error: Error?) -> ApiError? {
        guard let networkError = error else {
            return nil
        }

        return .networkError(parent: networkError)
    }

    private func error(fromResponseMeta meta: FoursquareApi.Meta?) -> ApiError? {
        if let code = meta?.code,
            code == 200 {
            return nil

        } else if let errorType = meta?.errorType,
            errorType == "invalid_auth" {
            return .authorizationError

        } else {
            return .invalidResponse
        }
    }

    private func decode(from data: Data?) -> FoursquareApi.Response<ResponseType>? {
        guard let data = data else {
            return nil
        }

        do {
            return try JSONDecoder().decode(FoursquareApi.Response<ResponseType>.self, from: data)
        } catch {
            return nil
        }
    }
}
