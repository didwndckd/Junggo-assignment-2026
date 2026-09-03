import Foundation

/// 단일 상품 상세 조회를 담당하는 Repository. 구현체는 Data 레이어에 둔다.
protocol ProductDetailRepository: Sendable {
    /// 상품 ID로 상세 정보를 조회한다.
    func fetchProduct(id: Int) async throws -> Product
}
