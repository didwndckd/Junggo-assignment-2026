import Foundation
import Testing
@testable import Junggo_assignment_2026

@MainActor
struct ProductListViewModelTests {
    @Test("load는 조회한 상품으로 rows를 구성하고 state를 loaded로 전환한다")
    func loadSuccess() async throws {
        let products = [ProductFactory.make(id: 1), ProductFactory.make(id: 2)]
        let repository = MockProductListRepository(results: [.success(products)])
        let sut = makeSUT(repository: repository)

        await sut.load()

        #expect(sut.state == .loaded)
        #expect(sut.items.map(\.product.id) == [1, 2])
    }

    @Test("load는 조회 결과가 비어있으면 state를 empty로 전환한다")
    func loadEmpty() async throws {
        let repository = MockProductListRepository(results: [.success([])])
        let sut = makeSUT(repository: repository)

        await sut.load()

        #expect(sut.state == .empty)
        #expect(sut.items.isEmpty)
    }

    @Test("load는 조회에 실패하면 state를 error로 전환한다")
    func loadFailure() async throws {
        let repository = MockProductListRepository(results: [.failure(MockProductListRepository.NotStubbed())])
        let sut = makeSUT(repository: repository)

        await sut.load()

        #expect(sut.state == .error)
        #expect(sut.items.isEmpty)
    }
}

private extension ProductListViewModelTests {
    func makeSUT(
        router: Routable? = nil,
        repository: ProductListRepository? = nil,
        wishlistManager: WishlistManaging? = nil
    ) -> ProductListViewModel {
        ProductListViewModel(
            router: router ?? Router(),
            repository: repository ?? MockProductListRepository(),
            wishlistManager: wishlistManager ?? MockWishlistManager()
        )
    }
}
