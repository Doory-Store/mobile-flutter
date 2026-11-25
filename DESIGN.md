# DESIGN — Doory (دوري)

The visual language of the Doory buyer app: a light, dense, Arabic shopping interface with a clear orange identity. The official direction is the Trendyol mobile app, matched as closely as possible — compact chrome, photo category chips, a banner carousel, a brands-and-sellers row, image-led product cards, and short “view all” paths — adapted for formal MSA, right-to-left layout, and Doory’s brand tokens. See Design reference: Trendyol below.

This file is the design system. Tokens are the source of truth for color, type, radius, spacing, and shadow. Widgets read them through `ThemeData` and a `DooryTokens` `ThemeExtension`, not from raw hex in feature code.

The palette is light-only. A dark theme can be added when a second set of tokens exists.

## Design reference: Trendyol

The official visual and interaction reference for this app is the **Trendyol mobile app**. New and revised screens should match it as closely as possible: the same chrome, density, component shapes, and shopping patterns, adapted for Arabic (formal MSA), right-to-left layout, and Doory’s brand (the tokens in this file, the «دوري» wordmark, and the honesty rules in `PRODUCT.md`). Trendyol’s own logos, campaign names, loyalty programs (Plus, Coins), and market-specific copy are not copied.

### Where the references live

Captured screens live on the designer’s Windows machine at:

`C:\Users\bahaa\Desktop\Doory\trendyol-ref\screens`

The folder holds full-resolution PNGs, matching UI Automator XML dumps (visible text, content descriptions, and bounds), and JPEG thumbnails under `small/`. The capture set used for this revision contains 69 screens (PNG + `small/*.jpg`) and 58 XML dumps. Filenames are numbered by flow, for example `01-home-top`, `10-categories`, `13-listing`, `40-pdp-top`, `50-cart-empty`, `70-account-signed`, `90-onboarding-1`. Before designing or changing a screen, open the matching capture — thumbnail first, then the PNG and XML if the layout is unclear — and follow that structure.

Two canonical stills of the English LTR home and the category-personalization onboarding screen are also kept with the project brief. When a capture is in LTR, mirror it for Doory’s RTL (see RTL, below).

### Patterns to copy

These patterns are the default for Doory, unless a product rule in `PRODUCT.md` forbids showing data that is not real.

- **Orange on white.** A bright orange primary accent on a white surface, light-grey wells, and dark-grey text. Doory already uses `#F27A1A` for this role; keep the token table in §1 rather than introducing a second orange.
- **Top segment chips.** A horizontally scrolling row of compact pill cards, each with a photo and a short label (for example «النساء», «عالم الأطفال», «الرجال», deals, brands). The selected chip uses a primary-orange fill and a white label; unselected chips stay light grey with a photo.
- **Search row.** A full-width light-grey search field with a leading magnifier, a trailing camera / visual-search icon, and — for a guest — a compact orange «تسجيل الدخول» pill beside the field. The home header does not lead with a large wordmark; the wordmark belongs on the splash, about, and account surfaces.
- **Promo banner carousel.** A full-width campaign hero under the search row, with a small page counter (for example «1/12») on the banner. Autoplay is optional and respects reduced motion; the shopper can swipe in the reading direction.
- **Category photo grid.** A two-row, horizontally scrolling grid of rounded-square tiles with product photography and a short label underneath — not pastel circles. This is the primary home category entry.
- **Promo strip banners.** One or two compact full-width (or paired) campaign strips between modules, used only when a real campaign exists or the artwork is labelled «بيانات تجريبية».
- **Top brands & sellers.** A titled row («أفضل الماركات والبائعين», or the agreed MSA equivalent) with «عرض الكل», showing rounded-square brand or seller marks in a horizontal scroller. Render the row when brand or store data exists; otherwise omit it.
- **Popular products.** A two-column product grid titled along the lines of «منتجات محبوبة», with «اكتشف المزيد» or «عرض الكل» at the inline end. Each card has a heart favorite control on the image, optional sale or discount badges, and the price and rating rules in `PRODUCT.md`.
- **Five-tab bottom navigation.** Home, Categories, Favorites, Cart, Account — already the app’s structure. The selected tab is a filled icon and label in primary orange; unselected tabs are grey outlines and grey labels. Do not add a strong indicator pill behind the icon.
- **Personalization onboarding.** A first-run full-screen prompt: a light illustrated hero, a close control at the inline end, short centered copy asking the shopper to pick a preferred category for personalized suggestions, and two equal primary-orange buttons side by side (for example «النساء» and «الرجال», or the categories the catalog actually supports). The choice is stored on the device and may pre-select the matching home segment chip. Skip or close must land on home without blocking the catalog. A following notification-permission screen is shown only if the product has approved notifications; do not invent that policy here.

### RTL and brand adaptation

Doory is RTL. Mirror Trendyol’s LTR screens rather than copying pixel coordinates. Segment chips, shelves, and carousels start at the inline start (the right in Arabic). The search magnifier stays at the inline start of the field, the camera icon at the inline end, and the login pill on the inline end of the search row (the left in Arabic). Directional chevrons flip; photography, brand marks, and non-directional icons (search, cart, rating, camera, heart) stay as drawn. Latin brand names and prices inside Arabic strings sit in a bidi isolate, as in §6.

Tokens, type (Cairo), spacing, and the contrast rules in this file still govern implementation. When a Trendyol pattern and a token conflict, keep the token and express the pattern with it. When a Trendyol element would display a rating, countdown, coupon, or delivery promise, follow `PRODUCT.md`: show it only with real data, or with a visible «بيانات تجريبية» label.

### Screen index (what to open)

| Doory surface | Captures to check first |
| --- | --- |
| First-run personalization | `90-onboarding-1`, `91-onboarding-2`, `92-onboarding-3` |
| Home | `01-home-top`, `02`–`05` home scrolls, `06-home-women-top` and the women scrolls |
| Categories tab | `10-categories`, `11-categories-rail-clothes`, `12-categories-women-tab` |
| Listing, sort, filter | `13-listing`, `14-listing-scrolled`, `15-sort-sheet`, `16-filter`, `17-filter-price`, `18-filter-brand` |
| Search | `35-search-landing`, `35b-search-landing-history`, `36-search-suggest`, `37-search-results`, `38-search-no-results` |
| Product detail | `40-pdp-top` through `49-pdp-added`, including the variant sheet and reviews |
| Cart and checkout gates | `50-cart-empty` through `54-cart-delete-dialog`, `82-cart-signed`, `83a-checkout-upsell-popup`, `84-checkout-address-gate` |
| Favorites | `60-favorites-guest`, `81-favorites-signed` |
| Account, orders, settings | `20-account-guest`, `70-account-signed`, and the `7x` / `8x` account flows |
| Login | `30-login-email`, `31-login-email-focused` |


## 1. Color

| Token | Hex | Role |
| --- | --- | --- |
| primary, primary-strong, price | `#F27A1A` | Brand orange: fills, key icons, PDP price, outline button, active tab |
| primary-hover | `#D56B17` | Pressed primary fill (`#F27A1A` mixed 12% toward black) |
| primary-subtle | `#FFF3E8` | Tints, deals-tray frame, maintenance banner |
| surface | `#FFFFFF` | Page, cards, image wells |
| surface-subtle | `#F5F5F5` | Search field, chips, skeletons, footer |
| surface-inverse | `#333333` | Inverse surfaces, with text-on-strong |
| text-primary | `#333333` | Body, titles, essential information |
| text-secondary | `#666666` | Supporting copy, placeholders |
| text-on-strong | `#FFFFFF` | Text and icons on primary fills |
| border | `#E6E6E6` | Card edges, dividers, empty star track |
| border-control | `#858585` | Control outline when contrast needs a stronger edge |
| card-price | `#C2410C` | Current price on a shelf card (`#F27A1A` at 16px on white is ~2.6:1) |
| text-muted | `#999999` | Struck compare-at on a card |
| discount, danger | `#BB0000` | Genuine reductions and errors, always with copy |
| success | `#137333` | Confirmed availability or success, with text or icon |
| rating | `#FFC000` | Filled star when a real rating exists |
| preview-plus | `#FF4988` | Sample “Plus” line only; not a brand or price color |
| category-tile-teal | `#2B6E77` | Tile / shortcut ink (white label 5.83:1) |
| category-tile-rose | `#9A404A` | Tile ink (6.55:1) |
| category-tile-terracotta | `#9A4C3D` | Tile ink (6.04:1) |
| category-tile-green | `#407C3D` | Tile ink (5.04:1) |
| category-tile-wine | `#982F49` | Tile ink (7.40:1) |
| category-tile-cyan | `#1F7B8E` | Tile ink (4.90:1) |
| category-tile-violet | `#4A3D78` | Mosaic fill only (white label 9.42:1) |
| shortcut-teal | `#DFF5F4` | Shortcut pastel |
| shortcut-rose | `#FDECEF` | Shortcut pastel |
| shortcut-terracotta | `#FFF0E7` | Shortcut pastel |
| shortcut-green | `#E3F6E1` | Shortcut pastel |
| shortcut-wine | `#FDE8EF` | Shortcut pastel |
| shortcut-cyan | `#E1F4FA` | Shortcut pastel |
| shortcut-border | `#E9E9E9` | Shortcut ring |
| footer-band | `#1C1C1C` | Legal band |
| footer-band-text | `#BDBDBD` | Legal-band copy |

`#F27A1A` on white is 2.77:1, below AA for body text. It is still the brand fill and the PDP price, always with a second cue (fill, 2px border, or underline). Shelf-card amounts use `#C2410C` (5.18:1). State is always paired with a second cue (label, underline, or fill), not hue alone. `#B95800` is a retired fill and is left out of the token set.

## 2. Typography

Cairo is the only typeface, in weights 400, 600, and 700, covering Arabic and Latin. It is bundled in `assets/fonts/`. Fallback is Tahoma, then the platform sans. Arabic shaping is preserved; `letterSpacing` stays `0`.

Sizes are logical pixels, taken from a 16px root scale. `TextStyle.height` is line-height ÷ font size.

| Role | Size / line | Weight | Color notes |
| --- | --- | --- | --- |
| Wordmark / page title | 24 / 36 | 700 | |
| Section title | 22 / 28 | 600 | |
| Shelf title | 20 / 24 | 600 | Home shelves |
| Hero title | 28 / 36 | 700 | |
| Body | 16 / 24 | 400 | `#333333` |
| Product title (PDP) | 20 / 26 | 400 | |
| Card title | 14 / 18 | 400; brand 600 | `#333333` |
| PDP price | 24 / 28 | 600 | `price` |
| Card price | 16 / 20 | 600 | `card-price` |
| Compact price | 16 / 19 | 600 | Sticky bars |
| CTA | 18 / 24 | 600 | |
| Label / meta | 14 / 20 | 400 or 600 | |
| Card meta | 12 / 16 | 600 | Stamps, ratings, struck prices |
| Shortcut label | 10 / 13 | 600 | 14 / 18 from a 1024 logical width |

Arabic text wraps rather than shrinking below these sizes. Currency label: «ل.س». Numeral style is an open product decision; Latin digits are the current default.

## 3. Geometry, spacing, shadow

**Spacing:** 4, 8, 12, 16, 20, 24, 32, 40, 48, 64. Phone gutters and section gaps are 16. A 32 gap marks a true change of content.

**Radii:** 4 (chips, compact 40px actions), 8 (cards, galleries, 48px buttons), 12 (framed sections), 20 (search field), 999 (pills and circles).

**Borders:** 1px `border` on cards. Focus ring: 2px `primary-strong`, 2px offset from the surface.

**Shadows** (Flutter `BoxShadow`):

| Name | Spec |
| --- | --- |
| Card default | none; Material `elevation` 0 |
| Card raised | `offset (0, 2)`, blur 8, spread 0, `Color(0x14000000)` |
| Product card (optional) | same, spread 2 |
| Favorite chip | `offset (0, 2)`, blur 2, `Color(0x33000000)` |
| Overlay / sheet | `offset (0, 8)`, blur 24, `Color(0x14000000)` |
| Shelf arrow | `offset (0, 2)`, blur 10, `#333333` at 30% |

## 4. Theme in Flutter

```dart
@immutable
class DooryTokens extends ThemeExtension<DooryTokens> {
  const DooryTokens({
    required this.cardPrice,
    required this.rating,
    required this.textMuted,
    required this.primarySubtle,
    required this.primaryHover,
    required this.shortcutPastels,
    required this.radiusCard,
    required this.radiusSearch,
    required this.space,
  });

  final Color cardPrice;
  final Color rating;
  final Color textMuted;
  final Color primarySubtle;
  final Color primaryHover;
  final ShortcutPastels shortcutPastels;
  final double radiusCard;   // 8
  final double radiusSearch; // 20
  final DoorySpacing space;

  // copyWith / lerp omitted for brevity
}

const dooryColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFFF27A1A),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFFFF3E8),
  onPrimaryContainer: Color(0xFFD56B17),
  secondary: Color(0xFF333333),
  onSecondary: Color(0xFFFFFFFF),
  error: Color(0xFFBB0000),
  onError: Color(0xFFFFFFFF),
  surface: Color(0xFFFFFFFF),
  onSurface: Color(0xFF333333),
  onSurfaceVariant: Color(0xFF666666),
  outline: Color(0xFFE6E6E6),
  outlineVariant: Color(0xFF858585),
  inverseSurface: Color(0xFF1C1C1C),
  onInverseSurface: Color(0xFFBDBDBD),
  inversePrimary: Color(0xFFFFF3E8),
);
```

Named text styles (`DooryTypography.page`, `.shelf`, `.body`, `.cardPrice`, …) are the ones storefront widgets use, so prices and shelf titles stay on the scale above. A `TextTheme` mapping is provided for Material defaults (`bodyLarge` ← body, `titleLarge` ← shelf, `labelSmall` ← card meta, and so on).

`ThemeData` is Material 3, light, `fontFamily: 'Cairo'`, `scaffoldBackgroundColor` surface, `appBarTheme` with elevation 0, `cardTheme` with elevation 0, 8px radius, and a 1px border, search `InputDecoration` filled `surface-subtle` with a 20px radius, `FilledButton` 48px / 8px radius / 18px w600 white on `#F27A1A`, pressed overlay `#D56B17`, `OutlinedButton` with a 2px primary stroke, and `IconButton` minimum 44×44. Splash and highlight use `primary-subtle`. There is no `darkTheme`.

`MaterialApp` sets `locale: Locale('ar')`, the Material/Cupertino/Widgets localization delegates, `theme: dooryTheme()`, and a `Directionality(textDirection: TextDirection.rtl)` around the router child so every route inherits RTL.

## 5. Navigation and chrome

**Bottom navigation bar.** The app's primary navigation is a five-tab bottom bar. Because the app runs right-to-left, Home sits at the far right and the tabs read right to left in this order:

| Order (right → left) | Tab | Label | Icon (outline / selected filled) | Route |
| --- | --- | --- | --- | --- |
| 1 | Home | «الرئيسية» | `home_outlined` / `home` | `/` |
| 2 | Categories | «الفئات» | `grid_view_outlined` / `grid_view` | `/categories` |
| 3 | Favorites | «المفضلة» | `favorite_border` / `favorite` | `/favorites` |
| 4 | Cart | «السلة» | `shopping_cart_outlined` / `shopping_cart` | `/cart` |
| 5 | Account | «حسابي» | `person_outline` / `person` | `/account` |

- **Implementation.** A Material 3 `NavigationBar` inside a go_router `StatefulShellRoute.indexedStack`, so each tab keeps its own navigation stack and scroll position. The destinations are declared in the order above; the app-wide `TextDirection.rtl` places the first destination (Home) on the right, so the order is never reversed by hand.
- **Look.** Surface `#FFFFFF` with a 1px `#E6E6E6` top border and no elevation; selected icon and label in primary `#F27A1A`, unselected in text-secondary `#666666`; label 12/16 w600 Cairo, always visible. Follow the Trendyol tab treatment: a filled orange icon and orange label when selected, a grey outline icon and grey label when not; do not add a strong indicator pill behind the icon (if Material 3 requires an indicator, keep it quiet or transparent). Bar height 64 plus the bottom safe-area inset; each destination is at least 48×48.
- **Behaviour.** Tapping the active tab pops its stack to the root, and a second tap scrolls to the top. Product detail, listing, and search are pushed inside the current tab's stack, so the bar stays visible while browsing; full-screen flows such as checkout cover the bar. Android back walks the current tab's stack first, then returns to Home, then exits.
- **Badges.** The Cart tab shows a count badge (primary fill, white 10px w700 text) once cart state is real. Favorites can show a dot for unseen changes later; it starts without one.
- **Tabs ahead of their API.** Favorites, Cart, and Account are present from the first release so the structure is stable. Until their contracts exist, each opens a clear MSA empty state that explains the feature is coming and offers a path back to browsing (for example «تصفّح الفئات»). Favorites is stored on the device until a server-side favorites contract exists.

**App bar.** Each tab root has its own pinned chrome. Home does not lead with a large wordmark; it starts with the top segment-chip row, then the search row (light-grey field plus, for a guest, the orange login pill), as in `01-home-top` and the Design reference. The «دوري» wordmark belongs on the splash, about, and account surfaces. Listing, search, and product detail are pushed routes with a back affordance that follows the platform (Android system back and predictive back; iOS back swipe + leading back button).

**Routes.**

| Path | Screen |
| --- | --- |
| `/` | Home (tab 1) |
| `/categories` | Category tree «تصفّح الفئات» (tab 2) |
| `/favorites` | Favorites (tab 3) |
| `/cart` | Cart (tab 4) |
| `/account` | Account (tab 5) |
| `/search?q=` | Search |
| `/c/:slug` | Category listing |
| `/p/:ref` | Product detail (`ref` is a leading numeric id, optionally `id-slug`) |
| `/s/:slug` | Store profile (phase 4) |

Deep links use the same shapes. Slugs come from the API.

**App bar details.** 44px actions and accessible names. Search field: 44px tall, `#F5F5F5`, 20px radius (a pill is also acceptable), a grey magnifier at the inline start, a trailing camera / visual-search icon at the inline end, and placeholder «ابحث عن منتج أو فئة». For guests, a compact 32–40px-tall orange pill labelled «تسجيل الدخول» sits beside the field on the inline end of the row (the left in RTL). Visual search is reserved until a contract exists: the camera icon may be present but inert, or omitted, and must not invent a backend. On listing and search, the field shows the current query, a clear control, and a result count when one exists (see `13-listing`).

**Home, top to bottom.** Follow the Trendyol home stack in `01-home-top` and the later home scrolls, in this order: a maintenance banner when `/meta/status` reports an active window; the top segment-chip row; the search row (with the login pill for guests); a full-width promo banner carousel with a page counter; the two-row photo category grid; promo strip banners when campaigns exist (or labelled sample artwork); a «أفضل الماركات والبائعين» row with «عرض الكل» when brand or store data exists; a popular-products grid («منتجات محبوبة») and any further product shelves («مختارات», «وصل حديثًا», and labelled collections); suggestion pills or popular-category links as needed; a short about block; a compact footer of real help links. A delivery line appears only when `/home` provides `delivery_promise.message_ar` (a labelled sample line is acceptable in early releases if that copy is required for layout). Omit any module whose data is missing, rather than inventing content.

## 6. Layout, gesture, and platform behaviour

- **Safe areas.** Padding follows `MediaQuery.padding` / `SafeArea`. The app bar clears the status bar and notch; the bottom navigation bar clears the home indicator, and scrollable content pads its end by the bar height. Horizontal insets stay 16.
- **Small screens.** One column, near-full-bleed modules. Shelves target about 1.75 cards with a peek; minimum card width 160. If the name or price cannot fit, the shelf shows fewer cards. On a large tablet, the column caps around 600–840 wide rather than stretching a single card.
- **Gestures.** Horizontal shelves and shortcut rails scroll with the reading direction and snap enough to reveal the next peek. Android system back pops the route; iOS edge-swipe does the same. Pull-to-refresh sits on home, listing, search, and product detail. A swipe is a shortcut, not the only way to move a shelf — when arrow controls are shown, they have Arabic labels and a 44px target.
- **Pagination.** Listing and search use the API’s `page`, `per_page` (default 24), `total`, and `last_page`. On a phone this is infinite scroll: load the next page near the end of the grid, with a small footer indicator, and stop at `last_page`. Pull-to-refresh reloads page 1.
- **Images.** Product photos use `cached_network_image` (or equivalent), `BoxFit.contain` on a white 2:3 well, a fade-in, and a compact memory cache so a long shelf stays light. Missing photos show a quiet placeholder. Semantics carry a meaningful label. Hero animation from the card image into the PDP gallery is welcome when it does not fight reduced-motion settings.
- **Offline and poor networks.** The client times out at 4s. The screen keeps content it already has, shows a concise MSA error with Retry, and uses labelled sample content only when the API is unreachable and a matching fixture exists. A live not-found or validation response is shown as that state. Connectivity changes can prompt a silent refresh when the shopper returns to a stale screen.
- **Loading.** Skeletons match the shape of the card, shelf, or PDP block. They occupy the reserved size so the layout does not jump.
- **Empty and error.** Empty search, no results, an empty category, and an unavailable catalog each have their own copy and a useful next step (revise the query, browse categories, retry).
- **Performance.** Lists are lazy (`ListView` / `GridView` / `CustomScrollView`). Images are sized to the well. Providers are auto-disposed when a route is left, except for catalog trees that are cheap to keep. `RepaintBoundary` sits around animated carousels. Work that hits the network or maps a large payload stays off `build()`.
- **Accessibility.** Minimum targets are 44–48 dp. Text scales with system font size; layouts wrap instead of overflowing. Interactive controls have `Semantics` labels and hints (icon-only buttons included). TalkBack and VoiceOver read prices, discounted amounts, and stock state. Focus order follows visual RTL order. `MediaQuery.disableAnimations` turns off auto-play, decorative motion, and smooth-scroll jumps; state changes remain visible. Contrast follows the table in §1; a second non-color cue accompanies brand-orange actions.
- **RTL.** `Directionality` is `rtl` at the app root. Insets and alignment use `EdgeInsetsDirectional`, `AlignmentDirectional`, and `PositionedDirectional`. Carousels start at the inline start. Directional chevrons flip; the wordmark, logos, product photos, and non-directional search, cart, and rating icons stay as drawn. Latin brand names, SKUs, and prices sit in a bidi isolate when they appear inside Arabic strings.
- **Android and iOS.** Material 3 is the baseline, with Cupertino-aware scrolling bounce and the platform back pattern. Status-bar icons are dark on the light chrome. Predictive back on Android 14+ is enabled. App icon and splash use the orange wordmark on a light surface. Haptic feedback is light and reserved for successful primary actions once those actions are live.

## 7. Components

**Category photo grid (home).** The primary home category entry is a two-row, horizontally scrolling grid of rounded-square tiles with product photography and a short label underneath (max two lines, weight 600), matching `01-home-top` and `06-home-women-top`. Tile radius is 12; the photo sits in a white well; a peek of the next column should remain visible. This replaces the older 68px pastel-circle shortcut rail, which is retired for home and must not be reintroduced. Pastel shortcut tokens in §1 may remain in the theme for other compact chips, but new home entry points use photography.

**Product card.** Image-led, following Trendyol’s popular-products and listing cards (`01-home-top`, `13-listing`): white surface, 8px radius, no default shadow. A 1px `#E6E6E6` border is acceptable when a grid needs separation on white, but the frame should stay light — the photograph carries the card. The card body opens the product route. Image well is 2:3, flush with the top, `BoxFit.contain` on white. A heart favorite control sits on the image at the inline end, on a light circular well; the target is 44 dp even if the glyph looks smaller. Favorites are stored on the device until a server-side contract exists. A genuine sale or discount badge (for example a small «عرض» / ON SALE chip, or a percent-off stamp) may sit on the image at the inline start only when `PRODUCT.md` allows it. Title is 14/18, brand weight 600 then the name at 400, clamped to two lines with the full name in semantics. Price is 16/20 `#C2410C`. A genuine compare-at may sit with a primary discount chip and a struck `#999999` line. Estimate, sold-out, and can’t-purchase states come from API flags. Ratings, review counts, colour-variant hints, verified-seller marks, countdowns, stamps, and promo lines appear only when they have data; they collapse when absent. A compact basket control, when present, is 32–44px and stays inert until cart is live. Popular products on home are a two-column grid; listing and search use the same card in a two-column grid with sort and filter chips above (`13-listing`, `15-sort-sheet`, `16-filter`).

**Shelves.** Title at the start (`shelf`, 20/24, 600). «عرض الكل» at the end is a 16px pill (padding 8×12, radius 20) when a listing route exists; otherwise the same pill is a clearly inactive control. Flash or deals trays may use a `primary-subtle` frame; cards on the tray stay white.

**Promo banner carousel.** Full-width campaign hero under the home search row, rounded about 8px or slightly less, with a small page-counter chip (for example «1/12») on the banner, matching `01-home-top`. Swipe moves in the reading direction; autoplay, if used, respects reduced motion and pauses on interaction.

**Promo strip banners.** Compact full-width or paired campaign strips between home modules, used only for real campaigns or labelled sample artwork. See the promotional rows in `01-home-top` and `04-home-scroll3`.

**Top brands & sellers.** Shelf title at the start, «عرض الكل» at the end, and a horizontally scrolling row of rounded-square brand or seller marks (white well, light border, 8–12px radius), as in `06-home-women-top`. Omit the row when brand or store data is missing.

**Personalization onboarding.** A first-run full-screen, white, with a close control at the inline end, a light illustrated hero, short centered body copy, and two equal primary filled buttons in one row, matching `90-onboarding-1`. Button labels are the categories the catalog actually supports. Closing or skipping goes to home. Further permission screens follow only after an approved product policy (see `91-onboarding-2`).

**Categories tab.** Search field at the top (placeholder may mention brand, product, or category), then a horizontally scrolling department rail of photo cards, then sectioned category groups with a title, a photo grid, and «عرض الكل», as in `10-categories`, `11-categories-rail-clothes`, and `12-categories-women-tab`.

**Listing and search chrome.** A query or category title, a result count, a trailing clear and camera control, then «الفرز» and «فلترة» chips (with any active-filter count), then the two-column product grid. Sort is a bottom sheet: الأنسب, الأكثر مبيعًا, المفضلة, وصل حديثًا, الأعلى تقييمًا, الأعلى سعراً, الأقل سعراً — use the MSA terms already in `PRODUCT.md` where they overlap («الأكثر مبيعًا», «وصل حديثًا») and keep the sheet’s structure from `15-sort-sheet`. Filters are a full-screen sheet with clear and apply, as in `16-filter`. Empty and no-result search follow `38-search-no-results`: explain that nothing matched and, when honest alternatives exist, offer them.

**Campaign mosaic.** An optional single-column promotional mosaic (about 2.4:1, 8px radius, palette fills; violet is allowed here) may still appear below the default Trendyol home modules. Sample tiles carry the demo label. The banner carousel and promo strips are the default campaign treatment.

**Suggestion pills.** 36px tall, 1px border, 999 radius, 14px text, wrapping row.

**Buttons.** Primary filled: 48px, 8px radius, 18/600, white on `#F27A1A`, pressed `#D56B17`. Primary outline: 2px `#F27A1A` stroke and label, same size. Compact / sticky: 40px, 4px radius, 16/600. Secondary: white, `border-control`, dark label. Text actions use `primary-strong`. The guest «تسجيل الدخول» control on the search row is a compact pill: 32–40px tall, radius 999, 14/600, white on primary. The onboarding pair uses two equal primary filled 48px buttons in one row, 8px radius, as in `90-onboarding-1`.

**Product detail.** A phone column: gallery, title, seller, price (24/28 `#F27A1A`, with «سعر تقريبي» when flagged), variants, quantity, buy box, highlights and attributes, description, delivery rows that have data, reviews when genuine, and a “from the same store” rail. A compact sticky bar may pin price and the primary action as the shopper scrolls. Buy and add-to-cart are visible early; they complete a purchase once cart and checkout are contracted, and until then they explain that the action is coming.

**Maintenance banner.** Full width, `primary-subtle` background, a light primary border, centered 14/600 `text-primary`. Copy is `maintenance.message.ar` when `maintenance_active` is true. If the status request fails, the banner is simply absent.

**Footer.** Real help and policy links only. Third-party payment, store, or certificate artwork, if used in a preview layout, is labelled sample imagery.

## 8. Motion and iconography

Motion is short and opacity/transform-based (around 200ms, ease-out). Shelves and heroes stay still unless the shopper moves them. Reduced motion turns decorative animation off.

Icons are simple outlines: 20px in chrome, 14px stars, 12px meta. Filled stars use `#FFC000`; the empty track uses `#E6E6E6`. Brand-orange icons use `primary-strong`. Directional chevrons flip with RTL; the wordmark, photos, and search, cart, and rating icons stay as drawn.

## 9. Quality bar

A screen is ready when it uses theme tokens, follows the Trendyol patterns in the Design reference (checked against the matching capture in `trendyol-ref/screens`), reads correctly in RTL at large text sizes, has a skeleton, an empty state, and a retryable error, keeps 44–48 dp targets, and shows only prices and claims the data supports — with «بيانات تجريبية» on sample content. Unsettled typography, numeral format, cart-count, and tab-bar questions are confirmed before they are treated as decided.
