# Incomplete

Items skipped while building the first runnable buyer app. The live API at `https://doory.elogyc.com/api/v1` was reachable and the models follow those payloads.

## Android and iOS product flavors

The checked-in Android project is the Groovy template (AGP 8.1.0, Kotlin 1.8.22, Gradle 8.3). It is not the Kotlin DSL / AGP 9.3.1 setup described in the task, and it was left unchanged so that existing Gradle files keep working.

Product flavors were not added. Once `productFlavors` exist, `flutter run` requires `--flavor`, which conflicts with a flagless `flutter run`. Flavor is a `--dart-define=DOORY_FLAVOR` (`dev` by default) and does not change the application id.

Next step: move Android onto the Flutter 3.50 Kotlin DSL (AGP 9.x) and add `dev` / `staging` / `prod` flavors plus matching iOS schemes, then document that `--flavor` is required.

## Debug APK

`flutter build apk --debug` was not run. `ANDROID_HOME` is unset and there is no Android SDK or `adb` on this machine, so the build cannot configure the SDK.

Next step: install the Android command-line tools and a platform matching `flutter.compileSdkVersion`, then run `flutter build apk --debug`.

## Device launch

`flutter run` was not executed against an emulator or a phone. Analyzer, unit tests, and widget tests passed. There is no display device in this environment.

Next step: `flutter run` on an Android emulator and confirm Home, a category, a product, search, and **حسابي → حالة الاتصال** against the live host.

## Pixel goldens

No golden files were committed. Widget tests cover the product card (price, missing price, estimate, demo label), the maintenance banner, the five-tab bar order, home unavailable vs rejected, empty search (no `/search` call), and the degraded-search notice.

Next step: render the card and a shelf row at 390 logical pixels with Cairo loaded and commit the PNGs from `flutter test --update-goldens` on the CI image.

## Hero transition

A shared-element transition from the card photo into the product gallery was not added. The same product can appear on more than one home shelf, and duplicate hero tags throw.

Next step: pass a placement-specific hero tag through the route and skip it when `disableAnimations` is set.

## Home modules with no live schema

`GET /home` returns empty `cms_sections`, `banners`, and `flash_sales`, and those arrays have no documented item shape. The brand rail, campaign mosaic, and suggestion pills are omitted on a live response. A labelled mosaic is shown only with the unreachable-host fixture. There are no contracted help or policy URLs, so the footer is a brand band without invented links.

Next step: record the banner and CMS object shape, then render real modules. Add help links only when the URLs exist.

## Store, cart, checkout, account

`/s/:slug` is a placeholder. It still calls `GET /stores/{slug}` so an unknown slug is not-found and a live store shows its name, area, and description. It does not page a store catalog.

Cart and account are MSA coming-soon screens. Favorites are stored on the device with `shared_preferences`. Add-to-cart and buy on the product page explain that checkout is not contracted. Cards do not show a basket control.

Next step: phase 4 for the store grid, then cart and checkout when those contracts exist.

## Category query

Not skipped, recorded so the next contract pass does not "fix" it backwards. The live `GET /products?category=` filter accepts a numeric category id. A slug or unknown string is ignored and the endpoint returns the unfiltered catalog (confirmed with `category=bakery` vs `category=9`). The app resolves the slug to an id and, when the slug is not in the tree, shows not-found instead of the full catalog.
