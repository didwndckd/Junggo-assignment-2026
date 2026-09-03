import Foundation

struct ProductListEndpoint: Endpoint {
    var baseURL: URL { HostEnvironment.base }
    var path: String { "products" }
    var method: HTTPMethod { .get }
    /// 목록 화면에 필요한 필드만 요청해 응답 페이로드를 줄인다. `id`는 select 여부와 무관하게 항상 포함된다.
    var queryItems: [URLQueryItem] {
        [URLQueryItem(name: "select", value: "title,price,thumbnail,discountPercentage,rating,availabilityStatus,brand")]
    }
}

extension ProductListEndpoint {
    struct ResponseData: Decodable {
        let products: [ProductDTO]

        enum CodingKeys: String, CodingKey {
            case products
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.products = (try? container.decode([ProductDTO].self, forKey: .products)) ?? []
        }

        func toDomain() -> [Product] {
            products.compactMap { $0.toDomain() }
        }
    }
}

extension ProductListEndpoint {
    /// 상품 목록 조회용 DTO. `select` 쿼리로 요청한 축소된 필드셋만 디코딩한다.
    struct ProductDTO {
        let id: Int?
        let title: String
        let price: Double
        let thumbnail: String
        let discountPercentage: Double
        let rating: Double
        let availabilityStatus: AvailabilityStatusDTO?
        let brand: String
    }
}

extension ProductListEndpoint.ProductDTO: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case price
        case thumbnail
        case discountPercentage
        case rating
        case availabilityStatus
        case brand
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try? container.decode(Int.self, forKey: .id)
        self.title = (try? container.decode(String.self, forKey: .title)) ?? ""
        self.price = (try? container.decode(Double.self, forKey: .price)) ?? 0
        self.thumbnail = (try? container.decode(String.self, forKey: .thumbnail)) ?? ""
        self.discountPercentage = (try? container.decode(Double.self, forKey: .discountPercentage)) ?? 0
        self.rating = (try? container.decode(Double.self, forKey: .rating)) ?? 0
        self.availabilityStatus = try? container.decode(AvailabilityStatusDTO.self, forKey: .availabilityStatus)
        self.brand = (try? container.decode(String.self, forKey: .brand)) ?? ""
    }

    func toDomain() -> Product? {
        guard let id else { return nil }
        guard let status = availabilityStatus?.toDomain() else { return nil }
        guard let thumbnailURL = URL(string: thumbnail) else { return nil }

        return Product(
            id: id,
            title: title,
            price: ProductPrice(originalPrice: price, discountPercentage: discountPercentage),
            thumbnail: thumbnailURL,
            rating: rating,
            availabilityStatus: status,
            brand: brand
        )
    }
}
