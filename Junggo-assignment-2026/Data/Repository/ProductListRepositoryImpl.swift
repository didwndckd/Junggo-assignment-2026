import Foundation

final class ProductListRepositoryImpl: ProductListRepository, Sendable {
    private let apiClient: APIClient

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchProducts() async throws -> [Product] {
        let response = try await apiClient.request(ProductListEndpoint())
        return response.data.toDomain()
    }
}
