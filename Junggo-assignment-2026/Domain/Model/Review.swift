import Foundation

/// 상품에 달린 리뷰 한 건. 목록/상세 응답 양쪽에서 공통으로 사용되는 하위 모델.
struct Review: Hashable, Sendable {
    /// 평점 (1~5)
    let rating: Int
    /// 리뷰 내용
    let comment: String
    /// 작성 일시
    let date: Date
    /// 작성자 이름
    let reviewerName: String
    /// 작성자 이메일
    let reviewerEmail: String
}
