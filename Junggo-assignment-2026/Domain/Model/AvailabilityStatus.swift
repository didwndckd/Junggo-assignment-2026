import Foundation

/// 상품 재고 상태. API의 "In Stock"/"Low Stock"/"Out of Stock" 문자열을 Data 레이어에서 매핑한다.
enum AvailabilityStatus: Hashable, Sendable {
    /// 재고 있음
    case inStock
    /// 재고 부족
    case lowStock
    /// 재고 없음
    case outOfStock
}
