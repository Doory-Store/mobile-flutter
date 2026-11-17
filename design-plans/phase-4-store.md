# Phase 4 — Store profile

Web counterpart: not yet a route on `main`. Web `lib/links.ts` notes: “Built from Phase 0; store routes land in Phase 4.” The PDP already reads `GET /stores/{slug}` to fill “من نفس المتجر”.

## Goal
A store profile screen that uses the existing `BuyerStoreDetail` contract, and a working store link from the PDP seller card.

## Ship
- Route `/s/:slug` from `storeHref`.
- `GET /stores/{slug}` fields already typed in web `lib/api/types.ts`: `id`, `name`, `slug`, `description`, `area_label`, `followers_count`, `is_followed`, `average_rating`, `reviews_count`, `share`, and a paginated `products` list of `BuyerProductCard`.
- Show only fields that exist. Do not invent a follow feature from `is_followed` / `followers_count` until that behavior is approved and writable. A follow control, if shown earlier, must use the unavailable pattern.
- Ratings and review counts only when genuine (`average_rating` not null).
- Product grid reuses the listing card and can page with the store’s product meta.
- Unknown store / 404 → not-found. API down → labelled demo only when a matching fixture exists; otherwise an honest unavailable state.
- Wire the PDP seller “عرض المتجر” action to this route when the slug is present.

## Do not ship in this phase
- Merchant tools, chat, or unverified “official store” badges.
- Cart or account.

## Done when
- Opening a store from a live PDP shows that store’s name and its products, without demo labels on live fields.
