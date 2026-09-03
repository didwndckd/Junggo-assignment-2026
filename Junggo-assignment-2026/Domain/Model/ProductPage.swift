import Foundation

/// 상품 목록 API 응답의 페이징 정보를 감싸는 래퍼.
struct ProductPage: Hashable, Sendable {
    /// 이번 페이지에 포함된 상품 목록
    let products: [Product]
    /// 전체 상품 개수
    let total: Int
    /// 건너뛴 개수 (offset)
    let skip: Int
    /// 페이지당 개수
    let limit: Int
}
