import Foundation
import Testing
@testable import Junggo_assignment_2026

struct ProductListRepositoryImplTests {
    @Test("fetchProducts는 성공 응답을 도메인 모델로 매핑한다")
    func fetchSuccess() async throws {
        let session = MockNetworkSession()
        await session.stub(data: Self.validListResponseJSON)
        let repository = ProductListRepositoryImpl(apiClient: APIClient(session: session))

        let products = try await repository.fetchProducts()

        #expect(products.count == 1)
        let product = try #require(products.first)
        #expect(product.id == 1)
        #expect(product.title == "Essence Mascara Lash Princess")
        #expect(product.brand == "Essence")
        #expect(product.availabilityStatus == .inStock)
    }

    @Test("fetchProducts는 필수값이 없는 항목을 결과에서 제외한다")
    func fetchFiltersInvalidItems() async throws {
        let session = MockNetworkSession()
        await session.stub(data: Self.mixedValidityListResponseJSON)
        let repository = ProductListRepositoryImpl(apiClient: APIClient(session: session))

        let products = try await repository.fetchProducts()

        #expect(products.count == 1)
        #expect(products.first?.id == 1)
    }

    @Test("fetchProducts는 HTTP 에러 상태코드일 경우 실패한다")
    func fetchHTTPError() async throws {
        let session = MockNetworkSession()
        await session.stub(data: Data(), statusCode: 500)
        let repository = ProductListRepositoryImpl(apiClient: APIClient(session: session))

        await #expect(throws: APIError.self) {
            _ = try await repository.fetchProducts()
        }
    }
}

private extension ProductListRepositoryImplTests {
    static let validProductJSON = """
    {
      "id": 1,
      "title": "Essence Mascara Lash Princess",
      "description": "The Essence Mascara Lash Princess is a popular mascara.",
      "category": "beauty",
      "price": 9.99,
      "discountPercentage": 10.48,
      "rating": 2.56,
      "stock": 99,
      "tags": ["beauty", "mascara"],
      "brand": "Essence",
      "sku": "BEA-ESS-ESS-001",
      "weight": 4,
      "dimensions": { "width": 15.14, "height": 13.08, "depth": 22.99 },
      "warrantyInformation": "1 week warranty",
      "shippingInformation": "Ships in 3-5 business days",
      "availabilityStatus": "In Stock",
      "reviews": [],
      "returnPolicy": "No return policy",
      "minimumOrderQuantity": 48,
      "meta": {
        "createdAt": "2025-04-30T09:41:02.053Z",
        "updatedAt": "2025-04-30T09:41:02.053Z",
        "barcode": "5784719087687",
        "qrCode": "https://cdn.dummyjson.com/public/qr-code.png"
      },
      "images": ["https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/1.webp"],
      "thumbnail": "https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/thumbnail.webp"
    }
    """

    /// `availabilityStatus`가 없어 `toDomain()`이 nil을 반환해야 하는 무효 항목.
    static let invalidProductJSONMissingAvailabilityStatus = """
    {
      "id": 2,
      "title": "Invalid Product",
      "description": "",
      "category": "beauty",
      "price": 1,
      "discountPercentage": 0,
      "rating": 0,
      "stock": 0,
      "tags": [],
      "sku": "",
      "weight": 0,
      "dimensions": { "width": 0, "height": 0, "depth": 0 },
      "warrantyInformation": "",
      "shippingInformation": "",
      "reviews": [],
      "returnPolicy": "",
      "minimumOrderQuantity": 0,
      "meta": {
        "createdAt": "2025-04-30T09:41:02.053Z",
        "updatedAt": "2025-04-30T09:41:02.053Z",
        "barcode": "",
        "qrCode": "https://cdn.dummyjson.com/public/qr-code.png"
      },
      "images": [],
      "thumbnail": "https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/thumbnail.webp"
    }
    """

    static var validListResponseJSON: Data {
        Data("""
        { "products": [\(validProductJSON)], "total": 1, "skip": 0, "limit": 30 }
        """.utf8)
    }

    static var mixedValidityListResponseJSON: Data {
        Data("""
        {
          "products": [\(validProductJSON), \(invalidProductJSONMissingAvailabilityStatus)],
          "total": 2,
          "skip": 0,
          "limit": 30
        }
        """.utf8)
    }
}
