# DESIGN — Doory (دوري)

The visual language of the Doory buyer app, aligned with the Trendyol-rebuild foundation in `docs/trendyol-rebuild/`. The interface is a light, dense, Arabic shopping UI. Structure, spacing, and component anatomy follow the measured Trendyol Saudi app. Color, type, and the wordmark stay Doory’s.

Tokens are the source of truth. Widgets read them through `ThemeData` and `DooryTokens`, not from raw hex in feature or widget code.

The palette is light-only.

## 1. Color

| Token | Hex | Role |
| --- | --- | --- |
| primary | `#F27A1A` | Fills, active tab, wordmark, large price. Not small text on white |
| primary-hover | `#D56B17` | Pressed primary fill |
| primary-subtle | `#FFF3E8` | Pressed light surfaces, empty-state disc, unread rows later |
| surface | `#FFFFFF` | Cards, sheets, bars, image wells |
| surface-subtle | `#F5F5F5` | Search field, skeletons, idle surfaces |
| surface-canvas | `#FAFAFA` | Group pages such as account |
| surface-inverse | `#333333` | Rare inverse surfaces |
| text-primary | `#333333` | Titles, body, idle tab |
| text-secondary | `#666666` | Descriptions, struck prices, values a shopper must read |
| text-muted | `#999999` | Decorative hints only. Not prices or filter values |
| text-on-strong | `#FFFFFF` | Text and icons on primary fills |
| border | `#E6E6E6` | Hairline dividers and idle chip borders |
| border-control | `#858585` | Secondary button outline |
| card-price | `#C2410C` | Card price, compact price, and small orange links. 5.18:1 on white |
| discount, danger | `#BB0000` | Real discounts, errors, filled favorite |
| success | `#137333` | Success text |
| success-surface | `#E7F9EF` | Success badge fill. Replaces the measured `#0BC15C` pair |
| rating | `#FFC000` | Filled star |
| sheet-barrier | `#66000000` | Sheet scrim, black at 40% |

`#F27A1A` on white is 2.77:1. Card prices and «رؤية الكل» use `card-price`. Primary stays the fill, the wordmark, the active tab, and `priceLarge`.

These tokens stay in the file and are not used by P0 components: `preview-plus`, shortcut pastels, tile inks, and the footer band. Removing them would break the current storefront before later phases replace it.

## 2. Typography

Cairo, weights 400, 600, and 700, bundled in `assets/fonts/`. Fallback is Tahoma, then the platform sans. `letterSpacing` is 0. `TextStyle.height` is line-height ÷ font size.

| Role | Size / line | Weight | Color |
| --- | --- | --- | --- |
| wordmark | 24 / 32 | 700 | primary |
| wordmarkDisplay | 40 / 52 | 700 | primary |
| toolbarTitle | 18 / 24 | 700 | text-primary |
| sectionTitle | 16 / 22 | 700 | text-primary |
| rowLabel | 15 / 22 | 400 | text-primary |
| rowLabelStrong | 15 / 22 | 700 | text-primary |
| body | 14 / 20 | 400 | text-primary |
| bodySecondary | 14 / 20 | 400 | text-secondary |
| cardTitle | 12 / 16 | 400 | text-primary |
| cardBrand | 12 / 16 | 700 | text-primary |
| price | 14 / 18 | 700 | card-price |
| priceLarge | 18 / 24 | 700 | primary |
| priceCompact | 16 / 20 | 700 | card-price |
| strike | 11 / 14 | 400 | text-secondary, struck |
| caption | 12 / 16 | 400 | text-secondary |
| captionStrong | 11 / 14 | 600 | text-primary |
| chipLabel | 13 / 18 | 600 | from the chip state |
| tabLabel | 11 / 14 | 600 | primary or text-primary |
| button | 16 / 22 | 700 | from the button |
| buttonCompact | 14 / 18 | 700 | from the button |
| link | 14 / 20 | 700 | card-price |

Older names (`page`, `section`, `shelf`, `cardPrice`, `navLabel`, and the rest) point at these roles. `shortcut` stays 10 / 13 / 600 for later tiles. `TextTheme` maps `titleLarge` to toolbarTitle, `titleMedium` to sectionTitle, `bodyLarge` to body, `bodyMedium` to rowLabel, `labelLarge` to button, and `labelSmall` to caption.

Arabic wraps. Text does not shrink below this scale. A system scale of 1.3× keeps the weights and lets lines grow; cards grow downward and tab labels ellipsize. Prices are Latin digits with a thousands comma, isolated for RTL: `1,250 ل.س`. The currency has no third dot. `null` prices are omitted, never drawn as zero.

## 3. Geometry, spacing, shadow

**Spacing:** 4, 6, 8, 12, 16, 20, 24, 32, 40, 48. Dense pages (grids and rails) use an 8 dp gutter. Lists, forms, and full-width buttons use 16.

On a 411 dp screen the column card is `(411 - 8 - 8 - 8) / 2 = 193.5 dp`.

**Radii:** 4 (h36, badges), 6 (h40, h48), 8 (groups, h45, h53), 12 (sheet top), pill (search, chips, discs). A 38 dp search pill has a 19 dp radius.

**Borders:** hairline (`BorderSide` width 0) between rows. Idle chips and the secondary button use a 1 dp border. Product cards have no border and no shadow; the 8 dp gap separates them.

**Shadows:**

| Name | Spec | Where |
| --- | --- | --- |
| none | elevation 0 | Product cards, groups, app bar |
| favorite | offset (0, 2), blur 2, `#33000000` | Heart disc |
| bar | hairline plus offset (0, -2), blur 6, `#14000000` | Top of the tab bar |
| sheet | offset (0, -8), blur 24, `#14000000` | Bottom sheet |

**Icons:** 12 meta, 16 chevron, 20 inline, 24 chrome, 32 inside the 64 dp empty disc. Only the chevron and the back arrow flip with direction.

**Motion:** press 100 ms, fade 200 ms, sheet 250 ms, shimmer 1200 ms. Shimmer and the loading spinner hold still when animations are disabled.

## 4. Theme in Flutter

`dooryTheme()` is Material 3, light, Cairo, scaffold `surface`. `ColorScheme.primary` is `#F27A1A`, `onSurface` is `#333333`, `onSurfaceVariant` is `#666666`, `outline` is `#E6E6E6`. `surfaceTint` is transparent. Splash on light surfaces is `primary-subtle`.

`NavigationBar` in the theme is 56 dp with a transparent indicator. The shell uses `BottomTabBar` rather than that widget. `AppBar` elevation stays 0.

## 5. Navigation and chrome

Five tabs, right to left: الرئيسية، الفئات، المفضلة، السلة، حسابي. Each branch is a `StatefulShellRoute` stack. The bar is 56 dp, icons 24 dp, labels 11 sp. The selected tab is filled and `primary`. The idle tab is outlined and `text-primary`. There is no indicator pill.

The cart badge is the sum of quantities. It hides at 0 and shows `99+` above 99. It sits on the cart icon, 16 dp tall, primary fill.

Until later phases replace them, the five roots are empty states. Home’s bar is the wordmark. The other roots use a 56 dp title bar without a back button. Product, listing, and search routes still push inside the current tab. The previous storefront roots remain available to tests through `buildRouter(legacyStorefront: true)`.

**Search.** Painted height 38, touch height 48, fill `surface-subtle`, no border. The icon sits at the inline start. Hint: «ابحث عن منتج أو فئة». Modes are idle, active, and summary. There is no camera icon.

**App bar.** 56 dp. The title variant centers the title, puts back at the start, and an action at the end. The search variant has no bottom hairline.

**Buttons.** One `DooryButton` with heights 36, 40, 45, 48, and 53, and variants primary, outline, secondary, and text. Outline and text labels use `card-price`. A loading button keeps its size and shows a 20 dp spinner.

## 6. Components

**Product card.** No border, no radius, no shadow. The image well is 2:3, `BoxFit.cover`. The rail card is 137 dp wide. The title is at most two lines: brand in `cardBrand`, then the name in `cardTitle`. The heart is a 32 dp disc in a 48×44 target. A color count above 1 is a 28 dp disc. A missing price collapses. A real compare-at price sits beside the current price with «خصم {n}٪». Sample cards show «بيانات تجريبية».

**Rows and sheets.** Chips are 30 dp inside a 44 dp target. Rows are 56, 42, or 52 dp. Group cards are white, radius 8, on `surface-canvas`. Sheets use a 12 dp top radius, a 56 dp title, a close button, and a 40% scrim. There is no grabber.

**States.** Empty and error states share one column: a 64 dp disc, a title, a message, and an h45 button. Skeletons match the content they replace and shimmer unless motion is reduced.

**Catalog.** `/debug/catalog` is registered only when `kDebugMode` is true. It has no tab bar.

## 7. Images

Product fixtures are 1200×1800 JPEG files under `assets/mock/products/`. Categories, stores, and channels are square. Banners are 1233×315. `DooryImage` covers the well from the center. A missing file shows a quiet `image_outlined` well, and the name and price stay.

## 8. Behaviour that does not change

Safe areas, a 44–48 dp touch target, Android predictive back, and the iOS back swipe stay in force. Lists stay lazy. Pull-to-refresh stays on data screens. The live catalog repositories are unchanged. New screens read the rebuild mock providers, which can be forced to ok, empty, error, or loading. An action that is not wired yet still opens «لم يتم الربط بعد».

RTL uses directional insets and alignment. Carousels start at the inline start. The wordmark, photos, and the search, cart, heart, and star icons do not flip.
