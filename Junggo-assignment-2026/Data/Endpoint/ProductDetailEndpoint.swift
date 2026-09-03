import Foundation

/// 상품 상세 조회 (GET /products/{id}).
///
/// 목록 API의 개별 아이템과 응답 스키마가 완전히 동일하므로(docs/specs/references/dummyjson-products-api.md 참고)
/// 별도의 DTO를 새로 정의하지 않고 `Data/DTO/ProductDTO.swift`의 `ProductDTO`를 그대로 재사용한다.
struct ProductDetailEndpoint: Endpoint {
    typealias ResponseData = ProductDTO

    let id: Int

    var baseURL: URL { HostEnvironment.base }
    var path: String { "products/\(id)" }
    var method: HTTPMethod { .get }
}
