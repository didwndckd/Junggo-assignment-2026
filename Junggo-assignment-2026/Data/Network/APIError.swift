import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed(underlying: any Error)
    case invalidResponse(URLResponse)
    case unacceptableStatusCode(response: HTTPURLResponse, data: Data)
    case decodingFailed(response: HTTPURLResponse, data: Data, underlying: any Error)
    /// 디코딩은 성공했지만 필수 값 누락 등으로 도메인 모델 변환에 실패한 경우.
    case invalidData(response: HTTPURLResponse)
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
        case .invalidData(let response):
            return response.statusCode
        }
    }
}
