# PRODUCT — Doory (دوري)

## Product

Doory is a local shopping business in Homs, Syria. It connects shoppers with local merchants and delivery partners. Merchants supply the goods; partners fulfill the orders; Doory holds no inventory. Revenue is a commission; the exact model is still open. The assortment is focused. The product succeeds when orders actually arrive, prices are clear before a shopper commits, and people come back.

The app should feel like a practical place to shop: organized, local, and easy to scan on a phone. It is lively — visible orange, real product photography, short paths into the catalog — and it stays clear of luxury-editorial emptiness, generic marketing splash screens, and permanent-discount spectacle.

## Audience

Primary users are shoppers in Homs, mostly on phones, often on modest devices and uneven connections. Sessions can be short or interrupted, so the app preserves context (scroll, query, selected variant) as features come online.

The interface is Arabic, right-to-left, written in formal contemporary Modern Standard Arabic. Copy is concise, direct, helpful, and respectful. One term is used for each concept across navigation, cards, and status messages:

- «تصفّح الفئات»
- «عرض الكل»
- «إضافة إلى السلة»
- «متابعة التسوق»
- Search placeholder: «ابحث عن منتج أو فئة»
- Recency shelf: «وصل حديثًا» when the data is actually recent
- Featured shelf: «مختارات»
- «مختارة لك» only when personalization is real
- «الأكثر مبيعًا» only when it reflects real sales ranking

Errors explain what happened and what the shopper can do next, without blame.

## Jobs

1. Find a relevant product through search, categories, or a genuine collection.
2. Compare items using truthful images, names, variants, availability, and prices.
3. Understand the selected product before adding it to a cart.
4. Build and revise a cart, then see the final payable amount, complete checkout, and follow the order through to delivery — when those contracts exist.
5. Return to a familiar storefront with stable navigation and product information.

## Scope

This repository is the buyer app for Android and iOS. The first releases cover home, category browsing, category listing, search, and product detail — the surfaces already supported by the buyer API.

Store profiles follow in a later phase. Cart, checkout, order tracking, and account follow once payment, delivery, address, and auth contracts are approved. Seller, merchant, and admin tools belong in other products.

Loyalty, credit, subscriptions, wallets, and a persisted favorites feature are not part of the current product. A heart on a sample card, if shown, is a local preview and is labelled as such.

## Principles

These rules keep the catalog honest and the engineering scope tight.

- **Price clarity.** The amount on screen is the price the shopper should expect to pay for that item. When the API marks a price as an estimate, the UI labels it «سعر تقريبي». A missing `price_syp` is omitted; it is not shown as zero. A compare-at price or discount chip appears only with a valid reference price, or with a visible «بيانات تجريبية» label when it is sample decoration beside a live amount.
- **Data earns its slot.** Ratings, review counts, delivery promises, badges, coupons, and social proof render only when the data is real (or clearly labelled sample content). Optional fields that the API omits leave the row out.
- **Service status stays distinct from stock.** An unreachable API is an unavailable-service state. A product that cannot be sold is «نفدت الكمية» or a can’t-purchase state, driven by `available` / `can_purchase`.
- **Sample content is labelled.** Fixtures used for development or for a down API are marked «بيانات تجريبية» and live outside presentation widgets. A live `404` is a not-found screen. A live validation or client error is shown as that error. Labelled samples are used only when the API is unreachable (network failure, HTTP 5xx, or a missing base URL) and a matching fixture exists.
- **Current API surface.** The app talks to the published buyer GET endpoints: `/health`, `/meta/status`, `/cities`, `/categories`, `/home`, `/products`, `/products/{id}`, `/search`, and `/stores/{slug}`. Cart, checkout, and account work begins when those contracts exist.
- **Open policy stays open.** Payment methods, delivery operators and fees, address capture, wallets, refunds, returns, and notification channels are decided in the business, then reflected here. Silence is not a policy.

## Open decisions

- Numeral style and currency presentation (cards today use Latin digits and the currency label «ل.س»).
- Cart-count convention (a reasonable default is total item quantities).
- A system tab bar is an open product decision; the shipping navigation model is described in `DESIGN.md`.
- Commission model and the policy items listed under Principles.

When a decision is made, this file is updated.

## Success

The primary outcome is orders actually delivered. Supporting signals are price clarity before commitment, successful discovery and product-detail visits, and, later, cart and checkout completion. Guardrails include misleading-price complaints, failed fulfillment, and accessibility barriers. No numeric targets have been approved yet.
