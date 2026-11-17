# Agent conventions — Doory mobile (Flutter)

<!-- Keep this file short, imperative, and easy to follow in a new session. -->

## This is a Flutter app, not the Next.js storefront

This repository is the buyer **mobile** app. The sibling web app is [Doory-Store/frontend](https://github.com/Doory-Store/frontend). Share product rules, visual tokens, and the buyer API contract with that repo. Do not paste web components, CSS class names, or desktop layout blindly into Dart.

## Design and product first

Before proposing, changing, or reviewing an interface, read `PRODUCT.md` and `DESIGN.md`. Design work starts only after both files have been read.

Those files do not authorize new tools, servers, analytics, or business-policy decisions.

## Visual identity

- Use the token classes in `lib/core/theme/` (`DooryColors`, `DooryTypography`, `DooryRadii`, `DoorySpacing`, `DooryShadows`, and `dooryTheme()`).
- Do not hardcode brand hex values (`#F27A1A`, `#C2410C`, and the rest) inside feature widgets.
- Do not restore `#B95800` as a fill, price, or active color.
- Do not use Plus pink `#FF4988` as a brand, price, or action color.
- Light theme only. Do not add `themeMode` / a dark `ColorScheme` until tokens exist.
- Cairo is the only text family, at weights 400, 600, and 700. `letterSpacing` stays 0 on Arabic text.
- Default `Card` elevation is 0. Apply only the documented shadow tokens.
- Minimum touch target: 44×44. Honor safe areas and `MediaQuery.disableAnimations`.

## Arabic, RTL, and copy

- Default locale is `ar`. The tree is `TextDirection.rtl`.
- Use formal, contemporary MSA. Be concise, direct, helpful, and respectful.
- Reuse approved terms: “تصفّح الفئات”, “عرض الكل”, “إضافة إلى السلة”, “متابعة التسوق”, “ابحث عن منتج أو فئة”, “وصل حديثًا”, “مختارات”. Use “مختارة لك” only when personalization actually exists.
- Use logical directional APIs (`EdgeInsetsDirectional`, `AlignmentDirectional`, `PositionedDirectional`). Do not hardcode left/right insets.
- Mirror directional chevrons only. Do not mirror the wordmark, logos, product photos, or nondirectional search/cart/heart/account icons.
- Isolate Latin brand names, SKUs, and prices when mixed with Arabic.
- Currency label is “ل.س”. Do not invent a currency format or a numeral system policy; confirm before changing the current Latin-digit practice.
- Explain errors with a next step. Never blame the customer.

## Data honesty

- Never invent deals, ratings, reviews, badges, coupons, banners, counts, delivery promises, or payment methods.
- Favorites are not a feature. Do not persist a heart or present it as a wishlist.
- Missing optional fields are omitted; do not substitute zeros, empty stars, or fake reassurance.
- `price_syp == null` is a missing price, not `0`.
- Do not convert “API unavailable” into “نفدت الكمية” or an empty real catalog.
- Visible “بيانات تجريبية” on every fixture surface. Fixtures live under `lib/data/demo/` and stay out of widgets and out of the HTTP client.
- Do not lock unresolved `PRODUCT.md` §13 policies into copy, totals, or widget defaults.

## API client rules

Mirror `lib/api/client.ts` and `lib/api/errors.ts` from the web repo.

- Single client. `GET` against `DOORY_API_BASE_URL` (example documented in the web `.env.example`: `https://doory.elogyc.com/api/v1`). Strip a trailing slash. Do not invent hosts or endpoints.
- Headers: `Accept: application/json`, `Accept-Language: ar`. No auth header until a contract exists.
- Default timeout: 4000 ms.
- Missing base URL is a `network` error, not an empty success.
- Error kinds: `not_found`, `validation`, `unauthorized`, `forbidden`, `rate_limited`, `network`, `server`, `unknown`. Map 404 / 422 / 401 / 403 / 429 / 5xx the same way the web client does.
- `unavailable` (network, 5xx, missing base URL) may fall back to a **matching** labelled fixture. `rejected` live responses (including 422) must not.
- Live product 404 → not-found screen. Never an unrelated demo product.
- A live id with the API down and no matching fixture → “صفحة المنتج غير متاحة بعد”, not a fake product.
- Do not call `GET /search` with an empty `q` (422). Do not send an inverted price range (422).
- Do not add `POST` / cart / checkout / auth calls until the contract is approved and documented.
- The web app keeps this API server-only (`import "server-only"`, no `NEXT_PUBLIC_`). The Flutter app must call it from the device. That is the only intended difference. Do not embed secrets.

Known buyer endpoints (web `lib/api/*`):

- `GET /health`
- `GET /meta/status`
- `GET /cities`
- `GET /categories`
- `GET /home`
- `GET /products` (query: `category`, `store`, `sort`, `min_price_syp`, `max_price_syp`, `page`, `per_page`)
- `GET /products/{id}`
- `GET /search` (query: `q` required, plus `category`, `brand`, `store`, `sort`, `min_price_syp`, `max_price_syp`, `city_id`, `page`, `per_page`)
- `GET /stores/{slug}`

`sort` values: `newest`, `price_asc`, `price_desc`. Types are aligned with buyer API v0.2.0 in web `lib/api/types.ts`.

Maintenance: show `maintenance.message.ar` when `maintenance_active` is true. If `/meta/status` fails, omit the strip.

## Architecture conventions

- Keep data access, mapping, and policy out of visual widgets.
- Repositories return explicit result types (`ok` / `unavailable` / `rejected` / `notFound`).
- One widget, one job. Typed contracts for cards, shelves, and PDP sections.
- Recommended state: Riverpod. Recommended HTTP: a thin Dio (or `http`) wrapper. Recommended routing: `go_router`. Alternatives are fine if consistent; do not add a stack of overlapping libraries.
- Do not install packages, generate code, or change architecture merely to enforce these docs.
- Do not invent product or store slugs; the backend owns transliteration (web `lib/links.ts`).

## Flutter / Dart quality

- Write null-safe, formatted Dart (`dart format`). Follow `analysis_options.yaml` / `flutter_lints`.
- Prefer `const` constructors. Avoid work in `build()` that belongs in a repository or `Notifier`.
- Handle text scaling and long Arabic strings; do not overflow.
- Give interactive widgets `Semantics` labels. Icon-only buttons need names.
- Keep feature folders independent of each other except through `core/` and `data/`.

## Scope discipline

- MVP is home, categories, listing, search, and product detail — the surfaces the web app has already wired.
- Cart, checkout, tracking, account, wallet, and a fixed bottom nav wait on approval and contracts.
- Seller, merchant, and admin work is out of scope.
- When in doubt, omit the module rather than decorating the gap.

## Confirmation checklist

- Confirm unsettled typography, numeral/currency formatting, cart-count convention, and bottom-nav proposals with Hamza before treating them as decided.
- Keep `PRODUCT.md` business-policy questions open.
