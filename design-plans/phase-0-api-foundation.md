# Phase 0 — API foundation

Web counterpart: branch `cursor/phase-0-api-foundation-876e` and the files under `lib/api/` in [Doory-Store/frontend](https://github.com/Doory-Store/frontend).

## Goal
A typed, testable buyer-API layer and an isolated demo-fixture library, with no feature UI beyond a thin smoke screen (theme + a health/maintenance read). After this phase, every later screen can load live data through the same contracts.

## Ship
- Folder skeleton from `DESIGN.md` §17 (`lib/app`, `lib/core/theme`, `lib/core/api`, `lib/data/demo`, `lib/data/repositories`).
- `DooryColors`, typography, radii, spacing, shadows, and `dooryTheme()` as specified in `DESIGN.md` §16. `MaterialApp` in Arabic RTL, Cairo loaded.
- `ApiClient.apiGet<T>` mirroring web `lib/api/client.ts`:
  - `DOORY_API_BASE_URL` (required; trailing slash stripped)
  - `DOORY_API_TIMEOUT_MS` (default 4000)
  - `Accept: application/json`, `Accept-Language: ar`
  - JSON parse, field-error extraction from `errors`, message from `message`
- `ApiError` and `isApiUnavailable` mirroring web `lib/api/errors.ts`.
- Dart models aligned with web `lib/api/types.ts` (buyer API v0.2.0): `BuyerProductCard`, `BuyerProductDetail`, `BuyerCategory`, `BuyerHome`, `BuyerSearchResponse`, `BuyerStoreDetail`, `BuyerCity`, `BuyerMetaStatus`, `BuyerHealthResponse`, list/search params and `BuyerListSort`.
- Endpoint wrappers: `getHealth`, `getMetaStatus` / `readMetaStatus`, `getCities` / `readCities`, `getCategories` / `readCategories`, `getHome` / `readHome`, `getProduct` / `readProduct`, `getProducts` / `readProducts`, `getSearch` / `readSearch`, `getStore` / `readStore`. Safe readers never cache a failure as success.
- Result types: `ok` | `unavailable` | `rejected` | `not_found`, as in web `lib/api/products.ts` and `lib/api/search.ts`.
- Link helpers equivalent to web `lib/links.ts`: `productRef`, `categoryHref`, `storeHref`, `searchHref`. Do not invent slugs.
- Isolated labelled fixtures under `lib/data/demo/`, plus a shared `demoLabel` of “بيانات تجريبية”.
- Maintenance strip widget wired to `readMetaStatus()` (omit on failure).
- Unit tests for URL building, error mapping, and “demo only when unavailable”.

## Do not ship in this phase
- Home shelves, listing, search UI, or a full PDP.
- Auth, POST endpoints, cart, or checkout.
- A bottom navigation bar.
- Dark mode.

## Done when
- The app launches RTL with Cairo and the orange primary on a placeholder scaffold.
- A missing base URL or a forced timeout is reported as `unavailable`, not as an empty catalog.
- A mocked 422 is `rejected`, not demo.
- `/health` and `/meta/status` can be read against the configured host.
