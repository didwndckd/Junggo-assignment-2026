import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed(underlying: any Error)
    case invalidResponse(URLResponse)
    case unacceptableStatusCode(response: HTTPURLResponse, data: Data)
    case decodingFailed(response: HTTPURLResponse, data: Data, underlying: any Error)
}

extension APIError {
    var statusCode: Int? {
        switch self {
        case .invalidURL, .requestFailed, .invalidResponse:
            return nil
        case .unacceptableStatusCode(let response, _):
            return response.statusCode
        case .decodingFailed(let response, _, _):
            return response.statusCode
        }
    }
}
