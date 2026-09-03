//
//  ProductListView.swift
//  Junggo-assignment-2026
//
//  Created by yjc on 9/4/26.
//

import SwiftUI

struct ProductListView: View {
    private let viewModel: ProductListViewModel

    @State private var columnCount = 1
    @State private var refreshing = false

    init(viewModel: ProductListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            switch viewModel.state {
            case .initial: EmptyView()
            case .loaded, .empty: content
            case .error: errorView
            }

            if viewModel.isLoading && !refreshing {
                loadingProgress
            }
        }
        .navigationTitle("상품 목록")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                columnToggleButton
            }
        }
        .task {
            await viewModel.load()
        }
    }
    
    private var loadingProgress: some View {
        ProgressView()
    }
    
    private var emptyView: some View {
        EmptyStateView(message: "표시할 상품이 없어요")
            .frame(maxWidth: .infinity)
            .padding(.top, 200)
    }

    private var errorView: some View {
        ErrorStateView(message: "상품을 불러오지 못했어요") {
            await viewModel.load()
        }
        .frame(maxWidth: .infinity)
    }

    private var content: some View {
        ScrollView {
            if viewModel.state == .empty {
                emptyView
            } else {
                itemGrid
            }
        }
        .refreshable {
            refreshing = true
            await viewModel.load()
            refreshing = false
        }
    }

    private var itemGrid: some View {
        LazyVGrid(columns: gridColumns, spacing: 16) {
            ForEach(viewModel.items) { item in
                itemView(for: item)
            }
        }
        .padding(16)
    }

    private var gridColumns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 16), count: columnCount)
    }

    @ViewBuilder
    private func itemView(for item: ProductListItemViewModel) -> some View {
        if columnCount == 1 {
            ProductListItemRowView(viewModel: item)
        } else {
            ProductListItemGridView(viewModel: item)
        }
    }

    private var columnToggleButton: some View {
        Button {
            columnCount = columnCount == 1 ? 2 : 1
        } label: {
            Image(systemName: columnCount == 1 ? "square.grid.2x2" : "list.bullet")
        }
    }
}

#if DEBUG
#Preview {
    let products = [
        Product(
            id: 1,
            title: "iPhone 13 Pro",
            price: ProductPrice(originalPrice: 999, discountPercentage: 10),
            thumbnail: URL(string: "https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/thumbnail.webp"),
            rating: 4.5,
            availabilityStatus: .inStock,
            brand: "Apple"
        ),
        Product(
            id: 2,
            title: "썸네일 없는 상품",
            price: ProductPrice(originalPrice: 49.99, discountPercentage: 0),
            thumbnail: nil,
            rating: 3.2,
            availabilityStatus: .lowStock,
            brand: ""
        ),
        Product(
            id: 3,
            title: "제목이 아주 길어서 두 줄까지 꽉 차는 상품입니다",
            price: ProductPrice(originalPrice: 129.99, discountPercentage: 20),
            thumbnail: URL(string: "https://cdn.dummyjson.com/product-images/fragrances/calvin-klein-ck-one/thumbnail.webp"),
            rating: 4.1,
            availabilityStatus: .inStock,
            brand: "Calvin Klein"
        ),
        Product(
            id: 4,
            title: "짧은 제목",
            price: ProductPrice(originalPrice: 19.99, discountPercentage: 0),
            thumbnail: URL(string: "https://cdn.dummyjson.com/product-images/groceries/apple/thumbnail.webp"),
            rating: 4.8,
            availabilityStatus: .inStock,
            brand: "Fresh"
        ),
        Product(
            id: 5,
            title: "품절된 상품",
            price: ProductPrice(originalPrice: 299.99, discountPercentage: 5),
            thumbnail: URL(string: "https://cdn.dummyjson.com/product-images/furniture/annibale-colombo-bed/thumbnail.webp"),
            rating: 2.9,
            availabilityStatus: .outOfStock,
            brand: "Annibale Colombo"
        )
    ]
    NavigationStack {
        ProductListView(
            viewModel: ProductListViewModel(
                router: Router(),
                repository: DummyProductListRepository(products: products),
                wishlistManager: DummyWishlistManager()
            )
        )
    }
}
#endif
