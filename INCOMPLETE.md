# Incomplete

Open items for the buyer app. The catalog reads the live API at `https://doory.elogyc.com/api/v1`; sign-in is live as well, and the other commerce domains run on labelled Mock repositories (see `design-plans/phase-5-full-ui-mock.md`).

## Commerce domains on sample data

Cart, addresses and neighborhoods, payment guide, delivery slots, pickup points, checkout, orders, notifications, reviews, help articles, and support tickets use `Mock…Repository` classes. Their `Live…Repository` counterparts in `lib/data/repositories/commerce/live_repositories.dart` name the endpoint and throw `NotWiredException`.

Next step: implement one Live repository at a time against the Dio transport, switch its provider in `commerce_providers.dart`, and replace the matching «لم يتم الربط بعد» actions.

## Server-only actions

These open the «لم يتم الربط بعد» dialog: placing a real order, submitting payment proof, cancelling a checkout or an order, returns, publishing a review, product questions, back-in-stock alerts, messaging or reporting a store, sending a support ticket, attachments, ticket threads, WhatsApp and phone handoff, map pin, phone change, password, sessions, data export, account deletion, WhatsApp OTP, and policy pages.

Next step: wire each with its endpoint. Dialing and WhatsApp need `url_launcher`; the map pin needs a maps package and location permission; attachments and payment proof need an image picker and multipart upload.

## Sign-in on production

Sign-in is wired to the live API and secured on the device (see README, «Authentication and security»). Three items need the backend:

- **No real OTP delivery.** Production binds only `LogSmsOtpDriver` and `LogWhatsAppOtpDriver`, which write the code to the server log. Nobody receives an SMS or WhatsApp message.
- **`simulation_code` is exposed on production.** `DOORY_OTP_BROWSER_POPUP` is on, so `POST /auth/otp` returns the code in its response. Anyone can sign in as any phone number. Debug builds show it as a labelled test code; release builds hide it and wait for real delivery.
- **No refresh endpoint.** Tokens expire after 30 days and the app sends the buyer back to sign-in. A `POST /auth/refresh` would allow silent renewal.

Next step: the backend teammate wires a real SMS/WhatsApp driver, turns `DOORY_OTP_BROWSER_POPUP` off, and provides a fixed-code test number for QA.

## Profile actions

Changing the phone number, setting a password, listing sessions, exporting data and deleting the account still open «لم يتم الربط بعد». Their endpoints exist (`/me/phone/*`, `/me/password`, `/me/sessions`, `/me/data-requests`).

Next step: wire each one with the authenticated transport.

## Certificate pinning

The app trusts the system certificate authorities. Pinning the `doory.elogyc.com` certificate is a deliberate later step, because the host's certificate rotates with its hosting provider.

Next step: pin the SPKI hash once the production certificate and its rotation plan are fixed.

## Android and iOS product flavors

Android is the Kotlin DSL project (AGP 9.3.1, Kotlin 2.4.20, Gradle 9.5.0). Product flavors are not declared, because `productFlavors` would make `flutter run` require `--flavor`. `DOORY_FLAVOR` stays a `--dart-define` (`dev` by default) and does not change the application id. iOS schemes are not wired.

Next step: add `dev` / `staging` / `prod` application-id suffixes and matching iOS schemes when the run command may require `--flavor`.

## Pixel goldens

P0 goldens are committed at 411×914 logical pixels: the type scale, a component strip, the top of the debug catalog, and the empty home shell (`test/golden/p0_*.png`). Widget tests still cover the older product card, maintenance banner, five-tab order, home failure states, search, cart lines and totals, the empty cart, the guest account, the quantity stepper, and the not-wired dialog.

Next step: add a golden for each later screen as that phase lands, on the same 411×914 surface.

## Hero transition

A shared-element transition from the card photo into the product gallery is not added. The same product can appear on more than one home shelf, and duplicate hero tags throw.

Next step: pass a placement-specific hero tag through the route and skip it when `disableAnimations` is set.

## Home modules with no live schema

`GET /home` returns empty `cms_sections`, `banners`, and `flash_sales`, and those arrays have no documented item shape. The brand rail, campaign mosaic, and suggestion pills are omitted on a live response; a labelled mosaic appears only with the unreachable-host fixture.

Next step: record the banner and CMS object shape, then render real modules.

## Store catalog paging

The store page shows the products included in `GET /stores/{slug}` and does not page a full store catalog.

Next step: page `/products?store={slug}` inside the products tab.

## Category query

Recorded so the next contract pass keeps it. `GET /products?category=` accepts a numeric category id; a slug is ignored and the endpoint returns the whole catalog. The app resolves the slug to an id and shows not-found for an unknown slug.

## Featured and recently viewed collections

«عرض الكل» on «وصل حديثًا» pages the whole catalog from `GET /products` (newest first, 513 products on the live host). «مختارات» and «شاهدته مؤخرًا» have no paged endpoint: the collection screen lists every card `GET /home` returned for that shelf (the backend sends the full featured list), and falls back to the whole catalog when the shelf is empty.

Next step: page `/products?featured=1` (or a dedicated collection endpoint) once the backend exposes one, and keep the `collection` route key unchanged.

## Arabic keyboard on the emulator

The Pixel_8a_API_35 emulator boots with the AOSP keyboard in English (US) only, so Arabic letters cannot be typed there until the Arabic subtype is enabled (Settings → System → Keyboard → On-screen keyboard → Android Keyboard → Languages → العربية). It is enabled on emulator-5554 now; a fresh or wiped emulator needs the same step. The search field itself accepts Arabic and keeps the keyboard's composing region while results refresh (covered by `test/widget/search_and_collections_test.dart`).

## Trendyol rebuild

The reference survey (`docs/trendyol-rebuild/`) covers every guest screen and the signed-in account, orders, addresses, settings, notification preferences, personal info, help, notifications, favorites and cart screens. These parts rest on derived patterns instead of a direct capture:

- **Address details form, checkout summary and payment methods.** Both come after Trendyol's map step, and the map needs Google Play Services, which this emulator lacks. Phases 10 and 11 build them from the measured personal-info fields and cart summary rows.
- **OTP and registration steps.** The account was already signed in. Phase 1 builds them from the measured login screen.
- **Search empty state.** Trendyol's fuzzy search returns products even for random text. Phase 5 builds the empty state from the empty-orders pattern.
- **Full questions page.** Phase 6 reuses the reviews page template, captured in `47-pdp-reviews`.
- **Element trees for animated screens.** Home after scrolling, some product sections, favorites and the search landing keep animating, so their measurements come from the screenshots.
- **Doory logo file.** The web uses the text wordmark «دوري», and neither project has an SVG or PNG logo. `DooryWordmark` stands in until an official file is added.

Next step: capture the address form and checkout on a Play-enabled emulator image or a real device, and add the official Doory logo file when it exists.

## P0 design spec — reference dumps

The full uiautomator XML and PNG captures cited in `docs/trendyol-rebuild/README.md` are not on this machine at `/workspace/shots/trendyol-app/screens/`.

The P0 specs in `docs/trendyol-rebuild/specs/` use the measurements already extracted in `dimensions.md` and the curated frames in `docs/trendyol-rebuild/ref/`. That does not block issues #7–#12. Figures marked «≈» in `dimensions.md` stay approximate, and the open items have recommended defaults in `specs/p0-decisions.md`.

Next step: copy `trendyol-ref/screens/` into the designer environment before re-measuring a bound from the raw dump.

## P0 foundation — open items

The default shell is the five empty roots from the P0 spec. The previous home, categories, favorites, cart, and account screens are still in the tree and still covered by tests through `buildRouter(legacyStorefront: true)`. They are not the tab a shopper sees on this branch.

Next step: phases P2–P9 replace each `TabRootScreen` with the rebuilt screen and delete the legacy flag when nothing calls it.

- **Mock photos are flat stills.** `assets/mock/` holds generated JPEGs at the specified pixel sizes (1200×1800 products, 512 squares, 1233×315 banners). They have no logo and no promotional text. They are not photographs.
- **Older widgets remain.** `ProductCard`, `DoorySearchField`, `DooryPrimaryButton`, and the previous `EmptyState` / `showDoorySheet` in `ui_kit.dart` still serve the current storefront. New screens use the P0 widgets.
- **Focus ring.** The button focus ring is drawn on the button bounds. The spec’s 2 dp outer offset is not painted outside the layout.
- **Rating row.** On a rail narrower than the stars plus the count, the count wraps under the stars instead of overflowing. The star size stays 12 dp.
- **Release catalog.** `/debug/catalog` is registered only when `kDebugMode` is true. A release build drops the route; widget tests run in debug, so they see it.
- **B14, sort-sheet radio.** The Trendyol sheet in `ref/15-sort-sheet` puts the radio at the start, next to the label, with no row dividers and a light header band. `p0-components-lists.md` puts the radio at the end, and `ListRow` follows that spec. This is a spec question for the designer, not an engineer change. Next step: confirm the placement before the P5 sort sheet, and update the spec first if the reference should win.
