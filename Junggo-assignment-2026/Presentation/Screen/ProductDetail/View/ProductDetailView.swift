//
//  ProductDetailView.swift
//  Junggo-assignment-2026
//
//  Created by yjc on 9/4/26.
//

import Kingfisher
import SwiftUI

struct ProductDetailView: View {
    private let viewModel: ProductDetailViewModel

    @State private var refreshing = false

    init(viewModel: ProductDetailViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            switch viewModel.state {
            case .initial: EmptyView()
            case .loaded(let product): content(product)
            case .error: errorView
            }

            if viewModel.isLoading && !refreshing {
                loadingProgress
            }
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.load()
        }
    }

    private var loadingProgress: some View {
        ProgressView()
    }

    private var errorView: some View {
        ErrorStateView(message: "상품을 불러오지 못했어요") {
            await viewModel.load()
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private func content(_ product: ProductDetail) -> some View {
        List {
            if !product.images.isEmpty {
                imageCarousel(product.images)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
            }

            headerSection(product)
                .listRowSeparator(.hidden)

            priceSection(product)
                .listRowSeparator(.hidden)

            if !product.description.isEmpty {
                descriptionSection(product)
            }

            detailInfoSection(product)
            policySection(product)

            if !product.tags.isEmpty {
                tagsSection(product.tags)
            }

            if !product.reviews.isEmpty {
                reviewsSection(product.reviews)
            }
        }
        .listStyle(.plain)
        .listSectionSpacing(0)
        .refreshable {
            refreshing = true
            await viewModel.load()
            refreshing = false
        }
    }
}

// MARK: - Header
private extension ProductDetailView {
    func headerSection(_ product: ProductDetail) -> some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                if !product.brand.isEmpty {
                    Text(product.brand)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Text(product.title)
                    .font(.title3.bold())

                ratingView(product)

                availabilityBadge(product.availabilityStatus)
            }

            Spacer()

            wishButton
        }
    }

    func ratingView(_ product: ProductDetail) -> some View {
        HStack(spacing: 4) {
            Label(String(format: "%.1f", product.rating), systemImage: "star.fill")
                .foregroundStyle(.orange)
            Text("(\(product.reviews.count)개 리뷰)")
                .foregroundStyle(.secondary)
        }
        .font(.caption)
    }

    var wishButton: some View {
        WishButton(isWished: viewModel.isWished) {
            await viewModel.toggleWish()
        }
        .font(.title2)
    }

    func availabilityBadge(_ status: AvailabilityStatus) -> some View {
        let (text, color) = availabilityInfo(status)
        return Text(text)
            .font(.caption2.bold())
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(color.opacity(0.15), in: Capsule())
            .foregroundStyle(color)
    }

    func availabilityInfo(_ status: AvailabilityStatus) -> (String, Color) {
        switch status {
        case .inStock: ("재고 있음", .green)
        case .lowStock: ("재고 부족", .orange)
        case .outOfStock: ("품절", .red)
        }
    }
}

// MARK: - Image
private extension ProductDetailView {
    func imageCarousel(_ images: [URL]) -> some View {
        TabView {
            ForEach(images, id: \.self) { url in
                KFImage(url)
                    .resizable()
                    .placeholder { imagePlaceholder }
                    .fade(duration: 0.2)
                    .scaledToFill()
                    .clipped()
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .aspectRatio(1, contentMode: .fit)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    var imagePlaceholder: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(.quaternary)
            .overlay {
                Image(systemName: "photo")
                    .font(.system(size: 40))
                    .foregroundStyle(.secondary)
            }
    }
}

// MARK: - Price
private extension ProductDetailView {
    func priceSection(_ product: ProductDetail) -> some View {
        HStack(spacing: 8) {
            Text(product.price.discountedPrice, format: .currency(code: "USD"))
                .font(.title2.bold())

            if product.price.discountPercentage > 0 {
                Text(product.price.originalPrice, format: .currency(code: "USD"))
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .strikethrough()

                Text("\(Int(product.price.discountPercentage))% 할인")
                    .font(.caption.bold())
                    .foregroundStyle(.red)
            }
        }
    }
}

// MARK: - Sections
private extension ProductDetailView {
    func descriptionSection(_ product: ProductDetail) -> some View {
        Section("상세 설명") {
            Text(product.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .listRowSeparator(.hidden)
        }
    }

    func detailInfoSection(_ product: ProductDetail) -> some View {
        Section("상품 정보") {
            VStack(alignment: .leading, spacing: 6) {
                infoRow("카테고리", product.category)
                infoRow("SKU", product.sku)
                infoRow("무게", "\(product.weight)")
                infoRow(
                    "크기",
                    "\(product.dimensions.width) x \(product.dimensions.height) x \(product.dimensions.depth)"
                )
                infoRow("최소 주문 수량", "\(product.minimumOrderQuantity)개")
                infoRow("재고", "\(product.stock)개")
            }
            .padding(.vertical, 4)
            .listRowSeparator(.hidden)
        }
    }

    func infoRow(_ label: String, _ value: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(width: 90, alignment: .leading)

            Text(value)
                .font(.caption)

            Spacer()
        }
    }

    func policySection(_ product: ProductDetail) -> some View {
        Section("배송 및 보증") {
            VStack(alignment: .leading, spacing: 6) {
                Label(product.shippingInformation, systemImage: "shippingbox")
                Label(product.warrantyInformation, systemImage: "checkmark.shield")
                Label(product.returnPolicy, systemImage: "arrow.uturn.backward")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            .padding(.vertical, 4)
            .listRowSeparator(.hidden)
        }
    }

    func tagsSection(_ tags: [String]) -> some View {
        Section("태그") {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(tags, id: \.self) { tag in
                        Text(tag)
                            .font(.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(.quaternary, in: Capsule())
                    }
                }
            }
            .listRowSeparator(.hidden)
        }
    }

    func reviewsSection(_ reviews: [Review]) -> some View {
        Section("리뷰 (\(reviews.count))") {
            ForEach(reviews, id: \.self) { review in
                reviewRow(review)
                    .listRowSeparator(.hidden)
            }
        }
    }

    func reviewRow(_ review: Review) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(review.reviewerName)
                    .font(.subheadline.bold())

                Spacer()

                Label("\(review.rating)", systemImage: "star.fill")
                    .font(.caption)
                    .foregroundStyle(.orange)
            }

            Text(review.comment)
                .font(.subheadline)

            Text(review.date, format: .dateTime.year().month().day())
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#if DEBUG
#Preview {
    let product = ProductDetail(
        id: 1,
        title: "iPhone 13 Pro",
        description: "A17 Pro 칩과 향상된 카메라 시스템을 탑재한 최신 프로 모델입니다.",
        category: "smartphones",
        price: ProductPrice(originalPrice: 999, discountPercentage: 10),
        rating: 4.5,
        stock: 34,
        tags: ["apple", "smartphone", "pro"],
        brand: "Apple",
        sku: "IP13P-256-GR",
        weight: 0.204,
        dimensions: ProductDimensions(width: 7.15, height: 14.67, depth: 0.765),
        warrantyInformation: "1년 무상 보증",
        shippingInformation: "3~5일 내 배송",
        availabilityStatus: .inStock,
        reviews: [
            Review(
                rating: 5,
                comment: "배터리도 오래가고 카메라 화질이 정말 좋아요.",
                date: Date(timeIntervalSince1970: 1_700_000_000),
                reviewerName: "김민수",
                reviewerEmail: "minsu@example.com"
            ),
            Review(
                rating: 4,
                comment: "가격 대비 만족스럽습니다.",
                date: Date(timeIntervalSince1970: 1_705_000_000),
                reviewerName: "이지은",
                reviewerEmail: "jieun@example.com"
            )
        ],
        returnPolicy: "30일 이내 무료 반품",
        minimumOrderQuantity: 1,
        meta: ProductMeta(
            createdAt: Date(timeIntervalSince1970: 0),
            updatedAt: Date(timeIntervalSince1970: 0),
            barcode: "1234567890",
            qrCode: URL(string: "https://example.com")!
        ),
        images: [
            URL(string: "https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/thumbnail.webp")!,
            URL(string: "https://cdn.dummyjson.com/product-images/fragrances/calvin-klein-ck-one/thumbnail.webp")!
        ]
    )

    NavigationStack {
        ProductDetailView(
            viewModel: ProductDetailViewModel(
                router: Router(),
                repository: DummyProductDetailRepository(product: product),
                wishlistManager: DummyWishlistManager(),
                productID: product.id
            )
        )
    }
}
#endif
