//
//  DummyProductListRepository.swift
//  Junggo-assignment-2026
//
//  Created by yjc on 9/4/26.
//

#if DEBUG
import Foundation

struct DummyProductListRepository: ProductListRepository {
    private let result: Result<[Product], Error>

    init(result: Result<[Product], Error>) {
        self.result = result
    }

    init(products: [Product] = []) {
        self.init(result: .success(products))
    }

    func fetchProducts() async throws -> [Product] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return try result.get()
    }
}
#endif
