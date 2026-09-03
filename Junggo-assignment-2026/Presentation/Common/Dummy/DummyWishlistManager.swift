//
//  DummyWishlistManager.swift
//  Junggo-assignment-2026
//
//  Created by yjc on 9/4/26.
//

#if DEBUG
import Foundation

/// Preview 전용 더미. 실제 저장소 없이 메모리에서만 찜 상태를 토글한다.
@MainActor @Observable
final class DummyWishlistManager: WishlistManaging {
    private var wishlistIDs: Set<Int>

    init(wishedIDs: Set<Int> = []) {
        self.wishlistIDs = wishedIDs
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
#endif
