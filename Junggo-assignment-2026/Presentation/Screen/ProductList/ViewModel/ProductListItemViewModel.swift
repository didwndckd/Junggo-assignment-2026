//
//  ProductListItemViewModel.swift
//  Junggo-assignment-2026
//
//  Created by yjc on 9/4/26.
//

import Foundation

@MainActor @Observable
final class ProductListItemViewModel: Identifiable {
    let id = UUID()

    private let router: Routable
    private let wishlistManager: WishlistManaging
    
    let product: Product

    init(router: Routable, wishlistManager: WishlistManaging, product: Product) {
        self.router = router
        self.wishlistManager = wishlistManager
        self.product = product
    }
}

// MARK: - Interface
extension ProductListItemViewModel {
    var isWished: Bool {
        wishlistManager.isWishlisted(id: product.id)
    }

    func toggleWish() async {
        try? await wishlistManager.toggle(id: product.id)
    }

    func select() {
        router.push(route: .detail(id: product.id))
    }
}
