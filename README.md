# دوري — Doory

A Flutter shopping app for customers in Homs, Syria. The shared brand identity and buyer API come from the Doory storefront at [Doory-Store/frontend](https://github.com/Doory-Store/frontend); this repository is the mobile product, designed and structured as a native app.

The app is Arabic-first and right-to-left. People open it to find a product, understand the price and the offer, and — once those flows are contracted — complete a purchase and follow the order through to delivery.

## Documentation

| File | Contents |
| --- | --- |
| [PRODUCT.md](PRODUCT.md) | Product, audience, voice, principles, and open decisions |
| [DESIGN.md](DESIGN.md) | Design system, Flutter theme, navigation, and mobile UX |
| [AGENTS.md](AGENTS.md) | How to work in this repository |
| [design-plans/](design-plans/) | Phased engineering plans |

Read `PRODUCT.md` and `DESIGN.md` before changing the interface.

## Stack

These are deliberate defaults for a catalog app with a typed backend and a dense, branded UI:

| Choice | Why |
| --- | --- |
| Flutter stable + Dart 3 | One codebase for Android and iOS, solid RTL and text-shaping support |
| Riverpod | Feature-scoped state, easy test overrides, no build-method networking |
| go_router | Deep links (`/p/:ref`, `/c/:slug`, `/search?q=`), typed routes, shell routes later |
| Dio | Timeouts, interceptors for errors and `Accept-Language`, cancel tokens on dispose |
| freezed + json_serializable | Immutable API models that match the buyer contract, cheap copy/equality |
| cached_network_image | Disk/memory cache and fade-in for product photography on modest networks |
| google_fonts only as a dev fallback | Cairo is bundled under `assets/fonts/` so typography works offline |
| flutter_lints (or very_good_analysis) | Consistent review bar on every PR |

## Architecture

Feature-first folders. Shared infrastructure lives in `core/` and `data/`; screens and widgets live next to the feature they belong to.

```
lib/
  main.dart
  app/
    app.dart              # MaterialApp.router, locale, theme
    router.dart           # go_router table
    bootstrap.dart        # ProviderScope, flavor, logging
  core/
    theme/                # tokens, ThemeExtension, ThemeData
    network/              # Dio client, interceptors, ApiException
    config/               # Env from --dart-define and flavors
    widgets/              # DemoLabel, MaintenanceBanner, skeletons, buttons
    l10n/                 # Approved MSA strings
  data/
    models/               # freezed buyer models
    repositories/         # one repository per aggregate
    demo/                 # labelled sample fixtures
  features/
    home/
    categories/
    listing/
    search/
    product/
    store/                # phase 4
    cart/                 # later
assets/fonts/             # Cairo 400 / 600 / 700
test/
  unit/
  widget/
  golden/
```

**Data flow.** Widgets watch Riverpod providers. Providers call repositories. Repositories call the Dio client and map DTOs into UI models. UI models keep money, ids, and optional fields structured; visible labels are derived from those values.

**Environment.** Base URL and timeout come from compile-time defines. The defaults are the buyer host and 4000 ms, so a missing define still runs. An empty base URL is treated as a network failure.

```bash
flutter run
# --dart-define=DOORY_API_BASE_URL=https://doory.elogyc.com/api/v1
# --dart-define=DOORY_API_TIMEOUT_MS=4000
# --dart-define=DOORY_FLAVOR=dev
```

`DOORY_FLAVOR` is `dev`, `staging`, or `prod`. Application-id suffixes are not wired yet (`INCOMPLETE.md`).

**HTTP.** The current buyer API is unauthenticated `GET`. The client sends `Accept: application/json` and `Accept-Language: ar`, strips a trailing slash on the base URL, and maps status codes onto a single `ApiException` (`notFound`, `validation`, `unauthorized`, `forbidden`, `rateLimited`, `network`, `server`, `unknown`). Repositories expose a result type: `ok`, `unavailable`, `rejected`, or `notFound`.

**Testing.** Unit tests cover the client, error mapping, and repositories (Dio via `http_mock_adapter` or a fake). Widget tests cover the product card, search empty/error states, and the maintenance banner. Golden tests lock the card, a shelf row, and the light theme at a 390-wide logical size, with Cairo loaded from assets. CI runs `dart format --output=none --set-exit-if-changed`, `flutter analyze`, and `flutter test` on every pull request.

## Getting started

Flutter 3.50 / Dart 3.14. Cairo is bundled under `assets/fonts/`, so the UI does not need a network just to draw type.

The default API base URL is `https://doory.elogyc.com/api/v1` and the default timeout is 4000 ms. `flutter run` reaches that host with no flags.

```bash
flutter pub get
flutter run
```

Optional overrides:

```bash
flutter run \
  --dart-define=DOORY_API_BASE_URL=https://doory.elogyc.com/api/v1 \
  --dart-define=DOORY_API_TIMEOUT_MS=4000 \
  --dart-define=DOORY_FLAVOR=dev
```

`DOORY_FLAVOR` is `dev`, `staging`, or `prod`. It is compile-time configuration only. Android and iOS product flavors are not wired yet, so `--flavor` is not accepted. See `INCOMPLETE.md`.

After launch, open **حسابي** then **حالة الاتصال**. That screen shows the base URL, the `GET /health` result, and the round-trip latency.

Checks used while building this slice:

```bash
dart format .
flutter analyze
flutter test
```

Requires the Flutter stable toolchain and a configured Android emulator or device (iOS on macOS). `flutter build apk --debug` builds the Android debug APK.

## Live and sample data

The catalog (home, categories, product, listing, search, store profile) and sign-in read the live buyer API. Cart, addresses, checkout, orders, notifications, reviews, and support run on Mock repositories whose fixtures follow the backend OpenAPI schemas, and those screens carry the «بيانات تجريبية» badge. Actions that need the server, such as placing a real order or submitting payment proof, open a «لم يتم الربط بعد» dialog. The sample coupon is `DOORY10`.

Each domain switches from Mock to Live in `lib/data/repositories/commerce/commerce_providers.dart`. Sign-in follows `DOORY_AUTH`: `live` (default) or `mock`, the offline demo that accepts `482910`. See `design-plans/phase-5-full-ui-mock.md`.

## Authentication and security

Sign-in uses the buyer API: `POST /auth/otp` → `POST /auth/otp/verify`, or `POST /auth/login` with a password, then `GET /me`, `PATCH /me` and `POST /auth/logout`. The code lives in `lib/data/repositories/commerce/live_auth_repository.dart`, `lib/core/auth/` and `lib/core/network/`.

- **Secure storage only.** The Sanctum bearer token and the profile snapshot live in `flutter_secure_storage`: Android Keystore (RSA-OAEP wrapped AES-GCM) and the iOS Keychain with `first_unlock_this_device`. The token stays on this device, stays readable for background work after the first unlock, and never appears in `shared_preferences`. Sessions from earlier builds are deleted from `shared_preferences` on start.
- **Token scoped to the API origin.** `AuthInterceptor` adds `Authorization: Bearer` only when scheme, host, port and the `/api/v1` path all match the configured base URL. Image hosts and third parties receive no credential, a hand-set header is stripped from them, and authenticated calls do not follow redirects.
- **401 ends the session.** Tokens last 30 days and the API has no refresh endpoint, so a 401 on an authenticated call wipes the token and opens sign-in with «انتهت جلستك». A restored session is confirmed with `GET /me` at launch.
- **Logout is server-side first.** `POST /auth/logout` revokes the token, and the device wipes secure storage whether or not the server was reachable.
- **Redacted, debug-only logs.** `RedactingLogInterceptor` runs only in debug builds and masks the Authorization header, tokens, one-time codes, passwords and phone numbers. `ApiException` and stored-session `toString()` carry no secrets.
- **HTTPS only in release.** A release build drops any non-https base URL. Android declares a network security config with clear text disabled and system CAs only; debug and profile builds additionally reach `10.0.2.2`/`localhost` over http for a local backend.
- **No backup of credentials.** `android:allowBackup="false"`, and the backup and data-extraction rules exclude the secure-storage files from cloud backup and device-to-device transfer, following the `flutter_secure_storage` guidance.
- **Phone numbers match the server.** `normalizeSyrianMobile` mirrors the backend `PhoneNormalizer`, so the number the app sends is the one the server throttles and verifies.
- **Server limits shown honestly.** A code is valid for 5 minutes; a phone may request 3 codes per 15 minutes and verify 10 times per 15 minutes. The screen counts down the resend button, shows the remaining requests from `X-RateLimit-Remaining`, and turns a 429 into an Arabic message with the `Retry-After` wait.
- **No secrets in the app.** The app ships no credentials or test numbers. A server-provided `simulation_code` appears only in debug builds, labelled as a test code.

## Delivery plan

Work ships in slices. Details are in `design-plans/`.

0. API foundation, theme, and environment
1. Home and category browsing
2. Product detail
3. Category listing and search
4. Store profile
5. Full interface on swappable data (catalog live, commerce on labelled samples). Wiring cart, checkout, and orders as their API contracts land
