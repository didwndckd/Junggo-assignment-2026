import Foundation
import Testing
@testable import Junggo_assignment_2026

struct ProductDetailRepositoryImplTests {
    @Test("fetchProduct는 성공 응답을 도메인 모델로 매핑한다")
    func fetchSuccess() async throws {
        let session = MockNetworkSession()
        await session.stub(data: Self.validProductJSONData)
        let repository = ProductDetailRepositoryImpl(apiClient: APIClient(session: session))

        let product = try await repository.fetchProduct(id: 1)

        #expect(product.id == 1)
        #expect(product.title == "Essence Mascara Lash Princess")
        #expect(product.brand == "Essence")
        #expect(product.availabilityStatus == .inStock)
    }

    @Test("fetchProduct는 필수값이 없으면 실패한다")
    func fetchInvalidData() async throws {
        let session = MockNetworkSession()
        await session.stub(data: Self.invalidProductJSONData)
        let repository = ProductDetailRepositoryImpl(apiClient: APIClient(session: session))

        await #expect(throws: APIError.self) {
            _ = try await repository.fetchProduct(id: 2)
        }
    }

    @Test("fetchProduct는 HTTP 에러 상태코드일 경우 실패한다")
    func fetchHTTPError() async throws {
        let session = MockNetworkSession()
        await session.stub(data: Data(), statusCode: 500)
        let repository = ProductDetailRepositoryImpl(apiClient: APIClient(session: session))

        await #expect(throws: APIError.self) {
            _ = try await repository.fetchProduct(id: 1)
        }
    }
}

private extension ProductDetailRepositoryImplTests {
    static let validProductJSONData = Data("""
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
    """.utf8)

    /// `availabilityStatus`가 없어 `toDomain()`이 nil을 반환해야 하는 무효 응답.
    static let invalidProductJSONData = Data("""
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
    """.utf8)
}
