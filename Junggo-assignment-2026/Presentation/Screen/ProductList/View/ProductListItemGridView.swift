//
//  ProductListItemGridView.swift
//  Junggo-assignment-2026
//
//  Created by yjc on 9/4/26.
//

import SwiftUI

struct ProductListItemGridView: View {
    private let viewModel: ProductListItemViewModel

    init(viewModel: ProductListItemViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            thumbnailView
            infoView
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.select()
        }
    }

    private var thumbnailView: some View {
        ProductThumbnailView(url: viewModel.product.thumbnail)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .topTrailing) {
                wishButton
                    .padding(6)
            }
    }

    private var infoView: some View {
        ProductInfoView(product: viewModel.product)
    }

    private var wishButton: some View {
        WishButton(isWished: viewModel.isWished) {
            await viewModel.toggleWish()
        }
    }
}

#if DEBUG
#Preview {
    HStack(alignment: .top, spacing: 12) {
        ProductListItemGridView(
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

        ProductListItemGridView(
            viewModel: ProductListItemViewModel(
                router: Router(),
                wishlistManager: DummyWishlistManager(wishedIDs: [2]),
                product: Product(
                    id: 2,
                    title: "썸네일 없는 상품",
                    price: ProductPrice(originalPrice: 49.99, discountPercentage: 0),
                    thumbnail: nil,
                    rating: 3.2,
                    availabilityStatus: .lowStock,
                    brand: ""
                )
            )
        )
    }
    .padding()
}
#endif
