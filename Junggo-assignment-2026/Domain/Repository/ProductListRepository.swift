import Foundation

/// 상품 목록 조회를 담당하는 Repository. 구현체는 Data 레이어에 둔다.
protocol ProductListRepository: Sendable {
    /// 전체 상품 목록을 조회한다. (페이징 없이 한 번에 조회)
    func fetchProducts() async throws -> [Product]
}
