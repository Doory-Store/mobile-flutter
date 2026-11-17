# Phase 2 — Live product page

Web counterpart: branch `cursor/phase-2-live-product-page-8ef2`, plus `lib/product/load-product.ts`, `lib/api/map-product-detail.ts`, and `components/product/*` in the frontend repo.

## Goal
A production-quality product detail screen driven by `GET /products/{id}`, with honest empty/unavailable states and labelled demo only for matching fixtures when the API is down.

## Ship
- Route `/p/:ref`. Parse `ref` with the web rule (`parseProductRefId`: leading digits, safe positive integer). Optional `id-slug` form is allowed; the backend owns the slug.
- `loadProductPage` rules from web `lib/product/load-product.ts`:
  - Non-numeric ref → matching demo fixture or not-found.
  - Live numeric id, `ok` → map `BuyerProductDetail` to the widget contract. Overlay demo-only PDP modules (campaigns, questions) only when they are labelled demo and not presented as live offers.
  - Live `not_found` → not-found screen. Never an unrelated demo product.
  - Network / 5xx → matching demo fixture if one exists; otherwise “صفحة المنتج غير متاحة بعد”.
- PDP composition (adapt web `components/product/*` and `design-plans/single-product-page/PLAN.md` to a phone column):
  - Gallery (`BoxFit.contain` on white), optional unavailable/preview heart
  - Title (`text-product`), brand, seller name
  - Live price in `price` (`#F27A1A`, 24/28, 600). “سعر تقريبي” when `price_is_estimate`. Hide the amount when `price_syp` is null; never coerce to 0. Compare-at and discount chips only when genuine, or clearly labelled demo beside a live price (`discountIsDemo`)
  - Variants from `options` (`available`, `low_stock_hint`)
  - Quantity stepper (local only until cart exists)
  - Buy box: “إضافة إلى السلة” / “اشتر الآن” as unavailable controls until cart/checkout exist (`can_purchase` still affects enabled/disabled and copy, but must not pretend the action succeeded)
  - Highlights, attributes, description, delivery rows only when data exists — no invented policy
  - Seller card; store link waits for phase 4 or uses unavailable
  - Reviews and questions only when genuine (or labelled demo fixtures). Empty stars are `border`, fills are `rating`, and the numeric score is required
  - “من نفس المتجر” rail from `GET /stores/{slug}` products; if the store request fails, a labelled demo similar rail is allowed (`similarIsDemo`)
- Sticky compact price/CTA bar on scroll is allowed (web compact price 16/19, 40px actions).
- Breadcrumb: الرئيسية → category (only when the category slug is a known `/categories` segment) → product name.

## Do not ship in this phase
- A working add-to-cart or checkout flow.
- Invented coupons, delivery windows, or “official seller” badges.
- A fake reviews distribution.

## Done when
- A live product id renders API photos, name, store, and price without demo labels on those live fields.
- A random unknown id shows not-found, not another product.
- Stopping the API on a live id with no fixture shows “صفحة المنتج غير متاحة بعد”.
