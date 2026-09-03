//
//  CompositionRoot.swift
//  Junggo-assignment-2026
//
//  Created by yjc on 9/4/26.
//

import SwiftUI

@MainActor
final class CompositionRoot {
    let router: Router
    let productListViewModel: ProductListViewModel
    
    init() {
        let repository = ProductListRepositoryImpl()
        let router = Router()
        
        self.router = router
        self.productListViewModel = ProductListViewModel(
            router: router,
            repository: repository,
            wishlistManager: Self.wishlistManager
        )
    }
}

extension CompositionRoot {
    @ViewBuilder
    func view(from route: Route) -> some View {
        switch route {
        case .detail(id: let id):
            createDetailView(for: id)
        }
    }
    
    private func createDetailView(for id: Int) -> some View {
        ProductDetailView(
            viewModel: ProductDetailViewModel(
                router: router,
                repository: ProductDetailRepositoryImpl(),
                wishlistManager: Self.wishlistManager,
                productID: id
            )
        )
    }
}

extension CompositionRoot {
    static let wishlistManager = WishlistManager(repository: WishlistRepositoryImpl())
}
