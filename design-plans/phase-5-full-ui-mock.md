# Phase 5 — Full interface on swappable data

## Goal

Every screen, button, and control of the buyer app exists and responds, so the whole journey (browse, choose, add to cart, check out, follow the order, manage the account) can be walked, reviewed, and refined on a device before each commerce contract is wired. When a domain's endpoint is ready, connecting it is a one-line provider change.

## Principles

- **The catalog stays live.** Home, categories, product detail, listing, search, and the store profile read `https://doory.elogyc.com/api/v1`. Real prices and real stock are the best test of layout, so they remain the source wherever a contract exists.
- **Commerce runs on fixtures shaped like the contract.** Cart, auth, addresses, checkout, orders, notifications, reviews, and support read Mock repositories whose JSON mirrors the schemas in the backend `docs/openapi/buyer-v1.yaml`. Models parse that JSON with the same `fromJson` the Live repository will use, so wiring changes the source of the bytes, not their shape.
- **Sample data is always labelled.** A screen fed by a Mock repository shows the small «بيانات تجريبية» badge. Shoppers and reviewers can always tell a real number from an illustration.
- **Every tap answers.** A control either completes its action on sample data (with a toast, a state change, or navigation) or opens the single «لم يتم الربط بعد» dialog naming the server action it needs. A disabled control states why it is disabled.

## Data layer

`lib/data/repositories/commerce/` holds one interface per domain in `commerce_contracts.dart`:

| Interface | Endpoints it represents | Today |
| --- | --- | --- |
| `CartRepository` | `/carts`, `/carts/{public_id}/lines`, `/coupons` | Mock, persisted with `shared_preferences` |
| `AuthRepository` | `/auth/otp`, `/auth/otp/verify`, `/me`, `/auth/logout` | Mock, sample code `482910` |
| `AddressRepository` | `/addresses`, `/neighborhoods` | Mock, Homs neighborhoods |
| `CheckoutRepository` | `/payment-guide`, `/delivery/slots`, `/pickup-points`, `/checkouts` | Mock, preview only |
| `OrderRepository` | `/orders`, `/orders/{public_id}` | Mock, orders in every status |
| `NotificationRepository` | `/notifications`, `/me/notification-preferences` | Mock |
| `EngagementRepository` | product and store reviews, help articles, support tickets | Mock |

Each interface has a `Mock…Repository` in `mock_repositories.dart` and a `Live…Repository` in `live_repositories.dart`. The Live classes name their endpoint and throw `NotWiredException` until implemented. `commerce_providers.dart` is the only place that chooses between them. Mock latency (`mockLatency`, 350 ms) keeps loading states visible on a device; tests set it to zero in `test/flutter_test_config.dart`.

A Mock repository rejects invalid input the way the server will: a wrong OTP, an unknown coupon, a neighborhood outside delivery, a missing name. Those rejections arrive as `DomainRejection` with MSA copy, so error states are designed now rather than discovered later.

## Component library

`lib/core/widgets/ui_kit.dart` and its neighbours give every screen the same vocabulary:

- `DooryPrimaryButton` (with a busy state) and `DooryOutlineButton`.
- `SectionCard` for grouped content, `InfoRow` for label/value pairs and totals.
- `QuantityStepper`, which becomes a delete action at the minimum quantity.
- `ProductThumb`, chips, bottom sheets for sort, price, options, and pickers.
- Empty, loading, and error states through `StatusMessage`.
- `showToast`, `confirmDialog`, and `showNotWired` for feedback.

Building screens from these pieces keeps spacing, radii, and colors on the Doory tokens and makes a brand change a single edit.

## Journey

1. **Listing.** Sort sheet (newest, price ascending, price descending) and a price range sheet with validation, both sent to the live `/products` query. Sub-category chips sit above the grid.
2. **Product.** Gallery, price and offer, option selection, quantity stepper, add to cart with a cart badge in the app bar, favorite toggle, store link, reviews, and the delivery promise.
3. **Cart.** Lines grouped by store with a link to each store, quantity changes, remove with undo, coupon entry (`DOORY10`), item subtotal, a flat delivery fee per store, discount, and grand total. Checkout opens only when every line is purchasable.
4. **Checkout.** Delivery or pickup, address selection with a shortcut to add one, delivery slot, payment method from the payment guide with its steps, notes, and the full breakdown. Guests are routed to login and returned to checkout.
5. **Confirmation.** A labelled preview of the checkout record, payment instructions with receiving accounts and copy buttons, and paths to orders or home.

## Account

- **Login.** Phone entry with format validation, a mock OTP with resend countdown, and a return to the page that asked for login.
- **Profile.** Name editing on sample data; phone change, password, sessions, data export, and account deletion name their server action.
- **Addresses.** List, add, edit, delete, and set default, with a city and neighborhood picker.
- **Orders.** Status filter, order cards, and an order detail with a status timeline, store groups, totals, payment state, reorder, and support shortcuts.
- **Settings.** Notification preferences, and links to support, connection status, and policy pages.

## Around the journey

- **Favorites.** Stored on the device; add all to cart, clear with confirmation.
- **Store.** Live profile with products and an about tab; follow on the device, sample reviews, message and report actions.
- **Notifications.** Bell with unread count, mark one or all as read, tap through to the related order.
- **Support.** Help articles, contact channels, sample tickets, and a new ticket form with validation.

## Server-only actions

These open «لم يتم الربط بعد» with the action's name: placing a real order, submitting payment proof, cancelling a checkout or an order, returns, publishing a review, product questions, back-in-stock alerts, messaging or reporting a store, sending a support ticket, attachments, ticket threads, WhatsApp and phone handoff, map pin, phone change, password, sessions, data export, account deletion, WhatsApp OTP, password login, and policy pages.

## Acceptance

- Every visible control produces feedback; nothing is a dead tap.
- Mock-backed screens carry «بيانات تجريبية»; live screens do not.
- `flutter analyze` is clean, `flutter test` passes (repositories, cart math, coupons, OTP, addresses, widgets), and `flutter build apk --debug` succeeds.

## Wiring a domain

1. Implement the methods of its `Live…Repository` against the Dio transport, reusing the model's `fromJson`.
2. Return the Live class from its provider in `commerce_providers.dart`.
3. Drop the sample badge for that domain (`isSample` becomes `false`).
4. Replace the matching «لم يتم الربط بعد» calls with real actions and add tests for the failure paths.
