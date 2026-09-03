---
paths:
  - "**/Data/**"
---

# 데이터 룰

## 폴더 구조

```
Data/
├── Network/
├── Repository/
└── Endpoint/
```

## 규칙

- Repository Impl 명명: `<이름>RepositoryImpl`이 Domain의 `<이름>Repository` protocol을 구현.
- Endpoint 위치: `Data/Endpoint/`.
- DTO ↔ Domain Model 매핑: Repository Impl 내부에서 변환. DTO와 Domain Model은 별도 타입으로 분리.
