import Foundation

/// 프로젝트 전역에서 공유하는 날짜 포맷터 모음.
enum DateFormatter {
    /// API가 사용하는 `"2025-04-30T09:41:02.053Z"` 형식(밀리초 포함 ISO8601)을 파싱한다.
    ///
    /// Foundation의 `ISO8601DateFormatter`는 Sendable이 아니지만, 이 인스턴스는 mutable state를
    /// 변경하지 않고 항상 같은 formatOptions로 읽기 전용처럼 사용하므로 동시 접근이 안전하다.
    nonisolated(unsafe) static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}
