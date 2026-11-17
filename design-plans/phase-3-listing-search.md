# Phase 3 — Listing and search

## Goal

A shopper can browse a category and search the catalog, with sort, a price range, and infinite scroll, all backed by the live list and search endpoints.

## Scope

- Category listing at `/c/:slug`.
- Search at `/search?q=`, opened from the home search field.
- Phone UI: title, result count, sort sheet (`newest`, `price_asc`, `price_desc`), price-range filter, child-category chips or a side tree, a two-column grid that relaxes if text needs width, infinite scroll, pull-to-refresh.
- Reuse the phase-1 product card. Currency label «ل.س».
- Query state is structured in the route (`sort`, `min`, `max`, `page` recovery) and in a Riverpod notifier — not parsed from visible copy.

**Category loader**

- The live tree wins when the slug exists.
- Parent categories show child tiles; a zero count is omitted for parents that are only hubs.
- `GET /products` with `category`, `sort`, `min_price_syp`, `max_price_syp`, `page`, `per_page` (24).
- A request past `last_page` is clamped to the last page.
- An inverted price range stays on the device; the API is not called with it (it would be a 422).
- `rejected` keeps an empty live shell and explains the error.
- `unavailable` uses a labelled sample listing for that slug when one exists; otherwise the shell stays up with a retryable unavailable message.

**Search loader**

- An empty `q` stays on the empty-search state («اكتب اسم منتج أو فئة في مربع البحث») and suggestions; the client is not called.
- Live hits use the title «نتائج البحث عن «{q}»» and `meta.total`. Category facets join bucket ids to `/categories` names.
- When `search.degraded` is true, a quiet notice explains that results may be incomplete.
- Zero hits without extra filters show a dedicated empty state and a path back into categories.
- `rejected` and `unavailable` follow the same split as listing.

## Screens

- Category listing (`/c/:slug`)
- Search (`/search?q=`)
- Shared sort sheet and price-filter sheet
- Not-found for an unknown slug with no fixture

## Data

- `GET /products` — list + `meta`
- `GET /search` — `q`, facets (`category` ids + counts), `search.degraded`, list + `meta`
- `GET /categories` — names for facets and the tree

Brand and store facets are ids in the payload. They appear in the UI once names can be resolved; until then the category facet is the one that is shown.

## Acceptance

- A live category slug lists real products, a truthful count, and loads further pages up to `last_page`.
- An empty search query makes no network call.
- A 422-class rejection keeps the live shell and does not swap in sample products.
- An unreachable host is labelled sample content or an unavailable message — not a real “zero products in this category” result.
- Pull-to-refresh resets to page 1. Infinite scroll does not fire past `last_page`.
- Widget tests cover empty query, zero hits, degraded notice, and error; a golden locks a two-column grid.

## Risks

- Filter + pagination race conditions: cancel the previous Dio request when sort or price changes.
- Facet ids without names — show category facets first, as planned.
- Two-column grids at large text scales: allow the grid to drop to one column rather than clipping Arabic titles.
