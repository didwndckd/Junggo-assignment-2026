---
paths:
  - "**/Presentation/**"
  - "**/ViewModel/**"
---

## ViewModel 코드 구성

ViewModel 은 `@MainActor` 로 선언한다. (UI 가 바인딩하는 상태를 항상 메인 스레드에서 갱신)

```swift
@MainActor
final class ProfileViewModel {
    ...
}
```

### 파일 내 코드 배치 순서

타입 본체(클래스) → 그 다음 extension 들을 다음 순서로 둔다.

1. **타입 본체**: 프로퍼티 선언(의존성 주입 프로퍼티, 상태/출력 프로퍼티) / `init`.
2. **`// MARK: - Nested Types` extension**: `Input` / `Output` / `State` / `Action` 등 ViewModel 내부에서 쓰는 중첩 타입을 정의.
3. **`// MARK: - Bind` extension** *(있다면)*: `bind()` 와 바인딩 관련 헬퍼.
4. **그 외 `private` 함수 extension**: 액션/포맷팅/내부 로직 등 나머지 `private` 헬퍼들을 역할별 extension 으로 묶는다.
5. **`// MARK: - Interface` extension**: 외부(View)에 노출하는 `public`/`internal` 메서드(예: `load()`, `selectItem(at:)`)를 파일 맨 밑에 모은다. 호출자가 파일 끝에서 노출 API 만 빠르게 훑을 수 있게 한다.
