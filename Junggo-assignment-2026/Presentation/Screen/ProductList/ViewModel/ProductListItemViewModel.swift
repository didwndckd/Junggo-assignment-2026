//
//  ProductListItemViewModel.swift
//  Junggo-assignment-2026
//
//  Created by yjc on 9/4/26.
//

import Combine
import Foundation

@MainActor
@Observable
final class ProductListItemViewModel: Identifiable {
    let id = UUID()
    
    private let router: Routable
    private let wishlistManager: WishlistManaging
    private var cancellables = Set<AnyCancellable>()
    
    let product: Product
    private(set) var isWished = false
    
    init(router: Routable, wishlistManager: WishlistManaging, product: Product) {
        self.router = router
        self.wishlistManager = wishlistManager
        self.product = product

        bind()
    }
}

// MARK: - Bind
private extension ProductListItemViewModel {
    func bind() {
        wishlistManager.wishlistIDsPublisher
            .map { [product] ids in ids.contains(product.id) }
            .removeDuplicates()
            .sink { [weak self] isWished in
                self?.isWished = isWished
            }
            .store(in: &cancellables)
    }
}

// MARK: - Interface
extension ProductListItemViewModel {
    func toggleWish() async {
        try? await wishlistManager.toggle(id: product.id)
    }

    func select() {
        router.push(route: .detail(id: product.id))
    }
}
