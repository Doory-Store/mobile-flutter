# Backend hooks (not wired)

Inventory of every place on the product page, search, and tab bar that
would talk to the server once wiring is approved. Nothing here is
connected yet. Live catalog data already in use (product name, photos,
price, options, store, category, rating, description, share URL, search
results) stays as it was.

Tags in the code:

- `// BACKEND: AVAILABLE <endpoint>` — the current buyer API already
  exposes this (`https://doory.elogyc.com/api/v1`, confirmed against
  `GET /products/{id}`, `GET /search`, `GET /search/suggest`,
  `GET /products/{id}/reviews`, `GET /products/{id}/questions`,
  `GET /products/{id}/recommendations`, and `BackEnd/backend/routes/api.php`).
- `// BACKEND: MISSING <what is needed>` — no source in the current API.

Counts of unique hook spots (mock comments that only document the same
spot are listed with it, not counted twice): **24 AVAILABLE**, **10 MISSING**.
The campaign row counts as AVAILABLE; its list-and-countdown part is MISSING.
Raw tag lines in `lib/` are higher (33 AVAILABLE, 16 MISSING) because the
mock data file repeats the tag next to each placeholder.

## Product detail page

| Screen / element | Tag | Endpoint or needed data |
| --- | --- | --- |
| Favorite toggle | AVAILABLE | `POST /favorites`, `DELETE /favorites/{product_id}` (auth). Favorites stay on the device today. |
| Add to cart (sticky bar and option sheet) | AVAILABLE | `POST /carts`, `POST /carts/{public_id}/lines`. Cart is a local mock today. |
| Camera icon in the PDP search pill | MISSING | Visual / image search endpoint. |
| Product attributes («ميزات المنتج») | AVAILABLE | `GET /products/{id}` → `buyer_attributes`, `buyer_highlights` (returned, not mapped in `ProductDetailDto`). Mock table is shown. |
| Same-store / similar shelf | AVAILABLE | `GET /products/{id}/recommendations` → `similar`, `related`, `also_viewed`. The same-store shelf from `GET /stores/{slug}` stays live. |
| Gallery badge chip | AVAILABLE | `GET /products/{id}` → `badges[{code,label}]` (returned, not mapped). |
| Orange «رمز خاص لك» strip and campaign cards | AVAILABLE (one campaign) / MISSING (list + countdown end) | `GET /products/{id}` → `campaign_badge {title, detail, code}` exists. A list of campaigns and a real countdown end time do not. |
| Brand name before the title | AVAILABLE | `GET /products/{id}` → `brand_name`, `brand_verified` (returned, not mapped). Store name is shown instead. |
| Social-proof ticker, message 1: «شاهده N شخصاً خلال آخر H ساعة» | AVAILABLE | `GET /products/{id}` → `viewer_activity {count, window_hours}` (now mapped on `ProductDetailModel`). |
| Social-proof ticker, message 2: «25 شخصاً أضافوه إلى المفضلة» | **MISSING** (red, sample number) | No `favorites_count` on `GET /products/{id}`. Replaces the old static «1.2K+ من التفضيلات» line. The shown `25` is `CardStrings.sampleFavoritesCount`. |
| Reviews preview, sheet, and star filter | AVAILABLE | `GET /products/{id}/reviews` and `reviews_distribution` on the product. The list today comes from the mock engagement repository. |
| Write a review | AVAILABLE | `POST /orders/{public_id}/product-reviews` (auth; after delivery). |
| Expected delivery date | MISSING | `buyer_delivery_rows` has labels only; no date-range estimate per product/city. |
| City picker | AVAILABLE | `GET /cities`. Delivery estimate per city is MISSING. |
| Delivery partners | MISSING | Courier / partner names per product or city. |
| Payment-method chips | MISSING | No buyer payment-methods list on the product. |
| Return policy row and sheet | MISSING | No per-store return policy text. Only `POST /orders/{public_id}/return-requests`. |
| Seller score | AVAILABLE | `GET /products/{id}` → `store.average_rating` (returned, not mapped in `StoreRefDto`). |
| Seller follower count | AVAILABLE | `GET /products/{id}` → `store.followers_count` (returned, not mapped). |
| Follow / unfollow seller | AVAILABLE | `POST /stores/{slug}/follow`, `DELETE /stores/{slug}/follow` (auth). Follow is kept on the device. |
| Q&A preview and sheet | AVAILABLE | `GET /products/{id}/questions`. Sample questions are shown. |
| Ask a question form | AVAILABLE | `POST /products/{id}/questions` (auth). Sending is not wired. |
| Other sellers | MISSING | No offers / other-sellers endpoint for the same product. |
| Price-drop alert («تنبيه انخفاض السعر») | AVAILABLE | `POST /product-watches` `{product_id, price_drop}`, `GET /product-watches` (`watch_price_drop`), `DELETE /product-watches/{product_id}` (auth). Flags are not on `GET /products/{id}`. The PDP row uses on-device `priceWatchesKey`. |
| Report listing | AVAILABLE | `POST /abuse-reports` (auth). |
| Compare-at price / discount on the sticky bar | AVAILABLE | `GET /products/{id}` → `compare_at_syp`, `discount_percent`, `options[].price_syp` (returned, not mapped). |
| Back-in-stock alert («تنبيه عودة التوفر») and sticky «نبّهني عند التوفّر» | AVAILABLE | `POST /product-watches` `{product_id, back_in_stock}`, `GET /product-watches` (`watch_back_in_stock`), `DELETE /product-watches/{product_id}` (auth). Flags are not on `GET /products/{id}`. The PDP row and sticky notify share on-device `stockWatchesKey`. |

PDP section order (Trendyol-style reorder, visuals later): gallery, special-code
strip, title (price + ticker), seller, campaigns («العروض المتوفرة»),
expected delivery, one shipping-info card (shipping + commitments +
returns), options, price-drop and back-in-stock alerts, features,
description, questions, reviews, other sellers, same-store shelf, more.
Missing logistics copy (expected delivery date, delivery partners,
payment methods, return policy, Doory commitments) is drawn in
`DooryColors.backendMissing`. There is no separate wishlist: favorites
use `GET/POST /favorites` and `DELETE /favorites/{product_id}`.

Photos stay on the live image URLs from `GET /products/{id}` via `cached_network_image`. Share uses the live `share.url`.

## Product card (shelf and listing)

The listing grid and the Home shelf share `ProductCard`.

| Screen / element | Tag | Endpoint or needed data |
| --- | --- | --- |
| Favorites count (heart + compact number, directly under the title) | **MISSING** (red sample `1247` → «1.2 ألف») | No `favorites_count` on `GET /products`, `GET /home`, or `GET /search`. `ProductCardResource` returns only `is_favorited`. Shown only on the categories listing (`ProductCard.showFavorites`). Sample is `CardStrings.sampleListingFavoritesCount`. A live 0 keeps the 14 dp slot empty. |
| Struck compare-at price after the current price | AVAILABLE | `compare_at_syp` and `discount_percent` on the card payload (listing, home, search). Colour `#666666` (`DooryColors.textSecondary`). Shown only when the compare-at is higher and the percent is > 0. Current price stays `#C2410C`. |
| Net-discount tag «خصم صافٍ» | MISSING | No per-card promo / net-discount tag text. |
| Photo-review camera on the rating row | MISSING | No photo-review flag/count per product. |

## Search

| Screen / element | Tag | Endpoint or needed data |
| --- | --- | --- |
| Camera icon in the search field | MISSING | Visual / image search endpoint. |
| Recent searches (rows only; no «سجل البحث» header, no «مسح») | AVAILABLE | `GET /search/suggest` → `recent[]` (signed-in buyer). History is kept on the device today (`doory.mock.recent-searches.v1`, max 10). 3 rows, then «عرض المزيد» shows all; a ✕ per row removes one. |
| Suggested searches («عمليات بحث مقترحة», was «البحث الشائع») | MISSING | No popular / trending terms endpoint. `GET /search/suggest` returns products, categories, stores, and recent only. Eight fixed sample keywords (`popularSearches`) in stadium pills with the red «غير مدعوم» label. |
| Suggestions while typing | AVAILABLE | `GET /search/suggest?q=` → `products[]`, `categories[]`, `stores[]`, `recent[]` (max 5 each, `recent` only with a user or `X-Guest-Key`). **Not wired**: the list is built on the device from history, suggested terms, and the live category tree. Loading (250 ms debounce skeleton) and no-match states are built and ready for the call. |
| Suggestion rows for brands («العلامة التجارية» tag) | MISSING | `/search/suggest` has no brands. Not shown. |
| «تصفّح الفئات» chips | AVAILABLE | Root categories from `GET /categories`; a chip opens `/categories/browse?root=<slug>`. |
| Remove a recent search (✕ per row) | MISSING (server) | `recent[]` is read-only on the server: no delete or clear endpoint. The ✕ removes the word from the on-device list only. The old «مسح» (clear all) was dropped from this page. |
| «سجّل التصفح» shelf (thumbnails, «عرض الكل») | LOCAL | From `BrowsingHistory` (see below): newest 10, image only; «عرض الكل» opens the history page. Hidden when empty. |
| «قطع لك خصيصًا» shelf | MISSING («غير مدعوم», red) | No personalised feed for a buyer. Sample = `GET /products?per_page=10` (`recommendedProvider`, newest first). «عرض الكل» opens `/products?collection=recommended` with the same sample and the red label. Hidden when the call returns nothing. |
| Products under «no results» | AVAILABLE | `GET /home` → `featured` (else `latest`) shown under the note; not search-aware. Hidden when the call fails or returns only a demo sample. |

### Browsing history («سجلّ التصفح»)

| Screen / element | Tag | Endpoint or needed data |
| --- | --- | --- |
| Record a view when a product page opens | AVAILABLE | `POST /products/{id}/view` (optional Sanctum, or `X-Guest-Key` header; 201 `{recorded: true}`). **Not wired** (no new backend calls). |
| Full history list, paging | MISSING | Only `recently_viewed` (max 8, last 50 rows de-duplicated) inside `GET /home` and `GET /products/{id}/recommendations`. No list endpoint and no pagination. |
| Delete / clear history on the server | MISSING («غير مدعوم») | No delete or clear route for `buyer_product_views`. «حذف الكل» and the per-row trash empty the device list only; the dialogs say so in red. |
| History on/off switch | MISSING (server) / LOCAL | No server-side on/off. Local bool `doory.browsing-history-enabled` (default on). Off stops recording only; saved items stay. |
| Price-drop filter («المنتجات التي انخفضت أسعارها») | LOCAL | Compares the price stored at view time with the live price from `GET /products/{id}` (via `productProvider`). Ignores estimates and entries without a stored price. No server field for price drops. |
| Category filter («الفئة») | LOCAL | `category.id/name` from `GET /products/{id}` saved with each entry (v2). Older entries have no category and show only under «الكل». |
| Row: coupon line («تم تطبيق الكوبون») and «العروض المميزة» ribbon | MISSING («غير مدعوم») | No per-product coupon or promo data on the card or detail payload. Not drawn. |
| Row: struck price / discount badge | AVAILABLE (card) | `compare_at_syp` and `discount_percent` come from the tapped card (passed to the page as the route `extra`); a deep link has none. After a detected price drop the viewed price is shown struck with a computed badge. |
| Row: heart, «إضافة إلى السلة» | AVAILABLE | Heart = favourites (local mock today; `POST /favorites`). Button fetches `GET /products/{id}` then adds one unit like the product page (cart is a local mock; `POST /carts/{public_id}/lines`); several options open the option sheet first. |
| History list on the device | LOCAL | `BrowsingHistory` snapshot **v2** (`doory.mock.browsing-history.v2`): up to 30 entries, newest first, de-duplicated, saved when a product page opens (id, slug, name, first photo, store, price, availability, rating, category id/name, price at view time, view time; plus struck price, discount, brand from the tapped card when known). v1 (`…v1`) lists are read once and migrated on the next save; a clear writes v2 so v1 never returns. Route `history` (`/history`, `/account/history`, …). |
| Home «شاهدته مؤخرًا» shelf | AVAILABLE | Cards unchanged: `GET /home` → `recommendations.recently_viewed`. Its «عرض الكل» now opens the local history page (it used to open a grid of the same 8 cards). |

Search results, sort, price filter, and category facets stay on the live `GET /search` (called only with a non-empty `q`).

## Bottom tab bar

| Screen / element | Tag | Endpoint or needed data |
| --- | --- | --- |
| Cart badge count | AVAILABLE | `GET /carts/{public_id}`. Count comes from the local mock cart today. |

## Product card (Home shelves, PDP «منتجات مشابهة» shelf)

`lib/core/widgets/product_card.dart`. The same card also renders in the
listing, search, and store grids. Order follows Doory's web card; look follows
Trendyol. Checked on 2026-11-26 with read-only `GET /products`, `GET /home`,
`GET /products/{id}`, `GET /stores/{slug}`, `GET /products/{id}/reviews`, and
`GET /products/{id}/recommendations`.

Card pieces the server does **not** provide are drawn in pure red
(`DooryColors.backendMissing`, `#FF0000`) so they stand out in review. Remove
the red once the data exists. AVAILABLE pieces render normally and collapse
when an item has no value. Mapping these card fields reads payloads the app
already fetches. No endpoint or action was wired.

| Card element | Tag | Source / needed data |
| --- | --- | --- |
| Product photo | AVAILABLE | `photo` (`…/card.webp`). |
| Seller lead-in, bold («دار المونة») | AVAILABLE | `brand_name`; falls back to `store_name` when there is no brand. |
| Verified check after the seller | AVAILABLE | `brand_verified` (brand only; there is no store verified flag on cards). |
| Product title, 2 lines | AVAILABLE | `name`. |
| Image badge chip («منتج محلي») | AVAILABLE | `badges[].label`. |
| Heart / favorite state | AVAILABLE | `is_favorited` + `POST /favorites`, `DELETE /favorites/{product_id}` (auth). Not wired: the heart still uses on-device favorites. |
| Rating number + partial stars | AVAILABLE | `average_rating`. |
| Rating count «(N)» | AVAILABLE | `reviews_count`. |
| Camera icon (photo reviews) | **MISSING** (red) | A per-product photo-review flag or count. `GET /products/{id}/reviews` items carry only `product_image_url` (the catalog photo), not buyer photos. |
| Net-discount tag line «خصم صافٍ» | **MISSING** (red) | A per-card promo / net-discount label and the rule for when to show it. Only `discount_percent` exists; the red line shows the label only (the percent lives on the price-row badge). |
| Current price | AVAILABLE | `price_syp` (+ `price_is_estimate`). |
| Struck old price | AVAILABLE | `compare_at_syp` (shown only when higher than `price_syp`). |
| «-20%» badge | AVAILABLE | `discount_percent`. First on the price row (RTL: badge, current price, struck old price). |

Gap to raise with the backend: `GET /home` → `featured[]` items omit
`brand_name`, `brand_verified`, `compare_at_syp`, `discount_percent`,
`badges`, and `viewer_activity`, while `latest[]`, `GET /products`, store
products, and recommendations include them. Featured cards therefore show only
the store name, rating, and price.

The product card has no views line. The vertical ticker (every 2 s, sliding
top-to-bottom) lives on the product page, in place of the old «1.2K+ من
التفضيلات» line. It cycles the live views message and a red sample favorites
count, animates only with 2+ messages, stays on the first message under
reduced motion, and pauses when the route or tab is hidden. One app-level
clock (`socialProofClockProvider`) is shared.

Unique card hook spots: **11 AVAILABLE**, **2 MISSING**.

## Fields already returned by `GET /products/{id}` but not mapped in the app DTOs

These are the highest-value AVAILABLE hooks: the payload is already on the wire.

- `brand_name`, `brand_verified`, `brand_id`
- `compare_at_syp`, `discount_percent`
- `campaign_badge {title, detail, code}`
- `buyer_highlights[]`, `buyer_attributes[]`
- `buyer_delivery_rows[]`
- `badges[{code, label}]`
- `viewer_activity` (mapped on `ProductDetailModel` for the PDP ticker; the card does not show a views line)
- `store.average_rating`, `store.followers_count`, `store.reviews_count`, `store.products_count`
- `options[].price_syp`, `options[].compare_at_syp`, `options[].discount_percent`
- `reviews_distribution[]`
- `is_favorited`

Confirmed also present, not used by these three screens yet:

- `GET /products/{id}/reviews`
- `GET /products/{id}/questions` and `POST /products/{id}/questions`
- `GET /products/{id}/recommendations`
- `GET /search/suggest`
- `GET /cities`
- `POST/DELETE /favorites`, `/stores/{slug}/follow`, `/product-watches`
- `POST /abuse-reports`, `POST /carts`, `POST /carts/{public_id}/lines`

## Categories, listing, sort and filters

Checked 2026-11-26 against `BackEnd/backend` (`BuyerCatalogListParams`, `BuyerSearchParams`, `CategoryResource`) and live read-only GETs on `https://doory.elogyc.com/api/v1`.

`GET /categories` returns a flat list of `{id, name, slug, parent_id, image}` (no product counts, no nested children; the app builds the tree). Live tree: 12 categories, 7 roots, max depth 2, most have images.

`GET /products` (the category listing) supports: `category` (numeric id), `include_children` (default true), `store`, `sort` (`newest|price_asc|price_desc`), `min_price_syp`, `max_price_syp`, `page`, `per_page` (default 20, max 50). It returns `{data, meta}` only — no facets. Only in-stock products are listed (no in-stock toggle). `brand` and `city_id` are ignored (total unchanged). Invalid `sort` returns 422.

**Parent-category test (live):** `GET /products?category=3` (بقالة, a parent) returned **129** products; the same call with `include_children=0` returned **43**. Child products are included by default, so «عرض الكل» on a root category is supported.

`GET /search` (requires `q`) also supports `brand` and `city_id`, and returns `facets.category|brand|store` as `{id, count, name, slug}` (live; local code trait builds id+count, live adds name/slug). Engine was `database` with `degraded: true`. Sort options are the same three.

`GET /search/suggest` accepts `q` and `city_id`; returns `products`, `categories`, `stores`, `recent`.

| Filter / sort / chrome | `/products` listing | `/search` | UI |
| --- | --- | --- | --- |
| Newest / وصل حديثاً | SUPPORTED (`sort=newest`) | SUPPORTED | live |
| Price high / low | SUPPORTED | SUPPORTED | live |
| Price range | SUPPORTED | SUPPORTED | live |
| Category + children | SUPPORTED (`include_children` default true) | SUPPORTED | live |
| Store | SUPPORTED | SUPPORTED | not offered in the listing filter page (no store list) |
| Brand | NOT SUPPORTED (param ignored) | SUPPORTED + facet | «غير مدعوم» — no brand list on `/products` |
| City | NOT SUPPORTED (param ignored) | SUPPORTED (`city_id`) | not in the listing filter page |
| Rating, in-stock toggle, discount, attributes, gender, size, color, campaigns, relevance / best-selling / favorites / most-rated sort | NOT SUPPORTED | NOT SUPPORTED | «غير مدعوم» |
| Visual / camera search | NOT SUPPORTED | NOT SUPPORTED | camera shown, not wired (`showNotWired`) |
| Live result count on the filter page | extra `GET /products?per_page=1` using the draft | — | used as a count only, not a new endpoint |
| Price presets | not from the server | — | local SYP proposal |

## Categories landing («كل الفئات»)

`/categories` is the landing page; a card opens `/categories/browse?root=<slug>` (the rail page). Data is `GET /categories` roots only, in API order (fields: id, name, slug, parent_id, image).

| Item | Status | Note |
| --- | --- | --- |
| Root cards (name, photo) | AVAILABLE | `GET /categories`; photo is a square server image |
| Cut-out product art | MISSING | square photos only; a bottom-end crop + 20 dp / 12 dp fades stand in. No label on the card |
| «جديد» flag | MISSING | built (`CategoryLandingCard.showNewBadge`) but hidden; no `is_new` on the category |
| Curated non-category cards (brands, campaigns) | MISSING | only API roots are shown; nothing hard-coded |
| Per-card art direction | MISSING | one crop rule for all cards |
| Visual search (camera on the pill) | NOT WIRED | `showNotWired`; no image-search endpoint |
| Deep link `/categories/c/:slug` | AVAILABLE | still opens the listing; back goes to the landing |
