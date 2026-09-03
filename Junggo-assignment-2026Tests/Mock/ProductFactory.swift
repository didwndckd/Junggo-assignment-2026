import Foundation
@testable import Junggo_assignment_2026

enum ProductFactory {
    static func make(id: Int) -> Product {
        Product(
            id: id,
            title: "title",
            price: ProductPrice(originalPrice: 100, discountPercentage: 0),
            thumbnail: URL(string: "https://example.com")!,
            rating: 4.5,
            availabilityStatus: .inStock,
            brand: "brand"
        )
    }

    static func makeDetail(id: Int) -> ProductDetail {
        ProductDetail(
            id: id,
            title: "title",
            description: "description",
            category: "category",
            price: ProductPrice(originalPrice: 100, discountPercentage: 0),
            rating: 4.5,
            stock: 10,
            tags: ["tag"],
            brand: "brand",
            sku: "sku",
            weight: 1,
            dimensions: ProductDimensions(width: 1, height: 1, depth: 1),
            warrantyInformation: "warranty",
            shippingInformation: "shipping",
            availabilityStatus: .inStock,
            reviews: [],
            returnPolicy: "returnPolicy",
            minimumOrderQuantity: 1,
            meta: ProductMeta(
                createdAt: Date(timeIntervalSince1970: 0),
                updatedAt: Date(timeIntervalSince1970: 0),
                barcode: "barcode",
                qrCode: URL(string: "https://example.com")!
            ),
            images: [URL(string: "https://example.com")!]
        )
    }
}
