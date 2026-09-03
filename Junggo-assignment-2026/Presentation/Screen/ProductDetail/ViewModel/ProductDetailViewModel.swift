//
//  ProductDetailViewModel.swift
//  Junggo-assignment-2026
//
//  Created by yjc on 9/4/26.
//

import Combine
import Foundation

@MainActor
@Observable
final class ProductDetailViewModel {
    private let router: Routable
    private let repository: ProductDetailRepository
    private let wishlistManager: WishlistManaging
    private let productID: Int

    private(set) var state = State.initial
    private(set) var product: ProductDetail?
    private(set) var isWished = false
    private var loadTask: Task<ProductDetail, Error>?
    private var cancellables = Set<AnyCancellable>()

    init(router: Routable, repository: ProductDetailRepository, wishlistManager: WishlistManaging, productID: Int) {
        self.router = router
        self.repository = repository
        self.wishlistManager = wishlistManager
        self.productID = productID

        bind()
    }
}

// MARK: - Nested Types
extension ProductDetailViewModel {
    enum State: Equatable {
        case initial
        case loaded
        case error
    }
}

// MARK: - Bind
private extension ProductDetailViewModel {
    func bind() {
        wishlistManager.wishlistIDsPublisher
            .map { [productID] ids in ids.contains(productID) }
            .removeDuplicates()
            .sink { [weak self] isWished in
                self?.isWished = isWished
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private
private extension ProductDetailViewModel {
    func createLoadTask() -> Task<ProductDetail, Error> {
        Task {
            try await repository.fetchProduct(id: productID)
        }
    }
}

// MARK: - Interface
extension ProductDetailViewModel {
    var isLoading: Bool {
        loadTask != nil
    }

    /// 이전 load Task는 취소하고 마지막 호출의 Task만 유효하게 반영한다.
    func load() async {
        loadTask?.cancel()
        let task = createLoadTask()
        loadTask = task

        let result = await task.result
        guard loadTask == task else { return }
        loadTask = nil

        switch result {
        case .success(let product):
            self.product = product
            state = .loaded
        case .failure:
            state = .error
        }
    }

    func toggleWish() async {
        try? await wishlistManager.toggle(id: productID)
    }
}
