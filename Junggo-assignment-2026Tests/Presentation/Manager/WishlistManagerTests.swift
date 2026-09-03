import Foundation
import Testing
@testable import Junggo_assignment_2026

@MainActor
struct WishlistManagerTests {
    @Test("초기 로드가 끝나면 저장된 찜 목록을 wishlistIDs에 반영한다")
    func loadsInitialState() async throws {
        let repository = MockWishlistRepository(productIDs: [1, 2])
        let manager = WishlistManager(repository: repository)

        try await manager.toggle(id: 3)

        #expect(manager.isWishlisted(id: 1))
        #expect(manager.isWishlisted(id: 2))
        #expect(manager.isWishlisted(id: 3))
    }

    @Test("toggle은 찜하지 않은 상품이면 추가한다")
    func toggleAdds() async throws {
        let repository = MockWishlistRepository()
        let manager = WishlistManager(repository: repository)

        try await manager.toggle(id: 1)

        #expect(manager.isWishlisted(id: 1))
    }

    @Test("toggle은 이미 찜한 상품이면 제거한다")
    func toggleRemoves() async throws {
        let repository = MockWishlistRepository(productIDs: [1])
        let manager = WishlistManager(repository: repository)

        try await manager.toggle(id: 1)

        #expect(!manager.isWishlisted(id: 1))
    }
}
