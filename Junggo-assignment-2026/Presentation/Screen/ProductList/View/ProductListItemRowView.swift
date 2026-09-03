//
//  ProductListItemRowView.swift
//  Junggo-assignment-2026
//
//  Created by yjc on 9/4/26.
//

import SwiftUI

struct ProductListItemRowView: View {
    private let viewModel: ProductListItemViewModel

    init(viewModel: ProductListItemViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            thumbnailView
            infoView

            Spacer()

            wishButton
        }
        .frame(maxHeight: 80)
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.select()
        }
    }

    private var thumbnailView: some View {
        ProductThumbnailView(url: viewModel.product.thumbnail)
            .frame(width: 80)
    }

    private var infoView: some View {
        ProductInfoView(product: viewModel.product)
    }

    private var wishButton: some View {
        WishButton(isWished: viewModel.isWished) {
            await viewModel.toggleWish()
        }
        .frame(maxHeight: .infinity, alignment: .center)
    }
}

#if DEBUG
#Preview {
    ProductListItemRowView(
        viewModel: ProductListItemViewModel(
            router: Router(),
            wishlistManager: DummyWishlistManager(),
            product: Product(
                id: 1,
                title: "iPhone 13 Pro",
                price: ProductPrice(originalPrice: 999, discountPercentage: 10),
                thumbnail: URL(string: "https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/thumbnail.webp"),
                rating: 4.5,
                availabilityStatus: .inStock,
                brand: "Apple"
            )
        )
    )
    .padding()
}
#endif
