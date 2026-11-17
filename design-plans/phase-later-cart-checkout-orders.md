# Later — Cart, checkout, and orders

Web counterpart: these surfaces are in scope for the buyer storefront (`PRODUCT.md` jobs 4–7) but are **not implemented** on the current web `main` branch. There are no cart or checkout endpoints in the web `lib/api` client (GET-only).

## Goal
Let a shopper build a cart, see a complete payable total, place an order under approved payment and delivery rules, and track whether the order was actually delivered.

## Do not start this phase until
- The buyer API contract for cart, checkout, payments, addresses, delivery fees, and order tracking is approved and documented.
- The open business decisions in `PRODUCT.md` §13 that this flow would otherwise invent have been decided: payment methods (including cash on delivery), address capture, delivery fee, wallet/refunds, returns, and notifications.
- Any mobile bottom-nav proposal that includes السلة or حسابي has been confirmed.

## When it is approved, design to these rules
- Cart counts derive from actual cart state (proposed convention: total item quantities — confirm before shipping). Hide a zero badge if the label already says the cart is empty.
- Price clarity: the customer can identify the final payable amount before committing. Do not show a “final total” while an applicable fee is unknown.
- Do not promise payment methods, shipping terms, refunds, or delivery windows that are not in the contract.
- Preserve cart state across recoverable errors. Explain failures in MSA with a next step.
- Add-to-cart and buy actions on the PDP become real only in this phase; until then they stay unavailable controls.
- Account / login / profile wait on the same approved auth contract. The current web client sends no `Authorization` header.
- Favorites / follow remain out unless separately approved.

## Until then
- App-bar cart and account icons, if present, use the unavailable pattern (“غير متاح بعد”).
- Do not store a pretend cart on device and present it as a real order path.
- Do not add unofficial POST endpoints or local-only checkout flows.

## Done when (after approval)
- A shopper can add a live, purchasable product, change quantities, see an honest total, place an order, and later see whether it was delivered — with no invented policy copy.
