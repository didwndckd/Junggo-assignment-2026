//
//  DummyProductDetailRepository.swift
//  Junggo-assignment-2026
//
//  Created by yjc on 9/4/26.
//

#if DEBUG
import Foundation

struct DummyProductDetailRepository: ProductDetailRepository {
    private let result: Result<ProductDetail, Error>

    init(result: Result<ProductDetail, Error>) {
        self.result = result
    }

    init(product: ProductDetail) {
        self.init(result: .success(product))
    }

    func fetchProduct(id: Int) async throws -> ProductDetail {
        try await Task.sleep(nanoseconds: 500_000_000)
        return try result.get()
    }
}
#endif
