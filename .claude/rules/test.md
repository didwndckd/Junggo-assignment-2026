---
paths:
  - "**/*Tests/**"
---

# 테스트 룰

## 폴더 구조

`Junggo-assignment-2026Tests/` 폴더 구조는 프로덕션 코드(`Junggo-assignment-2026/`)와 동일하게 미러링한다.

```
Junggo-assignment-2026Tests/
├── Mock/                  # 여러 테스트에서 재사용하는 mock
├── Data/
│   └── Repository/
├── Domain/
└── Presentation/
```

## 규칙

- 테스트 파일/스위트 명명: `<대상 타입>Tests` (예: `ProductListRepositoryImpl` → `ProductListRepositoryImplTests`), 대상 타입과 동일한 상대 경로에 위치시킨다.
- Swift Testing(`import Testing`, `@Test`, `#expect`, `#require`)을 사용한다. XCTest는 사용하지 않는다.
- 테스트 스위트는 `struct`로 작성하고 `@testable import Junggo_assignment_2026`로 대상 모듈을 가져온다.
- 테스트 함수 이름은 영어로, 짧고 간결하게 작성한다. 설명은 함수명이 아니라 `@Test("...")`가 담당하므로 함수명을 장황하게 풀어쓰지 않는다.
- `@Test("...")` 설명 문구는 한글로 작성한다. "무엇을 하면 어떻게 된다" 형태로 서술한다.
  - 예: `@Test("fetchProducts는 HTTP 에러 상태코드일 경우 실패한다") func fetchHTTPError()`
- Mock은 `Mock/` 폴더에 두고 여러 테스트 파일에서 재사용 가능하도록 범용적으로 설계한다.
  - 프로토콜 기반 의존성(`NetworkSession` 등)을 모킹할 때는 `actor`로 구현해 동시성 안전성을 확보한다.
  - 응답 큐는 `[Result<Success, Error>]` 형태로 보관해 `init(results:)`으로 미리 채워두거나, `stub(...)` 편의 메서드로 순차 추가할 수 있게 한다. (`MockNetworkSession` 참고)
