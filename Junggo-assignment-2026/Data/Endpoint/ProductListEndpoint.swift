import Foundation

struct ProductListEndpoint: Endpoint {
    typealias ResponseData = Response

    var baseURL: URL { HostEnvironment.base }
    var path: String { "products" }
    var method: HTTPMethod { .get }
}

extension ProductListEndpoint {
    struct Response: Decodable {
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
