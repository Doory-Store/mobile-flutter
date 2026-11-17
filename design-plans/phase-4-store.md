# Phase 4 — Store profile

## Goal

A shopper can open a merchant’s store from the product page and browse that store’s catalog.

## Scope

- Route `/s/:slug`.
- Header: store name, description, and area label when present. Rating and review count when `average_rating` is non-null.
- Product grid reusing the listing card, paged from the store payload’s `products.meta`, with infinite scroll and pull-to-refresh.
- The PDP seller action («عرض المتجر») opens this route when a slug is present.
- `followers_count` / `is_followed` may be displayed as information. A follow action waits on a writable, approved contract; until then the control stays inactive.

## Screens

- Store profile (`/s/:slug`)
- Not-found for an unknown slug
- Retryable unavailable state when the host is down and no matching fixture exists

## Data

`GET /stores/{slug}` returns `id`, `name`, `slug`, `description`, `area_label`, `followers_count`, `is_followed`, `average_rating`, `reviews_count`, `share`, and a paginated `products` list of product cards.

## Acceptance

- Opening a store from a live product page shows that store’s name and its products, unlabelled.
- Optional fields that are absent leave the corresponding row out.
- Unknown slug → not-found. Unreachable host → labelled fixture or a retryable error.
- The same card, theme, and accessibility bar as listing.

## Risks

- Pagination may require a subsequent products request filtered by `store` if the detail payload is a first page only — confirm against the live response and reuse `GET /products?store=` when needed.
- Follow semantics could be mistaken for a live social feature; keep the control inactive until the contract exists.
