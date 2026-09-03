import Foundation

/// 상품 메타 정보 (생성/수정 일시, 바코드, QR 코드).
struct ProductMeta: Hashable, Sendable {
    /// 최초 생성 일시
    let createdAt: Date
    /// 마지막 수정 일시
    let updatedAt: Date
    /// 바코드 번호
    let barcode: String
    /// QR 코드 이미지 URL
    let qrCode: URL
}
