import Foundation
@testable import Junggo_assignment_2026

/// `ProductListRepository`의 테스트용 mock. `fetchProducts()` 호출마다 앞에서부터 하나씩 소비되는
/// 결과 큐를 `init(results:)`로 미리 채워두거나 `stub(...)`으로 추가할 수 있다.
actor MockProductListRepository: ProductListRepository {
    struct NotStubbed: Error {}

    private var results: [Result<[Product], Error>]

    init(results: [Result<[Product], Error>] = []) {
        self.results = results
    }

    func stub(products: [Product]) {
        results.append(.success(products))
    }

    func stub(error: Error) {
        results.append(.failure(error))
    }

    func fetchProducts() async throws -> [Product] {
        guard !results.isEmpty else { throw NotStubbed() }
        let result = results.removeFirst()
        return try result.get()
    }
}
