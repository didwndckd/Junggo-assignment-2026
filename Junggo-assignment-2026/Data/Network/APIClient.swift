import Foundation

final class APIClient: Sendable {
    let session: NetworkSession
    let decoder: JSONDecoder

    init(
        session: NetworkSession = URLSession.shared,
        decoder: JSONDecoder = .init()
    ) {
        self.session = session
        self.decoder = decoder
    }

    func request(_ request: URLRequest) async throws(APIError) -> (Data, HTTPURLResponse) {
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIError.requestFailed(underlying: error)
        }
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse(response)
        }
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw APIError.unacceptableStatusCode(response: httpResponse, data: data)
        }
        return (data, httpResponse)
    }

    func request<E: Endpoint>(_ endpoint: E) async throws(APIError) -> APIResponse<E.ResponseData> where E.ResponseData: Decodable {
        let (data, response) = try await request(endpoint.urlRequest())
        do {
            let decoded = try decoder.decode(E.ResponseData.self, from: data)
            return APIResponse(response: response, data: decoded)
        } catch {
            throw APIError.decodingFailed(response: response, data: data, underlying: error)
        }
    }

    func request<E: Endpoint>(_ endpoint: E) async throws(APIError) -> APIResponse<Void> where E.ResponseData == Void {
        let (_, response) = try await request(endpoint.urlRequest())
        return APIResponse(response: response, data: ())
    }
}
