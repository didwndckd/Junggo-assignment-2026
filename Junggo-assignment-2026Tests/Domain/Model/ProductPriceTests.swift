import Testing
@testable import Junggo_assignment_2026

struct ProductPriceTests {
    @Test("discountedPrice는 정가에서 할인율만큼 차감한 금액이다")
    func discounted() {
        let price = ProductPrice(originalPrice: 100, discountPercentage: 10)

        #expect(price.discountedPrice == 90)
    }

    @Test("할인율이 0이면 discountedPrice는 정가와 같다")
    func noDiscount() {
        let price = ProductPrice(originalPrice: 9.99, discountPercentage: 0)

        #expect(price.discountedPrice == 9.99)
    }

    @Test("할인율이 100이면 discountedPrice는 0이다")
    func fullDiscount() {
        let price = ProductPrice(originalPrice: 50, discountPercentage: 100)

        #expect(price.discountedPrice == 0)
    }

    /// 실제 API 응답처럼 나눠떨어지지 않는 값은 부동소수점 오차가 생길 수 있어 허용오차로 비교한다.
    @Test("소수점이 딱 떨어지지 않는 할인율도 근사값으로 계산된다")
    func fractionalDiscount() {
        let price = ProductPrice(originalPrice: 9.99, discountPercentage: 10.48)

        #expect(abs(price.discountedPrice - 8.943048) < 0.0001)
    }
}
