# دوري — Doory mobile (Flutter)

Flutter buyer storefront for Doory (دوري), the Homs shopping app. It follows the same product system, visual identity, and data-honesty rules as the web storefront in [Doory-Store/frontend](https://github.com/Doory-Store/frontend).

This is a separate project from the Next.js site. Do not copy web navigation or desktop layout literally. Adapt structure and components for a phone, and keep tokens, Arabic voice, and API contracts aligned.

## Docs to read first

1. `PRODUCT.md` — what Doory is, audience, scope, voice, and open business decisions.
2. `DESIGN.md` — color, type, geometry, RTL, mobile components, and the Flutter `ThemeData` mapping.
3. `AGENTS.md` — conventions for anyone (or any agent) changing this repository.
4. `design-plans/` — phased implementation plan, mirroring the web phases.

Design work starts only after `PRODUCT.md` and `DESIGN.md` have been read.

## Stack (current project)

- Flutter (stable) and Dart
- Material 3, configured with Doory tokens (light theme only)
- Arabic RTL as the default locale (`ar`)
- Cairo as the only text family (weights 400, 600, 700)
- A typed HTTP client against the same buyer API used by the web app

Recommended libraries are listed in `AGENTS.md`. Do not add packages merely to enforce these docs.

## Getting started

```bash
flutter pub get
flutter run
```

Point the app at the buyer API with a compile-time or runtime config value (never a public marketing claim about the host):

```bash
# Example host used by the web repo’s `.env.example`. Confirm the live base URL before shipping.
flutter run --dart-define=DOORY_API_BASE_URL=https://doory.elogyc.com/api/v1
```

Optional:

```bash
# Milliseconds. Web default is 4000 so a down API fails fast and can fall back to labelled demo data.
--dart-define=DOORY_API_TIMEOUT_MS=4000
```

If `DOORY_API_BASE_URL` is missing, treat it as an unavailable API (`network`), not as an empty catalog.

## Same system as the web app

The web storefront is Next.js 16 / React 19 / Tailwind 4. It talks to a **server-only** buyer API (`DOORY_API_BASE_URL`, never `NEXT_PUBLIC_`). The Flutter app must call that same API from the device. That is an intentional platform difference, not a license to invent auth, keys, or new endpoints.

Current buyer API access in the web client is unauthenticated `GET` with `Accept: application/json` and `Accept-Language: ar`. Do not add tokens, cookies, or user identity until an approved contract exists.

## Project layout (target)

See `DESIGN.md` § Flutter architecture and `design-plans/phase-0-api-foundation.md` for the folder map, theme, and HTTP/state conventions.

## Phases

Work proceeds in the same order as the web repo’s `cursor/phase-*` branches:

| Phase | Web branch (frontend, main-era) | Mobile goal |
| --- | --- | --- |
| 0 | `cursor/phase-0-api-foundation-876e` | Typed client, errors, models, health/meta, isolated demo fixtures |
| 1 | `cursor/phase-1-home-categories-43d4` | Home and category chrome |
| 2 | `cursor/phase-2-live-product-page-8ef2` | Live product detail |
| 3 | `cursor/phase-3-listing-search-e983` | Category listing and search |
| 4 | Planned on web (`storeHref` in `lib/links.ts`) | Store profile / «من نفس المتجر» |
| Later | Not built on web yet | Cart, checkout, and order tracking — only with approved API contracts and policies |

Details live under `design-plans/`.
