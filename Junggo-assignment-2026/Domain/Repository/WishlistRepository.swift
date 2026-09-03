import Foundation

/// 찜 상태를 로컬에 영속화하는 Repository. 구현체는 Data 레이어에 둔다.
protocol WishlistRepository: Sendable {
    /// 상품을 찜 목록에 추가한다. 이미 찜한 상품이면 아무 동작도 하지 않는다.
    func add(productID: Int) async throws
    /// 상품을 찜 목록에서 제거한다. 찜하지 않은 상품이면 아무 동작도 하지 않는다.
    func remove(productID: Int) async throws
    /// 찜한 상품 ID 전체를 조회한다.
    func fetchWishlistProductIDs() async throws -> Set<Int>
}
