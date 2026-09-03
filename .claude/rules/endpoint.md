---
paths:
  - "**/Endpoint/**"
  - "**/Data/**"
---

## Endpoint 작성 규칙

- **파싱 모델 위치**: `Response`는 항상 해당 Endpoint의 `extension`으로 분리해 정의한다. 본체 선언과 응답 타입을 시각적으로 분리해 가독성을 확보한다. `Response` 내부 보조 타입(`Item` 등)은 `Response` 안에 중첩한다.
- **네이밍**: 프로퍼티는 카멜케이스로 작성한다. 서버 응답이 snake_case면 `CodingKeys`로 매핑한다.
- **파싱 로직**: `Response`와 내부 보조 타입(`Item` 등) **모두** `init(from:)`을 직접 구현해 디코딩 로직을 명시한다. 컴파일러 자동 합성에 의존하지 않는다.
- **기본값 정책**:
  - 필드 단위로 `try?`를 사용해 디코딩한다.
  - **필수 값**(예: `id`처럼 없으면 도메인적으로 무의미한 값)은 옵셔널(`Type?`)로 두고 `try?`로 디코딩한다. 누락 시 nil 유지.
  - **그 외 모든 값**은 기본값을 할당한다. (`String → ""`, `Int → 0`, `Bool → false`, 배열 → `[]` 등)
- **도메인 변환 (엔트리 단위)**: 내부 파싱 모델(`Item` 등)은 `func toDomain() -> <DomainModel>?` 메서드를 제공한다.
  - 유효성 검사가 필요한 케이스(필수 값이 nil 등)는 옵셔널 반환으로 표현하고 변환 시점에 nil을 리턴한다.
  - 리스트는 `compactMap { $0.toDomain() }`으로 무효 엔트리를 필터링한다.
- **도메인 변환 (응답 단위)**: `Response` 자체도 `toDomain()`을 제공해 호출 측이 내부 구조를 모르게 캡슐화한다.
  - 반환 타입은 응답 형태에 따라 결정: 리스트 응답 → `[DomainModel]`, 단일 응답 → `DomainModel?`.
  - 리스트/필터링 로직은 `Response.toDomain()` 내부에서 처리하고 Repository Impl은 호출만 한다.

### 예시

``` swift
struct FooEndpoint: Endpoint {
    // ... path, method 등
}

extension FooEndpoint {
    struct Response: Decodable {
        let items: [Item]

        enum CodingKeys: String, CodingKey {
            case items
        }

        init(from decoder: Decoder) throws {
            let c = try decoder.container(keyedBy: CodingKeys.self)
            self.items = (try? c.decode([Item].self, forKey: .items)) ?? []
        }

        func toDomain() -> [Foo] {
            items.compactMap { $0.toDomain() }
        }

        struct Item: Decodable {
            let id: String?         // 필수 값: 옵셔널 유지
            let name: String        // 그 외: 기본값 할당
            let itemCount: Int

            enum CodingKeys: String, CodingKey {
                case id, name
                case itemCount = "item_count"
            }

            init(from decoder: Decoder) throws {
                let c = try decoder.container(keyedBy: CodingKeys.self)
                self.id = try? c.decode(String.self, forKey: .id)
                self.name = (try? c.decode(String.self, forKey: .name)) ?? ""
                self.itemCount = (try? c.decode(Int.self, forKey: .itemCount)) ?? 0
            }

            func toDomain() -> Foo? {
                guard let id else { return nil }
                return Foo(id: id, name: name, itemCount: itemCount)
            }
        }
    }
}

// 사용 측 (Repository Impl)
let domainItems = response.toDomain()
```

