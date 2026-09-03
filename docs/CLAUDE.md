## 기술 스택

| 카테고리 | 선택 |
| --- | --- |
| UI | SwiftUI |
| 반응형 | Combine |
| 비동기 | Swift Concurrency |
| 네트워크 | URLSession |

## 아키텍처 구조

이 프로젝트는 **클린 아키텍처**를 따른다.

레이어 루트:
- Presentation: `Junggo-assignment-2026/Presentation`
- Domain: `Junggo-assignment-2026/Domain`
- Data: `Junggo-assignment-2026/Data`
- Common: `Junggo-assignment-2026/Common`

```
Presentation/
└── <화면명>/
    ├── ViewModel/
    └── View/
Domain/
├── Model/
├── Repository/
└── UseCase/   # Optional
Data/
├── Network/
├── Repository/
└── Endpoint/
Common/
└── DateFormatter/
```

의존 방향: `Presentation → Domain ← Data`

`Common`은 특정 레이어에 속하지 않고 여러 레이어에서 공유하는 유틸리티(날짜 포매터 등)를 모아둔다. 모든 레이어에서 참조할 수 있다.

## Git 워크플로

- 브랜치 머지 시 fast-forward를 사용하지 않고 항상 `--no-ff`로 머지해 브랜치 이력을 보존한다.
  - 예: `git merge --no-ff <브랜치명>`
