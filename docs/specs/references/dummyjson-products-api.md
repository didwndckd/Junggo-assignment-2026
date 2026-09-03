# DummyJSON Products API 응답 레퍼런스

> 도메인 모델(`Domain/Model`) 설계 근거로 사용한 실제 API 응답 예시. user가 대화 중 제공.

## 목록 API

```http
GET https://dummyjson.com/products
```

응답 예시 (`limit=30`, 전체 30개 중 일부 필드는 생략 없이 전체 그대로 기록):

```json
{
  "products": [
    {
      "id": 1,
      "title": "Essence Mascara Lash Princess",
      "description": "The Essence Mascara Lash Princess is a popular mascara known for its volumizing and lengthening effects. Achieve dramatic lashes with this long-lasting and cruelty-free formula.",
      "category": "beauty",
      "price": 9.99,
      "discountPercentage": 10.48,
      "rating": 2.56,
      "stock": 99,
      "tags": ["beauty", "mascara"],
      "brand": "Essence",
      "sku": "BEA-ESS-ESS-001",
      "weight": 4,
      "dimensions": { "width": 15.14, "height": 13.08, "depth": 22.99 },
      "warrantyInformation": "1 week warranty",
      "shippingInformation": "Ships in 3-5 business days",
      "availabilityStatus": "In Stock",
      "reviews": [
        {
          "rating": 3,
          "comment": "Would not recommend!",
          "date": "2025-04-30T09:41:02.053Z",
          "reviewerName": "Eleanor Collins",
          "reviewerEmail": "eleanor.collins@x.dummyjson.com"
        },
        {
          "rating": 4,
          "comment": "Very satisfied!",
          "date": "2025-04-30T09:41:02.053Z",
          "reviewerName": "Lucas Gordon",
          "reviewerEmail": "lucas.gordon@x.dummyjson.com"
        },
        {
          "rating": 5,
          "comment": "Highly impressed!",
          "date": "2025-04-30T09:41:02.053Z",
          "reviewerName": "Eleanor Collins",
          "reviewerEmail": "eleanor.collins@x.dummyjson.com"
        }
      ],
      "returnPolicy": "No return policy",
      "minimumOrderQuantity": 48,
      "meta": {
        "createdAt": "2025-04-30T09:41:02.053Z",
        "updatedAt": "2025-04-30T09:41:02.053Z",
        "barcode": "5784719087687",
        "qrCode": "https://cdn.dummyjson.com/public/qr-code.png"
      },
      "images": ["https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/1.webp"],
      "thumbnail": "https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/thumbnail.webp"
    }
  ],
  "total": 194,
  "skip": 0,
  "limit": 30
}
```

> 나머지 29개 아이템(`id` 2~30)도 필드 구조는 위와 완전히 동일하다. 다만 `groceries` 카테고리(`id` 16~30)는 `brand` 필드 자체가 응답에 없다 — `Product.brand`를 `String?`으로 설계한 근거.

## 상세 API

```http
GET https://dummyjson.com/products/{id}
```

응답 예시 (`id=1`):

```json
{
  "id": 1,
  "title": "Essence Mascara Lash Princess",
  "description": "The Essence Mascara Lash Princess is a popular mascara known for its volumizing and lengthening effects. Achieve dramatic lashes with this long-lasting and cruelty-free formula.",
  "category": "beauty",
  "price": 9.99,
  "discountPercentage": 10.48,
  "rating": 2.56,
  "stock": 99,
  "tags": ["beauty", "mascara"],
  "brand": "Essence",
  "sku": "BEA-ESS-ESS-001",
  "weight": 4,
  "dimensions": { "width": 15.14, "height": 13.08, "depth": 22.99 },
  "warrantyInformation": "1 week warranty",
  "shippingInformation": "Ships in 3-5 business days",
  "availabilityStatus": "In Stock",
  "reviews": [
    {
      "rating": 3,
      "comment": "Would not recommend!",
      "date": "2025-04-30T09:41:02.053Z",
      "reviewerName": "Eleanor Collins",
      "reviewerEmail": "eleanor.collins@x.dummyjson.com"
    },
    {
      "rating": 4,
      "comment": "Very satisfied!",
      "date": "2025-04-30T09:41:02.053Z",
      "reviewerName": "Lucas Gordon",
      "reviewerEmail": "lucas.gordon@x.dummyjson.com"
    },
    {
      "rating": 5,
      "comment": "Highly impressed!",
      "date": "2025-04-30T09:41:02.053Z",
      "reviewerName": "Eleanor Collins",
      "reviewerEmail": "eleanor.collins@x.dummyjson.com"
    }
  ],
  "returnPolicy": "No return policy",
  "minimumOrderQuantity": 48,
  "meta": {
    "createdAt": "2025-04-30T09:41:02.053Z",
    "updatedAt": "2025-04-30T09:41:02.053Z",
    "barcode": "5784719087687",
    "qrCode": "https://cdn.dummyjson.com/public/qr-code.png"
  },
  "images": ["https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/1.webp"],
  "thumbnail": "https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/thumbnail.webp"
}
```

> 목록 아이템과 상세 응답의 스키마가 완전히 동일하다 — `Domain/Model/Product`를 `ProductSummary`/`ProductDetail`로 나누지 않고 단일 모델로 통합한 근거.

## `availabilityStatus` 값 검증

샘플에는 `"In Stock"`, `"Low Stock"` 두 값만 등장했으나, 실제 서비스 전체 194개 상품을 `curl`로 조회해 확인한 결과 다음 3가지 값이 모두 존재함을 확인했다 (조회일: 2026-09-03):

```
GET https://dummyjson.com/products?limit=0&select=availabilityStatus
```

- `"In Stock"`
- `"Low Stock"`
- `"Out of Stock"`

→ `Domain/Model/AvailabilityStatus.swift`의 `inStock` / `lowStock` / `outOfStock` 3케이스 구성 근거.
