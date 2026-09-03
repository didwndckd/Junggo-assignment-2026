import Foundation

actor WishlistRepositoryImpl: WishlistRepository {
    private let userDefaults: UserDefaults
    private let storageKey: String

    init(userDefaults: UserDefaults = .standard, storageKey: String = "wishlist.productIDs") {
        self.userDefaults = userDefaults
        self.storageKey = storageKey
    }

    func add(productID: Int) async throws {
        var ids = storedIDs()
        guard !ids.contains(productID) else { return }
        ids.append(productID)
        persist(ids)
    }

    func remove(productID: Int) async throws {
        var ids = storedIDs()
        guard let index = ids.firstIndex(of: productID) else { return }
        ids.remove(at: index)
        persist(ids)
    }

    func fetchWishlistProductIDs() async throws -> [Int] {
        storedIDs()
    }
}

extension WishlistRepositoryImpl {
    private func storedIDs() -> [Int] {
        userDefaults.array(forKey: storageKey) as? [Int] ?? []
    }

    private func persist(_ ids: [Int]) {
        userDefaults.set(ids, forKey: storageKey)
    }
}
