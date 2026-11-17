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
 catalog (home, categories, product, listing, search, store profile) reads the live buyer API. Cart, login, profile, addresses, checkout, orders, notifications, reviews, and support run on Mock repositories whose fixtures follow the backend OpenAPI schemas, and those screens carry the «بيانات تجريبية» badge. Actions that need the server, such as placing a real order or submitting payment proof, open a «لم يتم الربط بعد» dialog. The sample OTP is `482910` and the sample coupon is `DOORY10`.
 domain switches from Mock to Live in `lib/data/repositories/commerce/commerce_providers.dart`. See `design-plans/phase-5-full-ui-mock.md`.

## Delivery plan

Work ships in slices. Details are in `design-plans/`.

0. API foundation, theme, and environment
1. Home and category browsing
2. Product detail
3. Category listing and search
4. Store profile
5. Full interface on swappable data (catalog live, commerce on labelled samples). Wiring cart, checkout, and orders as their API contracts land
