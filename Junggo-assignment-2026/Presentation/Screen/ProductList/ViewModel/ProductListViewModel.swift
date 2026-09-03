//
//  ProductListViewModel.swift
//  Junggo-assignment-2026
//
//  Created by yjc on 9/4/26.
//

import Foundation

@MainActor
@Observable
final class ProductListViewModel {
    private let router: Routable
    private let repository: ProductListRepository
    private let wishlistManager: WishlistManaging

    private(set) var state = State.initial
    private(set) var rows: [ProductListRowViewModel] = []
    private var loadTask: Task<[ProductListRowViewModel], Error>?

    init(router: Routable, repository: ProductListRepository, wishlistManager: WishlistManaging) {
        self.router = router
        self.repository = repository
        self.wishlistManager = wishlistManager
    }
}

// MARK: - Nested Types
extension ProductListViewModel {
    enum State: Equatable {
        case initial
        case empty
        case loaded
        case error
    }
}

// MARK: - Private
private extension ProductListViewModel {
    func createLoadTask() -> Task<[ProductListRowViewModel], Error> {
        Task {
            let products = try await repository.fetchProducts()
            return products.map {
                ProductListRowViewModel(router: router, wishlistManager: wishlistManager, product: $0)
            }
        }
    }
}

// MARK: - Interface
extension ProductListViewModel {
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
        case .success(let rows):
            self.rows = rows
            state = rows.isEmpty ? .empty : .loaded
        case .failure:
            state = .error
        }
    }
}
