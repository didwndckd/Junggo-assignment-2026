import Foundation

/// 상품 상세 조회 (GET /products/{id}). 상세 화면에 필요한 전체 필드를 응답받으므로
/// `select` 파라미터 없이 전체 스키마를 디코딩한다.
struct ProductDetailEndpoint: Endpoint {
    let id: Int

    var baseURL: URL { HostEnvironment.base }
    var path: String { "products/\(id)" }
    var method: HTTPMethod { .get }
}

extension ProductDetailEndpoint {
    struct ResponseData {
        let id: Int?
        let title: String
        let description: String
        let category: String
        let price: Double
        let discountPercentage: Double
        let rating: Double
        let stock: Int
        let tags: [String]
        let brand: String
        let sku: String
        let weight: Double
        let dimensions: DimensionsDTO
        let warrantyInformation: String
        let shippingInformation: String
        let availabilityStatus: AvailabilityStatusDTO?
        let reviews: [ReviewDTO]
        let returnPolicy: String
        let minimumOrderQuantity: Int
        let meta: MetaDTO
        let images: [String]
        let thumbnail: String
    }
}

extension ProductDetailEndpoint.ResponseData: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case category
        case price
        case discountPercentage
        case rating
        case stock
        case tags
        case brand
        case sku
        case weight
        case dimensions
        case warrantyInformation
        case shippingInformation
        case availabilityStatus
        case reviews
        case returnPolicy
        case minimumOrderQuantity
        case meta
        case images
        case thumbnail
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try? container.decode(Int.self, forKey: .id)
        self.title = (try? container.decode(String.self, forKey: .title)) ?? ""
        self.description = (try? container.decode(String.self, forKey: .description)) ?? ""
        self.category = (try? container.decode(String.self, forKey: .category)) ?? ""
        self.price = (try? container.decode(Double.self, forKey: .price)) ?? 0
        self.discountPercentage = (try? container.decode(Double.self, forKey: .discountPercentage)) ?? 0
        self.rating = (try? container.decode(Double.self, forKey: .rating)) ?? 0
        self.stock = (try? container.decode(Int.self, forKey: .stock)) ?? 0
        self.tags = (try? container.decode([String].self, forKey: .tags)) ?? []
        self.brand = (try? container.decode(String.self, forKey: .brand)) ?? ""
        self.sku = (try? container.decode(String.self, forKey: .sku)) ?? ""
        self.weight = (try? container.decode(Double.self, forKey: .weight)) ?? 0
        self.dimensions = (try? container.decode(DimensionsDTO.self, forKey: .dimensions)) ?? DimensionsDTO(width: 0, height: 0, depth: 0)
        self.warrantyInformation = (try? container.decode(String.self, forKey: .warrantyInformation)) ?? ""
        self.shippingInformation = (try? container.decode(String.self, forKey: .shippingInformation)) ?? ""
        self.availabilityStatus = try? container.decode(AvailabilityStatusDTO.self, forKey: .availabilityStatus)
        self.reviews = (try? container.decode([ReviewDTO].self, forKey: .reviews)) ?? []
        self.returnPolicy = (try? container.decode(String.self, forKey: .returnPolicy)) ?? ""
        self.minimumOrderQuantity = (try? container.decode(Int.self, forKey: .minimumOrderQuantity)) ?? 0
        self.meta = (try? container.decode(MetaDTO.self, forKey: .meta)) ?? MetaDTO(createdAt: "", updatedAt: "", barcode: "", qrCode: "")
        self.images = (try? container.decode([String].self, forKey: .images)) ?? []
        self.thumbnail = (try? container.decode(String.self, forKey: .thumbnail)) ?? ""
    }

    func toDomain() -> ProductDetail? {
        guard let id else { return nil }
        guard let status = availabilityStatus?.toDomain() else { return nil }
        guard let domainMeta = meta.toDomain() else { return nil }
        guard let thumbnailURL = URL(string: thumbnail) else { return nil }

        return ProductDetail(
            id: id,
            title: title,
            description: description,
            category: category,
            price: ProductPrice(originalPrice: price, discountPercentage: discountPercentage),
            rating: rating,
            stock: stock,
            tags: tags,
            brand: brand,
            sku: sku,
            weight: weight,
            dimensions: dimensions.toDomain(),
            warrantyInformation: warrantyInformation,
            shippingInformation: shippingInformation,
            availabilityStatus: status,
            reviews: reviews.compactMap { $0.toDomain() },
            returnPolicy: returnPolicy,
            minimumOrderQuantity: minimumOrderQuantity,
            meta: domainMeta,
            images: images.compactMap { URL(string: $0) },
            thumbnail: thumbnailURL
        )
    }
}

extension ProductDetailEndpoint.ResponseData {
    struct DimensionsDTO {
        let width: Double
        let height: Double
        let depth: Double
    }
}

extension ProductDetailEndpoint.ResponseData.DimensionsDTO: Decodable {
    enum CodingKeys: String, CodingKey {
        case width
        case height
        case depth
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.width = (try? container.decode(Double.self, forKey: .width)) ?? 0
        self.height = (try? container.decode(Double.self, forKey: .height)) ?? 0
        self.depth = (try? container.decode(Double.self, forKey: .depth)) ?? 0
    }

    func toDomain() -> ProductDimensions {
        ProductDimensions(width: width, height: height, depth: depth)
    }
}

extension ProductDetailEndpoint.ResponseData {
    struct MetaDTO {
        let createdAt: String
        let updatedAt: String
        let barcode: String
        let qrCode: String
    }
}

extension ProductDetailEndpoint.ResponseData.MetaDTO: Decodable {
    enum CodingKeys: String, CodingKey {
        case createdAt
        case updatedAt
        case barcode
        case qrCode
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.createdAt = (try? container.decode(String.self, forKey: .createdAt)) ?? ""
        self.updatedAt = (try? container.decode(String.self, forKey: .updatedAt)) ?? ""
        self.barcode = (try? container.decode(String.self, forKey: .barcode)) ?? ""
        self.qrCode = (try? container.decode(String.self, forKey: .qrCode)) ?? ""
    }

    func toDomain() -> ProductMeta? {
        guard
            let createdAtDate = DateFormatter.iso8601.date(from: createdAt),
            let updatedAtDate = DateFormatter.iso8601.date(from: updatedAt),
            let qrCodeURL = URL(string: qrCode)
        else { return nil }
        return ProductMeta(createdAt: createdAtDate, updatedAt: updatedAtDate, barcode: barcode, qrCode: qrCodeURL)
    }
}

extension ProductDetailEndpoint.ResponseData {
    struct ReviewDTO {
        let rating: Int
        let comment: String
        let date: String
        let reviewerName: String
        let reviewerEmail: String
    }
}

extension ProductDetailEndpoint.ResponseData.ReviewDTO: Decodable {
    enum CodingKeys: String, CodingKey {
        case rating
        case comment
        case date
        case reviewerName
        case reviewerEmail
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rating = (try? container.decode(Int.self, forKey: .rating)) ?? 0
        self.comment = (try? container.decode(String.self, forKey: .comment)) ?? ""
        self.date = (try? container.decode(String.self, forKey: .date)) ?? ""
        self.reviewerName = (try? container.decode(String.self, forKey: .reviewerName)) ?? ""
        self.reviewerEmail = (try? container.decode(String.self, forKey: .reviewerEmail)) ?? ""
    }

    func toDomain() -> Review? {
        guard let parsedDate = DateFormatter.iso8601.date(from: date) else { return nil }
        return Review(rating: rating, comment: comment, date: parsedDate, reviewerName: reviewerName, reviewerEmail: reviewerEmail)
    }
}
