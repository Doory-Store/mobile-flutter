# Phase 1 — Home and categories

## Goal

A shopper can open the app, scan the catalog on the home screen, and move into a category tree. Live `/home` and `/categories` drive the UI when the host is up.

## Scope

- Home as specified in `DESIGN.md` §5–7: app bar, optional maintenance and delivery lines, search entry, shortcut rail, optional brand rail, product shelves, mosaic, suggestion pills, popular-category links, short about block, compact footer.
- Category tree screen («تصفّح الفئات») and a horizontal shortcut rail on home (68px circles, one row, ~88px items).
- Product card (2:3 contain image, 8px radius, `card-price` amount, collapsing optional rows, ~1.75 cards with peek).
- Search field in the app bar: 44px, 20px radius, placeholder «ابحث عن منتج أو فئة». In this phase it may open a search route that is completed in phase 3.
- Home assembly:
  - Categories populate the tree and the shortcut rail (tones rotate teal, rose, terracotta, green, wine, cyan).
  - Live shelves: «مختارات» from `featured`, «وصل حديثًا» from `latest`.
  - Delivery line uses `delivery_promise.message_ar` when present.
  - When the API is unreachable, labelled sample modules fill the same slots.
- Pull-to-refresh, section skeletons, and a retryable error on the home scroll view.
- Cart and account controls, if shown in the bar, remain inactive until those phases.

## Screens

- Home (`/`)
- Category tree (`/categories` or a pushed «تصفّح الفئات» route)

Product cards may navigate to `/p/:ref`; the destination is completed in phase 2. Shortcut and tree rows navigate to `/c/:slug`; listing is completed in phase 3.

## Data

- `GET /home` — `delivery_promise`, `featured`, `latest`
- `GET /categories` — flat list, assembled into a tree in the repository
- `GET /meta/status` — banner already wired in phase 0

## Acceptance

- Against a live host, featured and latest shelves show real cards; shortcuts and the tree come from the category API; live modules are unlabelled.
- Against a stopped host, the same layout appears with «بيانات تجريبية» on sample modules, plus a retry control.
- Arabic names wrap; the page itself does not scroll sideways; targets are 44–48 dp; pull-to-refresh reloads home.
- Widget tests cover the card and the empty/error home states; a golden locks the card and a shelf row at 390 wide.

## Risks

- Large category trees need lazy list rendering in the tree screen.
- Home will combine live shelves with labelled collections in early releases; labels have to stay accurate so the two sources are not confused.
- Image-heavy shelves on a modest device: keep `BoxFit.contain`, cache bounds, and lazy lists.
