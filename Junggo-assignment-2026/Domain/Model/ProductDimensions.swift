import Foundation

/// 상품의 물리적 치수 (단위는 API 기준, 별도 단위 표기 없음).
struct ProductDimensions: Hashable, Sendable {
    /// 가로
    let width: Double
    /// 세로
    let height: Double
    /// 깊이
    let depth: Double
}
