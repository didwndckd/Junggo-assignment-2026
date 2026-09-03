import Foundation
import Testing
@testable import Junggo_assignment_2026

@MainActor
struct ProductDetailViewModelTests {
    @Test("load는 조회한 상품으로 state를 loaded로 전환한다")
    func loadSuccess() async throws {
        let product = ProductFactory.makeDetail(id: 1)
        let repository = MockProductDetailRepository(results: [.success(product)])
        let sut = makeSUT(repository: repository)

        await sut.load()

        #expect(sut.state == .loaded(product))
    }

    @Test("load는 조회에 실패하면 state를 error로 전환한다")
    func loadFailure() async throws {
        let repository = MockProductDetailRepository(results: [.failure(MockProductDetailRepository.NotStubbed())])
        let sut = makeSUT(repository: repository)

        await sut.load()

        #expect(sut.state == .error)
    }

    @Test("title은 state가 loaded면 상품 제목을 반환한다")
    func titleReflectsLoadedProduct() async throws {
        let product = ProductFactory.makeDetail(id: 1)
        let repository = MockProductDetailRepository(results: [.success(product)])
        let sut = makeSUT(repository: repository)

        await sut.load()

        #expect(sut.title == product.title)
    }

    @Test("title은 state가 loaded가 아니면 빈 문자열을 반환한다")
    func titleEmptyWhenNotLoaded() async throws {
        let repository = MockProductDetailRepository(results: [.failure(MockProductDetailRepository.NotStubbed())])
        let sut = makeSUT(repository: repository)

        await sut.load()

        #expect(sut.title == "")
    }

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
}

private extension ProductDetailViewModelTests {
    func makeSUT(
        router: Routable? = nil,
        repository: ProductDetailRepository? = nil,
        wishlistManager: WishlistManaging? = nil,
        productID: Int = 1
    ) -> ProductDetailViewModel {
        ProductDetailViewModel(
            router: router ?? Router(),
            repository: repository ?? MockProductDetailRepository(),
            wishlistManager: wishlistManager ?? MockWishlistManager(),
            productID: productID
        )
    }
}
