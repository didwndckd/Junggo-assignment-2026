import Foundation
import Testing
@testable import Junggo_assignment_2026

struct WishlistRepositoryImplTests {
    @Test("fetchWishlistProductIDs는 초기 상태에서 빈 배열을 반환한다")
    func fetchInitialEmpty() async throws {
        try await Self.withRepository { repository in
            let ids = try await repository.fetchWishlistProductIDs()

            #expect(ids.isEmpty)
        }
    }

    @Test("add는 상품 ID를 찜 목록에 추가한다")
    func addNew() async throws {
        try await Self.withRepository { repository in
            try await repository.add(productID: 1)

            #expect(try await repository.fetchWishlistProductIDs() == [1])
        }
    }

    @Test("add는 이미 찜한 상품이면 중복 추가하지 않는다")
    func addDuplicate() async throws {
        try await Self.withRepository { repository in
            try await repository.add(productID: 1)

            try await repository.add(productID: 1)

            #expect(try await repository.fetchWishlistProductIDs() == [1])
        }
    }

    @Test("add는 찜한 순서를 보존한다")
    func addPreservesOrder() async throws {
        try await Self.withRepository { repository in
            try await repository.add(productID: 3)
            try await repository.add(productID: 1)
            try await repository.add(productID: 2)

            #expect(try await repository.fetchWishlistProductIDs() == [3, 1, 2])
        }
    }

    @Test("remove는 상품 ID를 찜 목록에서 제거한다")
    func removeExisting() async throws {
        try await Self.withRepository { repository in
            try await repository.add(productID: 1)
            try await repository.add(productID: 2)

            try await repository.remove(productID: 1)

            #expect(try await repository.fetchWishlistProductIDs() == [2])
        }
    }

    @Test("remove는 찜하지 않은 상품이면 아무 동작도 하지 않는다")
    func removeMissing() async throws {
        try await Self.withRepository { repository in
            try await repository.add(productID: 1)

            try await repository.remove(productID: 999)

            #expect(try await repository.fetchWishlistProductIDs() == [1])
        }
    }
}

private extension WishlistRepositoryImplTests {
    /// 테스트마다 고유한 suite로 `WishlistRepositoryImpl`을 만들어 `body`를 실행하고,
    /// 종료 시(성공/실패/throw 무관) `removePersistentDomain`으로 남긴 plist를 정리한다.
    static func withRepository(
        _ body: (WishlistRepositoryImpl) async throws -> Void
    ) async throws {
        let suiteName = "WishlistRepositoryImplTests.\(UUID().uuidString)"
        let userDefaults = UserDefaults(suiteName: suiteName)!
        defer { userDefaults.removePersistentDomain(forName: suiteName) }

        let repository = WishlistRepositoryImpl(userDefaults: userDefaults, storageKey: "wishlist.productIDs")
        try await body(repository)
    }
}
