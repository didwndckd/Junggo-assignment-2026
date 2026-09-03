import Foundation
@testable import Junggo_assignment_2026

/// `WishlistManaging`의 테스트용 mock. 실제 저장소 없이 메모리에서만 찜 상태를 토글한다.
@MainActor
final class MockWishlistManager: WishlistManaging {
    private var wishlistIDs: Set<Int>

    init(wishlistIDs: Set<Int> = []) {
        self.wishlistIDs = wishlistIDs
    }

    func isWishlisted(id: Int) -> Bool {
        wishlistIDs.contains(id)
    }

    func toggle(id: Int) async throws {
        if wishlistIDs.contains(id) {
            wishlistIDs.remove(id)
        } else {
            wishlistIDs.insert(id)
        }
    }
}
