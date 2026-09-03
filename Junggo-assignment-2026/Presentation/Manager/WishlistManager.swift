import Combine
import Foundation

/// 찜 상태를 앱 전역에서 공유·관찰하기 위한 추상화. 구현체는 Presentation 레이어에 둔다.
@MainActor
protocol WishlistManaging: AnyObject {
    /// 현재 찜한 상품 ID 집합을 구독할 수 있는 퍼블리셔. 구독 시점에 최신 상태를 즉시 방출한다.
    var wishlistIDsPublisher: AnyPublisher<Set<Int>, Never> { get }

    /// 찜 상태를 토글한다. 찜한 상품이면 해제하고, 아니면 찜한다.
    func toggle(id: Int) async throws
}

@MainActor
final class WishlistManager: WishlistManaging {
    private let repository: WishlistRepository

    @Published private(set) var wishlistIDs: Set<Int> = []
    private var initialTask: Task<Void, Never>?
    
    init(repository: WishlistRepository) {
        self.repository = repository
        self.initialTask = Task { await self.loadInitialState() }
    }
}

// MARK: - Private

extension WishlistManager {
    private func loadInitialState() async {
        let ids = try? await repository.fetchWishlistProductIDs()
        wishlistIDs = Set(ids ?? [])
        initialTask = nil
    }

    /// mutating 메서드는 항상 이 메서드로 초기 로드 완료를 먼저 보장한 뒤 `wishlistIDs`를 참조한다.
    private func ensureLoaded() async {
        await initialTask?.value
    }
}

// MARK: - Interface

extension WishlistManager {
    var wishlistIDsPublisher: AnyPublisher<Set<Int>, Never> {
        $wishlistIDs.eraseToAnyPublisher()
    }

    func toggle(id: Int) async throws {
        await ensureLoaded()

        let ids: [Int]
        if wishlistIDs.contains(id) {
            ids = try await repository.remove(productID: id)
        } else {
            ids = try await repository.add(productID: id)
        }
        wishlistIDs = Set(ids)
    }
}
