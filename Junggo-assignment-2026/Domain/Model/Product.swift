import Foundation

/// 상품 목록 조회용 도메인 엔티티. 목록 화면에 필요한 필드만 담아 불필요한 메모리 사용을 줄인다.
/// 상세 화면에 필요한 전체 정보는 `ProductDetail`을 사용한다.
struct Product: Hashable, Sendable {
    /// 상품 고유 ID
    let id: Int
    /// 상품명
    let title: String
    /// 가격 정보 (정가, 할인율, 할인된 금액)
    let price: ProductPrice
    /// 썸네일 이미지 URL
    let thumbnail: URL
    /// 평균 평점 (0~5)
    let rating: Double
    /// 재고 상태 (재고 있음/부족/없음)
    let availabilityStatus: AvailabilityStatus
    /// 브랜드명. groceries 등 일부 카테고리는 API 응답에 없어 빈 문자열일 수 있다. 표시 시 empty 체크 필요
    let brand: String
}
