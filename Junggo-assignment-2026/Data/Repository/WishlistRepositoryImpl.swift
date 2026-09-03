import Foundation

actor WishlistRepositoryImpl: WishlistRepository {
    private let userDefaults: UserDefaults
    private let storageKey: String

    init(userDefaults: UserDefaults = .standard, storageKey: String = "wishlist.productIDs") {
        self.userDefaults = userDefaults
        self.storageKey = storageKey
    }

    @discardableResult
    func add(productID: Int) async throws -> [Int] {
        var ids = storedIDs()
        guard !ids.contains(productID) else { return ids }
        ids.append(productID)
        persist(ids)
        return ids
    }

    @discardableResult
    func remove(productID: Int) async throws -> [Int] {
        var ids = storedIDs()
        guard let index = ids.firstIndex(of: productID) else { return ids }
        ids.remove(at: index)
        persist(ids)
        return ids
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
