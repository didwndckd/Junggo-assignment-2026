//
//  ProductInfoView.swift
//  Junggo-assignment-2026
//
//  Created by yjc on 9/4/26.
//

import SwiftUI

struct ProductInfoView: View {
    private let product: Product

    init(product: Product) {
        self.product = product
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if !product.brand.isEmpty {
                Text(product.brand)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text(product.title)
                .font(.subheadline)
                .lineLimit(2)

            priceView
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var priceView: some View {
        HStack(spacing: 6) {
            Text(product.price.discountedPrice, format: .currency(code: "USD"))
                .font(.callout.bold())

            if product.price.discountPercentage > 0 {
                Text(product.price.originalPrice, format: .currency(code: "USD"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .strikethrough()
            }
        }
    }
}

#if DEBUG
#Preview {
    ProductInfoView(
        product: Product(
            id: 1,
            title: "iPhone 13 Pro",
            price: ProductPrice(originalPrice: 999, discountPercentage: 10),
            thumbnail: nil,
            rating: 4.5,
            availabilityStatus: .inStock,
            brand: "Apple"
        )
    )
    .padding()
}
#endif
