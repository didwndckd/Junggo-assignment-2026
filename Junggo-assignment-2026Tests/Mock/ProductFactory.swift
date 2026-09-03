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
}
