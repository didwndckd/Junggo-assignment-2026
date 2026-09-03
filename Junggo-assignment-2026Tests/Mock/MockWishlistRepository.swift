import Foundation
@testable import Junggo_assignment_2026

/// `WishlistRepository`의 테스트용 mock. `WishlistRepositoryImpl`과 동일한 규칙(멱등 add/remove,
/// 순서 보존)을 메모리 배열로 흉내 낸다 — 결과를 미리 큐에 넣어둘 필요 없이 실제 시나리오처럼 동작한다.
actor MockWishlistRepository: WishlistRepository {
    private var productIDs: [Int]

    init(productIDs: [Int] = []) {
        self.productIDs = productIDs
    }

    func fetchWishlistProductIDs() async throws -> [Int] {
        productIDs
    }

    @discardableResult
    func add(productID: Int) async throws -> [Int] {
        guard !productIDs.contains(productID) else { return productIDs }
        productIDs.append(productID)
        return productIDs
    }

    @discardableResult
    func remove(productID: Int) async throws -> [Int] {
        guard let index = productIDs.firstIndex(of: productID) else { return productIDs }
        productIDs.remove(at: index)
        return productIDs
    }
}
