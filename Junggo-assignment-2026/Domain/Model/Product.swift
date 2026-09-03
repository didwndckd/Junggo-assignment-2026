import Foundation

/// 상품 도메인 엔티티. 목록/상세 API 응답이 동일한 스키마를 가져 하나의 모델로 통합했다.
struct Product: Hashable, Sendable {
    /// 상품 고유 ID
    let id: Int
    /// 상품명
    let title: String
    /// 상품 설명
    let description: String
    /// 카테고리 (예: beauty, fragrances, furniture, groceries)
    let category: String
    /// 정가
    let price: Double
    /// 할인율(%)
    let discountPercentage: Double
    /// 평균 평점 (0~5)
    let rating: Double
    /// 재고 수량
    let stock: Int
    /// 검색/분류용 태그 목록
    let tags: [String]
    /// 브랜드명. groceries 등 일부 카테고리는 API 응답에 없어 옵셔널로 처리
    let brand: String?
    /// 재고관리코드
    let sku: String
    /// 무게
    let weight: Double
    /// 가로/세로/깊이 치수
    let dimensions: ProductDimensions
    /// 보증 정보 (예: "1 year warranty")
    let warrantyInformation: String
    /// 배송 정보 (예: "Ships in 3-5 business days")
    let shippingInformation: String
    /// 재고 상태 (재고 있음/부족/없음)
    let availabilityStatus: AvailabilityStatus
    /// 사용자 리뷰 목록
    let reviews: [Review]
    /// 반품 정책 (예: "No return policy")
    let returnPolicy: String
    /// 최소 주문 수량
    let minimumOrderQuantity: Int
    /// 생성/수정 일시, 바코드, QR 코드 등 메타 정보
    let meta: ProductMeta
    /// 상품 이미지 URL 목록
    let images: [URL]
    /// 썸네일 이미지 URL
    let thumbnail: URL
}
