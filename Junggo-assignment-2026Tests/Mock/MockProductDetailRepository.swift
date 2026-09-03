import Foundation
@testable import Junggo_assignment_2026

/// `ProductDetailRepository`의 테스트용 mock. `fetchProduct(id:)` 호출마다 앞에서부터 하나씩 소비되는
/// 결과 큐를 `init(results:)`로 미리 채워두거나 `stub(...)`으로 추가할 수 있다.
actor MockProductDetailRepository: ProductDetailRepository {
    struct NotStubbed: Error {}

    private var results: [Result<ProductDetail, Error>]

    init(results: [Result<ProductDetail, Error>] = []) {
        self.results = results
    }

    func stub(product: ProductDetail) {
        results.append(.success(product))
    }

    func stub(error: Error) {
        results.append(.failure(error))
    }

    func fetchProduct(id: Int) async throws -> ProductDetail {
        guard !results.isEmpty else { throw NotStubbed() }
        let result = results.removeFirst()
        return try result.get()
    }
}
