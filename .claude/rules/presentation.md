---
paths:
  - "**/Presentation/**"
---

## 폴더 구조

```
<화면명>/
├── ViewModel/
└── View/
```

- `<화면명>/ViewModel/`, `<화면명>/View/`는 화면 작성 시점에 생성한다 (가이드 트리).

## ViewModel 공통

- ViewModel은 `final class`로 선언.

## SwiftUI

- ViewModel은 `@MainActor`로 격리하고 `@Observable` 매크로를 채택한다 (`ObservableObject`/`@Published` 사용 금지). 출력 상태는 `private(set) var` 권장 — Toggle/TextField 등 양방향 바인딩이 필요한 경우에 한해 `var`로 노출.
- View는 자기 ViewModel 외 Repository/Network 등 외부 의존을 직접 호출하지 않는다 — 모든 사이드이펙트는 ViewModel 메서드를 통해.
- View가 ViewModel을 처음 생성하는 경우 `@State`로 보관. 부모로부터 주입받는 경우 일반 `let`/`var` 프로퍼티로 보관하고, 하위 View에 `$`로 양방향 바인딩을 전달해야 할 때만 `@Bindable`로 감싼다.
- View → ViewModel 입력은 ViewModel 메서드 직접 호출. 화면 진입 시 비동기 트리거는 `.task` modifier 사용 (`onAppear` + `Task { }`는 화면 dismiss 시 자동 취소 안 됨).
