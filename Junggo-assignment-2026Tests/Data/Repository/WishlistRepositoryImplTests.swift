import Foundation
import Testing
@testable import Junggo_assignment_2026

struct WishlistRepositoryImplTests {
    @Test("fetchWishlistProductIDs는 초기 상태에서 빈 배열을 반환한다")
    func fetchInitialEmpty() async throws {
        let repository = Self.makeRepository()

        let ids = try await repository.fetchWishlistProductIDs()

        #expect(ids.isEmpty)
    }

    @Test("add는 상품 ID를 찜 목록에 추가한다")
    func addNew() async throws {
        let repository = Self.makeRepository()

        try await repository.add(productID: 1)

        #expect(try await repository.fetchWishlistProductIDs() == [1])
    }

    @Test("add는 이미 찜한 상품이면 중복 추가하지 않는다")
    func addDuplicate() async throws {
        let repository = Self.makeRepository()
        try await repository.add(productID: 1)

        try await repository.add(productID: 1)

        #expect(try await repository.fetchWishlistProductIDs() == [1])
    }

    @Test("add는 찜한 순서를 보존한다")
    func addPreservesOrder() async throws {
        let repository = Self.makeRepository()

        try await repository.add(productID: 3)
        try await repository.add(productID: 1)
        try await repository.add(productID: 2)

        #expect(try await repository.fetchWishlistProductIDs() == [3, 1, 2])
    }

    @Test("remove는 상품 ID를 찜 목록에서 제거한다")
    func removeExisting() async throws {
        let repository = Self.makeRepository()
        try await repository.add(productID: 1)
        try await repository.add(productID: 2)

        try await repository.remove(productID: 1)

        #expect(try await repository.fetchWishlistProductIDs() == [2])
    }

    @Test("remove는 찜하지 않은 상품이면 아무 동작도 하지 않는다")
    func removeMissing() async throws {
        let repository = Self.makeRepository()
        try await repository.add(productID: 1)

        try await repository.remove(productID: 999)

        #expect(try await repository.fetchWishlistProductIDs() == [1])
    }
}

private extension WishlistRepositoryImplTests {
    static func makeRepository() -> WishlistRepositoryImpl {
        let suiteName = "WishlistRepositoryImplTests.\(UUID().uuidString)"
        let userDefaults = UserDefaults(suiteName: suiteName)!
        return WishlistRepositoryImpl(userDefaults: userDefaults, storageKey: "wishlist.productIDs")
    }
}
