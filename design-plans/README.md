# Delivery plan

The app ships in vertical slices. Each phase leaves behind working screens, typed data, and tests — ready to extend, not a pile of stubs.

| Phase | Plan | Outcome |
| --- | --- | --- |
| 0 | [API foundation](phase-0-api-foundation.md) | Client, models, theme, flavors |
| 1 | [Home and categories](phase-1-home-categories.md) | Home screen and category tree |
| 2 | [Product detail](phase-2-live-product-page.md) | Full product page from `/products/{id}` |
| 3 | [Listing and search](phase-3-listing-search.md) | Category grids and search results |
| 4 | [Store profile](phase-4-store.md) | Merchant store from `/stores/{slug}` |
| 5 | [Full interface on swappable data](phase-5-full-ui-mock.md) | Every screen and control, commerce on labelled Mock repositories |
| Later | [Cart, checkout, and orders](phase-later-cart-checkout-orders.md) | Purchase flow, once contracted |

Phases 0–3 are the first release. Later phases wait on their API contracts. `PRODUCT.md` and `DESIGN.md` apply to every slice.
