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
```

의존 방향: `Presentation → Domain ← Data`
