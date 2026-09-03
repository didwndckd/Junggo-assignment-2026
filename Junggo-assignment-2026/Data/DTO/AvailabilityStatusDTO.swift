import Foundation

/// `availabilityStatus` 응답 DTO. API의 `"In Stock"`/`"Low Stock"`/`"Out of Stock"` 문자열과
/// Domain의 `AvailabilityStatus`를 양방향으로 매핑한다. `ProductListEndpoint`, `ProductDetailEndpoint` 양쪽에서 공유한다.
enum AvailabilityStatusDTO: String {
    case inStock = "In Stock"
    case lowStock = "Low Stock"
    case outOfStock = "Out of Stock"
}

extension AvailabilityStatusDTO: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        guard let value = AvailabilityStatusDTO(rawValue: raw) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unknown availabilityStatus value: \(raw)"
            )
        }
        self = value
    }

    func toDomain() -> AvailabilityStatus {
        switch self {
        case .inStock: return .inStock
        case .lowStock: return .lowStock
        case .outOfStock: return .outOfStock
        }
    }
}
