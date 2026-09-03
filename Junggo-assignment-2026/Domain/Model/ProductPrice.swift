import Foundation

/// 상품 가격 도메인 모델. 정가와 할인율을 바탕으로 할인된 금액을 계산한다.
struct ProductPrice: Hashable, Sendable {
    /// 정가
    let originalPrice: Double
    /// 할인율(%)
    let discountPercentage: Double

    /// 할인이 적용된 금액
    var discountedPrice: Double {
        originalPrice * (1 - discountPercentage / 100)
    }
}
