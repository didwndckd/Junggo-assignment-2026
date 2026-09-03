import Foundation

final class ProductDetailRepositoryImpl: ProductDetailRepository, Sendable {
    private let apiClient: APIClient

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchProduct(id: Int) async throws -> ProductDetail {
        let response = try await apiClient.request(ProductDetailEndpoint(id: id))
        guard let product = response.data.toDomain() else {
            throw APIError.invalidData(response: response.response)
        }
        return product
    }
}
