# Working in this repository

A short guide for contributors and coding agents. Product intent lives in `PRODUCT.md`. Visual and interaction decisions live in `DESIGN.md`. Read both before changing the interface.

The official mobile UI reference is the Trendyol app, as specified in `DESIGN.md` (Design reference: Trendyol). All UI work — new screens, redesigns, and visual tweaks — must follow that reference. Before designing or changing a screen, open the matching captures in `C:\Users\bahaa\Desktop\Doory\trendyol-ref\screens` (PNG, `small/*.jpg` thumbnails, and UI Automator XML) and match layout, chrome, and component patterns as closely as possible, adapted for RTL, formal MSA, and Doory’s brand tokens. Do not invent a parallel visual language.

## Everyday commands

```bash
flutter pub get
flutter run --flavor dev --dart-define=DOORY_API_BASE_URL=https://doory.elogyc.com/api/v1
dart format .
flutter analyze
flutter test
flutter test --update-goldens   # only when a visual change is intentional
```

Generate models after a contract change:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Layout of the code

- `lib/app/` — `MaterialApp.router`, flavors, go_router.
- `lib/core/theme/` — tokens, `DooryTokens` ThemeExtension, `dooryTheme()`.
- `lib/core/network/` — Dio, interceptors, `ApiException`.
- `lib/core/config/` — `--dart-define` and flavor values.
- `lib/core/widgets/` — shared chrome (demo label, maintenance banner, skeletons, buttons).
- `lib/data/models/` — freezed buyer DTOs and UI models.
- `lib/data/repositories/` — one repository per aggregate (home, catalog, search, product, meta).
- `lib/data/demo/` — labelled sample fixtures, imported by repositories, not by widgets.
- `lib/features/<name>/` — screens, feature widgets, and providers for that area.
- `test/unit`, `test/widget`, `test/golden`.

New UI belongs in the feature it serves. Tokens and HTTP stay in `core/`.

## Conventions

**Theme.** Storefront widgets read color, type, radius, and spacing from `Theme.of(context)` and `DooryTokens`. Named styles (`DooryTypography.cardPrice`, and the rest) stay on the scale in `DESIGN.md`.

**Design reference.** Follow the Trendyol patterns in `DESIGN.md`. Check the matching `trendyol-ref/screens` capture before building or restyling a screen. Prefer the documented Trendyol layout (segment chips, search-and-login row, banner carousel, photo category grid, brands row, popular-products grid, five-tab bar) over older pastel-circle shortcuts or a wordmark-led home app bar.

**Direction.** The app is `Locale('ar')` with `TextDirection.rtl`. Use directional insets and alignment. Carousels start at the inline start. Directional chevrons flip; wordmark, photos, and search/cart/rating icons stay as drawn.

**Copy.** Formal MSA. Reuse the terms in `PRODUCT.md`. New strings go through `lib/core/l10n/` (or the project’s ARB files) so wording stays consistent.

**Networking.** One Dio client, 4s default timeout, `Accept: application/json`, `Accept-Language: ar`. Repositories return `ok` / `unavailable` / `rejected` / `notFound`. Widgets switch on that result: live data, a labelled fixture when the host is unreachable, a not-found screen, or a retryable error. `GET /search` is called only with a non-empty `q`. Price filters are sent only when the range is valid.

**Models.** Buyer payloads are freezed + json_serializable, aligned with API v0.2.0. `price_syp` is `int?`. Optional fields are nullable and omitted in the UI when null. Ids and slugs come from the API.

**State and routing.** Riverpod for state; providers call repositories. go_router for `/`, `/search`, `/c/:slug`, `/p/:ref`, and `/s/:slug`. Cancel in-flight requests when a route is disposed.

**Platform.** Honor safe areas, system text scale, Android predictive back, and iOS back swipe. Targets are 44–48 dp.

## Known endpoints

`GET /health`, `/meta/status`, `/cities`, `/categories`, `/home`, `/products`, `/products/{id}`, `/search`, `/stores/{slug}`.

List and search query parameters: `category`, `store`, `brand` (search), `sort` (`newest` | `price_asc` | `price_desc`), `min_price_syp`, `max_price_syp`, `city_id` (search), `page`, `per_page`. Search requires `q`.

## Definition of done

A change is ready for review when all of the following hold:

- `dart format` and `flutter analyze` are clean; new behavior has unit, widget, or golden coverage as it fits.
- The UI uses theme tokens, follows the Trendyol reference in `DESIGN.md` (checked against the matching `trendyol-ref` capture for visual changes), and remains readable in RTL at a large text scale, without overflow or horizontal page scroll.
- Loading, empty, and error states are present; pull-to-refresh works on data screens.
- Prices, discounts, ratings, and delivery lines match the Principles in `PRODUCT.md`. Sample content shows «بيانات تجريبية».
- Networking stays on the contracted GET surface; auth, cart, and checkout changes belong to a later phase with an approved contract.
- Goldens are updated only with a short note in the pull request describing the visual change.
