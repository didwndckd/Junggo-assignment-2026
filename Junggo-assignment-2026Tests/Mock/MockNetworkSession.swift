import Foundation
@testable import Junggo_assignment_2026

/// `NetworkSession`의 테스트용 mock. 실제 네트워크 호출 없이 원하는 응답/에러를 주입할 수 있다.
/// `Data/Network` 뿐 아니라 이를 사용하는 모든 Repository Impl 테스트에서 재사용한다.
actor MockNetworkSession: NetworkSession {
    struct NotStubbed: Error {}

    private(set) var receivedRequests: [URLRequest] = []
    /// `data(for:)` 호출마다 앞에서부터 하나씩 소비되는 응답 큐. 초기화 시 미리 채워둘 수 있다.
    private var results: [Result<(Data, URLResponse), Error>]

    init(results: [Result<(Data, URLResponse), Error>] = []) {
        self.results = results
    }

    /// 큐 맨 뒤에 성공 응답을 추가한다.
    func stub(data: Data, response: URLResponse) {
        results.append(.success((data, response)))
    }

    /// `data`와 상태 코드로 손쉽게 `HTTPURLResponse` 성공 응답을 구성해 큐 맨 뒤에 추가한다.
    func stub(data: Data, statusCode: Int = 200, url: URL = URL(string: "https://dummyjson.com")!) {
        let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
        stub(data: data, response: response)
    }

    /// 큐 맨 뒤에 실패 응답을 추가한다.
    func stub(error: Error) {
        results.append(.failure(error))
    }

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        receivedRequests.append(request)
        guard !results.isEmpty else { throw NotStubbed() }
        let result = results.removeFirst()
        return try result.get()
    }
}
