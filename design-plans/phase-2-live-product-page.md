# Phase 2 — Product detail

## Goal

Opening a product shows a complete, honest detail page driven by `GET /products/{id}`, with gallery, price, variants, and related modules that have data.

## Scope

- Route `/p/:ref`. `ref` is parsed as a leading positive integer; an optional `-slug` suffix is accepted. Canonical navigation uses the slug the API provides.
- Page composition (phone column): gallery with `BoxFit.contain` on white; title and brand; seller; price at 24/28 in the price color; «سعر تقريبي» when `price_is_estimate`; variants from `options` (`available`, `low_stock_hint`); local quantity stepper; buy box; highlights, attributes, and description when present; delivery rows that have data; reviews when a real rating exists; “from the same store” rail.
- Sticky compact bar (16/19 price, 40px action) after the shopper scrolls past the buy box.
- Breadcrumb: الرئيسية → category (when the slug is a known category) → product name.
- Pull-to-refresh, gallery skeletons, and shared-element or hero transition from the card image when motion is enabled.
- Add to cart and buy are on the page as primary actions. Until the cart contract exists they explain that checkout is coming; `can_purchase` still drives enabled state and copy.
- «من نفس المتجر» is filled from `GET /stores/{slug}`. If that call fails, a labelled sample rail is acceptable. The seller’s store link can wait for phase 4 or open a placeholder that this phase already routes.

## Screens

- Product detail (`/p/:ref`)
- Not-found (`/p/:ref` when the id is unknown)
- Unreachable state: a matching labelled sample page when a fixture exists; otherwise a short “this product is unavailable right now” screen with retry

## Data

- `GET /products/{id}` — `BuyerProductDetail` (`name`, `photos`, `price_syp`, `price_is_estimate`, `can_purchase`, `store`, `category`, `options`, `description`, `average_rating`, `reviews_count`, `seo`, `share`)
- `GET /stores/{slug}` — products for the same-store rail
- `GET /categories` — to resolve breadcrumb links

Resolution rules:

- Live id, `ok` → map the DTO to the UI model. Sample-only modules (for example a decorative campaign) carry «بيانات تجريبية».
- Live id, `notFound` → not-found screen.
- Unreachable host → matching fixture if one exists, otherwise the retryable unavailable screen.
- A missing `price_syp` hides the amount.

## Acceptance

- A live id shows API photos, name, store, and price, with demo labels only on modules that are actually sample content.
- An unknown id shows not-found.
- Stopping the API on a live id with no fixture shows the unavailable screen, not a different product.
- Variants, estimates, and sold-out/can’t-purchase states follow the API flags.
- TalkBack/VoiceOver announces the title, price, and availability. Large text wraps. Goldens cover the upper half of the PDP (gallery + price + buy box).

## Risks

- Photo lists can be large; cache and a page-view gallery keep memory in check.
- SEO/canonical slugs may change; the parser stays tolerant of `id` and `id-slug`.
- Mixing live price with labelled sample promotions needs careful layout so the shopper can tell them apart.
