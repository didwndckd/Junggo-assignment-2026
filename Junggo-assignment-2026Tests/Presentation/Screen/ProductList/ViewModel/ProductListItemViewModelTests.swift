import Foundation
import Testing
@testable import Junggo_assignment_2026
import Combine

@MainActor
struct ProductListItemViewModelTests {
    @Test("toggleWish는 찜하지 않은 상품이면 찜 상태로 전환한다")
    func toggleWishAdds() async throws {
        let sut = makeSUT()

        await sut.toggleWish()

        #expect(sut.isWished == true)
    }

    @Test("toggleWish는 이미 찜한 상품이면 찜 해제 상태로 전환한다")
    func toggleWishRemoves() async throws {
        let wishlistManager = MockWishlistManager(wishlistIDs: [1])
        let sut = makeSUT(wishlistManager: wishlistManager)

        await sut.toggleWish()

        #expect(sut.isWished == false)
    }

    @Test("이미 찜한 상품으로 생성되면 초기 isWished는 true다")
    func initialWishedState() {
        let sut = makeSUT(wishlistManager: MockWishlistManager(wishlistIDs: [1]))

        #expect(sut.isWished == true)
    }

    @Test("찜하지 않은 상품으로 생성되면 초기 isWished는 false다")
    func initialNotWishedState() {
        let sut = makeSUT(wishlistManager: MockWishlistManager())

        #expect(sut.isWished == false)
    }

    @Test("select는 라우터에 상품 상세 라우트를 push한다")
    func selectPushesDetail() async throws {
        let router = Router()
        let sut = makeSUT(router: router)

        sut.select()

        #expect(router.path == [.detail(id: 1)])
    }
}

private extension ProductListItemViewModelTests {
    func makeSUT(
        router: Routable? = nil,
        wishlistManager: WishlistManaging? = nil,
        product: Product? = nil
    ) -> ProductListItemViewModel {
        ProductListItemViewModel(
            router: router ?? Router(),
            wishlistManager: wishlistManager ?? MockWishlistManager(),
            product: product ?? ProductFactory.make(id: 1)
        )
    }
}
