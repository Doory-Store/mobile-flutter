# DESIGN — Doory (دوري)

The visual language of the Doory buyer app: a light, dense, Arabic shopping interface with a clear orange identity. The direction is familiar marketplace energy — compact chrome, round category shortcuts, bordered product cards, horizontal shelves, short “view all” paths — tuned for a phone in formal MSA.

This file is the design system. Tokens are the source of truth for color, type, radius, spacing, and shadow. Widgets read them through `ThemeData` and a `DooryTokens` `ThemeExtension`, not from raw hex in feature code.

The palette is light-only. A dark theme can be added when a second set of tokens exists.

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
- **Look.** Surface `#FFFFFF` with a 1px `#E6E6E6` top border and no elevation; selected icon and label in primary `#F27A1A`, unselected in text-secondary `#666666`; label 12/16 w600 Cairo, always visible; indicator pill in primary-subtle `#FFF3E8`. Bar height 64 plus the bottom safe-area inset; each destination is at least 48×48.
- **Behaviour.** Tapping the active tab pops its stack to the root, and a second tap scrolls to the top. Product detail, listing, and search are pushed inside the current tab's stack, so the bar stays visible while browsing; full-screen flows such as checkout cover the bar. Android back walks the current tab's stack first, then returns to Home, then exits.
- **Badges.** The Cart tab shows a count badge (primary fill, white 10px w700 text) once cart state is real. Favorites can show a dot for unseen changes later; it starts without one.
- **Tabs ahead of their API.** Favorites, Cart, and Account are present from the first release so the structure is stable. Until their contracts exist, each opens a clear MSA empty state that explains the feature is coming and offers a path back to browsing (for example «تصفّح الفئات»). Favorites is stored on the device until a server-side favorites contract exists.

**App bar.** Each tab root has its own pinned app bar. On Home it holds the orange wordmark «دوري» at the start and a search field (or a tap target that opens search). Listing, search, and product detail are pushed routes with a back affordance that follows the platform (Android system back and predictive back; iOS back swipe + leading back button).

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

**App bar details.** 44px actions, accessible names, wordmark in primary. Search field: 44px tall, `#F5F5F5`, 20px radius, orange magnifier at the inline end, placeholder «ابحث عن منتج أو فئة».

**Home, top to bottom.** Maintenance banner when `/meta/status` reports an active window; delivery line when `/home` provides `delivery_promise.message_ar` (otherwise a labelled sample line is acceptable in early releases); search; shortcut rail; optional brand rail; product shelves («مختارات», «وصل حديثًا», and any labelled collections); campaign mosaic; suggestion pills; popular-category links; a short about block; a compact footer of real help links.

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

**Shortcut rail.** One horizontally scrolling row of 68px circles, pastel fill, `#E9E9E9` ring, label underneath (max two lines, weight 600). Item width about 88px. Tones rotate teal, rose, terracotta, green, wine, cyan.

**Product card.** White, 1px border, 8px radius, no default shadow. The card body opens the product route. Image well is 2:3, flush with the top, `BoxFit.contain` on white. Title is 14/18, brand weight 600 then the name at 400, clamped to two lines with the full name in semantics. Price is 16/20 `#C2410C`. A genuine compare-at may sit with a primary discount chip and a struck `#999999` line. Estimate, sold-out, and can’t-purchase states come from API flags. Optional stamps, image strips, social proof, ratings, and promo lines appear only when they have data; they collapse when absent. A compact basket control, when present, is 32–44px and stays inert until cart is live.

**Shelves.** Title at the start (`shelf`, 20/24, 600). «عرض الكل» at the end is a 16px pill (padding 8×12, radius 20) when a listing route exists; otherwise the same pill is a clearly inactive control. Flash or deals trays may use a `primary-subtle` frame; cards on the tray stay white.

**Campaign mosaic.** Single column on a phone, about 2.4:1, 8px radius, palette fills (violet is allowed here). Sample tiles carry the demo label.

**Suggestion pills.** 36px tall, 1px border, 999 radius, 14px text, wrapping row.

**Buttons.** Primary filled: 48px, 8px radius, 18/600, white on `#F27A1A`, pressed `#D56B17`. Primary outline: 2px `#F27A1A` stroke and label, same size. Compact / sticky: 40px, 4px radius, 16/600. Secondary: white, `border-control`, dark label. Text actions use `primary-strong`.

**Product detail.** A phone column: gallery, title, seller, price (24/28 `#F27A1A`, with «سعر تقريبي» when flagged), variants, quantity, buy box, highlights and attributes, description, delivery rows that have data, reviews when genuine, and a “from the same store” rail. A compact sticky bar may pin price and the primary action as the shopper scrolls. Buy and add-to-cart are visible early; they complete a purchase once cart and checkout are contracted, and until then they explain that the action is coming.

**Maintenance banner.** Full width, `primary-subtle` background, a light primary border, centered 14/600 `text-primary`. Copy is `maintenance.message.ar` when `maintenance_active` is true. If the status request fails, the banner is simply absent.

**Footer.** Real help and policy links only. Third-party payment, store, or certificate artwork, if used in a preview layout, is labelled sample imagery.

## 8. Motion and iconography

Motion is short and opacity/transform-based (around 200ms, ease-out). Shelves and heroes stay still unless the shopper moves them. Reduced motion turns decorative animation off.

Icons are simple outlines: 20px in chrome, 14px stars, 12px meta. Filled stars use `#FFC000`; the empty track uses `#E6E6E6`. Brand-orange icons use `primary-strong`. Directional chevrons flip with RTL; the wordmark, photos, and search, cart, and rating icons stay as drawn.

## 9. Quality bar

A screen is ready when it uses theme tokens, reads correctly in RTL at large text sizes, has a skeleton, an empty state, and a retryable error, keeps 44–48 dp targets, and shows only prices and claims the data supports — with «بيانات تجريبية» on sample content. Unsettled typography, numeral format, cart-count, and tab-bar questions are confirmed before they are treated as decided.
