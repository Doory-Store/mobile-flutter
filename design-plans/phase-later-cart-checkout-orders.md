# Later — Cart, checkout, and orders

## Goal

A shopper can add purchasable items to a cart, see a complete payable total, place an order under the approved payment and delivery rules, and follow that order through to delivery.

## Scope

This phase starts when the buyer API and business rules for cart, checkout, payments, addresses, delivery fees, and order tracking are approved and written down, and when the open items in `PRODUCT.md` that this flow depends on have been decided (payment methods including cash on delivery, address capture, delivery fees, wallet/refunds, returns, notifications).

Once that is in place, the work includes:

- Cart screens and a cart badge driven by real cart state (default convention: total item quantities, confirmed at the start of the phase).
- A checkout flow that shows the final payable amount only when every applicable fee is known.
- Order history and a tracking view that reports whether the order was delivered.
- Auth and a light account area, if the same contract introduces them.
- The PDP add-to-cart and buy actions become live.
- The Cart and Account tabs in the bottom bar switch from their empty states to the live screens; the Cart tab gains its count badge.

Until this phase starts, the Cart and Account tabs show their coming-soon empty states, and the app remains on the GET catalog surface.

## Screens

- Cart
- Checkout (address, delivery, payment, review)
- Order confirmation
- Order list and order detail / tracking
- Account (if contracted)

## Data

The endpoints are those in the approved contract. They will be added to the Dio client, freezed models, and repositories in this phase, with the same result-type pattern as the catalog.

## Acceptance

- A shopper can add a live, purchasable product, change quantities, see an honest total, place an order, and later see whether it was delivered.
- Copy about payment, shipping, and returns matches the approved policy — nothing earlier, nothing extra.
- Recoverable errors keep the cart and explain the next step in MSA.
- Tests cover quantity changes, totals, and the main failure paths (validation, stock change, network drop mid-checkout).

## Risks

- Totals that omit a fee are a trust failure; the UI waits for a complete breakdown.
- Auth token storage, session expiry, and guest checkout need a clear design once the contract lands.
- Platform payments (if any) have store-review implications; cash on delivery may be the first method.
