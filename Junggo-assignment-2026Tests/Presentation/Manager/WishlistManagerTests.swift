import Combine
import Foundation
import Testing
@testable import Junggo_assignment_2026

@MainActor
struct WishlistManagerTests {
    @Test("초기 로드가 끝나면 저장된 찜 목록을 wishlistIDs에 반영한다")
    func loadsInitialState() async throws {
        let repository = MockWishlistRepository(productIDs: [1, 2])
        let manager = WishlistManager(repository: repository)

        let ids = await manager.wishlistIDsPublisher.values.first { $0 == [1, 2] }

        #expect(ids == [1, 2])
    }

    @Test("toggle은 찜하지 않은 상품이면 추가한다")
    func toggleAdds() async throws {
        let repository = MockWishlistRepository()
        let manager = WishlistManager(repository: repository)

        try await manager.toggle(id: 1)

        #expect(manager.wishlistIDs == [1])
    }

    @Test("toggle은 이미 찜한 상품이면 제거한다")
    func toggleRemoves() async throws {
        let repository = MockWishlistRepository(productIDs: [1])
        let manager = WishlistManager(repository: repository)

        try await manager.toggle(id: 1)

        #expect(manager.wishlistIDs.isEmpty)
    }

    @Test("wishlistIDsPublisher는 wishlistIDs 변경을 방출한다")
    func publisherEmitsChanges() async throws {
        let repository = MockWishlistRepository()
        let manager = WishlistManager(repository: repository)

        var received: [Set<Int>] = []
        let cancellable = manager.wishlistIDsPublisher.sink { received.append($0) }

        try await manager.toggle(id: 1)

        cancellable.cancel()
        #expect(received.last == [1])
    }
}
