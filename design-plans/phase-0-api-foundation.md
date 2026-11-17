# Phase 0 — API foundation

## Goal

A bootable app with the Doory theme, a typed HTTP layer, environment configuration, and a maintenance banner. Every later screen will load data through this layer.

## Scope

- Repository skeleton as in the root `README.md` (`app/`, `core/`, `data/`, `features/`, tests).
- Cairo bundled; `dooryTheme()`, `DooryTokens`, and `MaterialApp.router` in Arabic RTL.
- App shell: go_router `StatefulShellRoute.indexedStack` with the five-tab `NavigationBar` (Home, Categories, Favorites, Cart, Account; Home on the right) and an empty-state root screen for each tab, as specified in `DESIGN.md` §5.
- Flavors `dev`, `staging`, `prod` and `--dart-define` for `DOORY_API_BASE_URL` and `DOORY_API_TIMEOUT_MS` (default 4000).
- Dio client with interceptors: JSON headers, `Accept-Language: ar`, timeout, status mapping onto `ApiException`.
- freezed models for the buyer contract v0.2.0: product card and detail, category, home, search response, store, city, health, meta status, list params, and `sort`.
- Repositories with a four-way result (`ok`, `unavailable`, `rejected`, `notFound`) for health, meta, cities, categories, home, products, search, and stores.
- Route helpers for `/`, `/search`, `/c/:slug`, `/p/:ref`, `/s/:slug`. `ref` is a leading numeric id.
- Labelled fixtures under `data/demo/`.
- Maintenance banner bound to `GET /meta/status` (`maintenance_active` + `message.ar`).
- Unit tests for URL building, error mapping, and the unavailable-versus-rejected split.

Out of this slice: home shelves, listing, search UI, and a full product page. Those are phases 1–3.

## Screens

A scaffold with the wordmark, theme applied, and the maintenance banner when the API reports an active window. Enough to prove flavors, RTL, and the client.

## Data

| Method | Path | Used for |
| --- | --- | --- |
| GET | `/health` | Smoke / readiness |
| GET | `/meta/status` | Maintenance banner |
| GET | `/cities` | Later city context |
| GET | `/categories` | Ready for phase 1 |
| GET | `/home` | Ready for phase 1 |
| GET | `/products`, `/products/{id}` | Ready for phases 2–3 |
| GET | `/search` | Ready for phase 3 |
| GET | `/stores/{slug}` | Ready for phases 2 and 4 |

## Acceptance

- The bottom bar shows the five tabs in RTL order with Home on the right; each tab keeps its own stack, and re-tapping the active tab returns to its root.

- `flutter run --flavor dev --dart-define=DOORY_API_BASE_URL=…` launches RTL, Cairo, and the orange primary.
- A missing base URL or a forced timeout surfaces as `unavailable`.
- A mocked HTTP 422 surfaces as `rejected`.
- `/health` and `/meta/status` succeed against the configured host; an active maintenance window shows the banner, and a failed status request simply hides it.
- Format, analyze, and unit tests pass in CI.

## Risks

- Certificate pinning and environment mix-ups between flavors — keep application ids and base URLs distinct.
- Android/iOS flavor wiring is easy to leave half-done; both platforms ship in this phase.
- 4s timeout may be tight on very slow networks; it is the intended fail-fast default and can be overridden per define.
