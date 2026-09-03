//
//  DummyWishlistManager.swift
//  Junggo-assignment-2026
//
//  Created by yjc on 9/4/26.
//

#if DEBUG
import Combine
import Foundation

/// Preview 전용 더미. 실제 저장소 없이 메모리에서만 찜 상태를 토글한다.
@MainActor
final class DummyWishlistManager: WishlistManaging {
    private let subject: CurrentValueSubject<Set<Int>, Never>

    init(wishedIDs: Set<Int> = []) {
        subject = CurrentValueSubject(wishedIDs)
    }

    var wishlistIDsPublisher: AnyPublisher<Set<Int>, Never> {
        subject.eraseToAnyPublisher()
    }

    func toggle(id: Int) async throws {
        var ids = subject.value
        if ids.contains(id) {
            ids.remove(id)
        } else {
            ids.insert(id)
        }
        subject.send(ids)
    }
}
#endif
