# Phase 3 — Listing and search

Web counterpart: branch `cursor/phase-3-listing-search-e983`, plus `lib/listing/*`, `app/ar/c/[slug]/page.tsx`, `app/search/page.tsx`, and `components/listing/*` in the frontend repo.

## Goal
Category listing and search use the live catalog, with the same honesty rules as the web loaders.

## Ship
- Category route `/c/:slug` using `loadCategoryListing` rules from web `lib/listing/load-category-listing.ts`:
  - Live category tree wins over a colliding demo id.
  - Parent categories can show child tiles and omit a zero product count.
  - `GET /products` with `category`, `sort`, `min_price_syp`, `max_price_syp`, `page`, `per_page` (default page size 24).
  - `sort`: `newest`, `price_asc`, `price_desc`.
  - If the requested page is past `last_page`, clamp and refetch the last page.
  - Inverted price range: do not call the API (it is a 422); keep the live shell.
  - `rejected` → live shell, no demo swap.
  - `unavailable` → labelled demo listing for that slug if it exists; otherwise the live shell with an empty product grid and an honest unavailable explanation — not “no products in this category” presented as a real empty catalog.
  - Unknown slug with no demo → not-found.
- Search route `/search?q=` using `loadSearchListing` rules from web `lib/listing/load-search-listing.ts` and `app/search/page.tsx`:
  - Empty `q`: do not call `GET /search`. Show the empty-search hint “اكتب اسم منتج أو فئة في مربع البحث”, plus suggestions/top categories only if they are real or labelled demo.
  - Live results: title “نتائج البحث عن «{q}»”, count from `meta.total`, category facets joined to `/categories` names (facet buckets are ids only).
  - `search.degraded`: show a quiet, honest notice that results may be incomplete — do not hide it and do not invent a better result set.
  - Zero hits without extra filters: empty state, suggestions, and optional labelled sample cards — not fake “popular” claims.
  - `rejected` → empty live search shell.
  - `unavailable` → labelled demo search for that query.
- Listing UI (phone): heading, count, sort sheet, price filters, category tree/child chips, product grid (two columns unless Arabic needs more width), paging or pull-to-load that respects `last_page`.
- Reuse the phase-1 product card. Currency label “ل.س”.
- Query parsing stays structured (not parsed from visible copy), matching web `lib/listing/filter.ts`.

## Do not ship in this phase
- Brand/store facet UI unless the API names are actually resolved (search facets for brand/store are ids; do not display raw ids as if they were names).
- Cart or bottom nav.

## Done when
- A live category slug lists real products with a truthful count and pager.
- An empty search query never hits the network.
- A 422-class rejection does not suddenly display demo products.
- A down API is labelled “بيانات تجريبية” or explained as unavailable, never as a real zero-result catalog.
