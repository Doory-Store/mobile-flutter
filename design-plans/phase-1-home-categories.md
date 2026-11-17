# Phase 1 — Home and categories

Web counterpart: branch `cursor/phase-1-home-categories-43d4`, plus `lib/home/load-home.ts`, `components/home/*`, and `components/site/*` in the frontend repo.

## Goal
The home screen and category chrome use live `/home` and `/categories` when the API is up, and labelled demo fixtures when it is unavailable.

## Ship
- Home screen following `DESIGN.md` §6: app bar, optional maintenance and delivery lines, search entry, category access, labeled hero, one shortcut rail, optional brand rail, product shelves, mosaic, suggestion pills, popular-category links, short SEO block, compact footer.
- `loadHomeContent` equivalent of web `lib/home/load-home.ts`:
  - Start from demo home.
  - If categories load, replace the tree and shortcut rail (tones rotate teal, rose, terracotta, green, wine, cyan). Drop the shortcuts demo label when live shortcuts exist.
  - If `/home` is down, keep the labelled demo home.
  - If `/home` is up, insert live “مختارات” (`featured`) and “وصل حديثًا” (`latest`) beside any labelled flash/demo shelves. Do not use “مختارة لك”.
  - Delivery line: live `delivery_promise.message_ar` when present, otherwise the labelled demo line.
- Product card widget per `DESIGN.md` §10 (2:3 contain image, 8px radius, 1px border, `card-price` amount, optional rows collapse, 160px minimum width, ~1.75 cards with peek).
- Shortcut rail: 68px circles, one horizontal row, ~88px item width, labels 10px/600 on the phone.
- Search field in the app bar / home: 44px, `#F5F5F5`, 20px radius, placeholder “ابحث عن منتج أو فئة”. In this phase it may navigate to an empty search route or show “غير متاح بعد” until phase 3 wires results.
- Category chrome: horizontal chips and a “تصفّح الفئات” tree screen from `mapCategoryTree`. No desktop mega menu.
- Shared category-tree loader with demo fallback, as in `loadCategoryTree()`.
- Account, favorites, and cart app-bar actions, if shown, use the unavailable pattern. No fake cart count. No persisted favorite.

## Do not ship in this phase
- Wired listing filters or search results (phase 3).
- A live PDP (phase 2). Cards may navigate to a placeholder route.
- Cart, checkout, or bottom nav (unless already approved — it is not).

## Done when
- With a live API, featured and latest shelves render real cards and shortcuts come from the category tree.
- With the API down, every fixture block shows “بيانات تجريبية” and no block is presented as a real offer.
- Arabic names wrap; the page does not scroll sideways; touch targets are 44px.
