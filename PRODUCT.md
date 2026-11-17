# PRODUCT — Doory (دوري) mobile

## Register

product

## Platform

mobile (Flutter)

## 1. Purpose and authority
- This file is product and brand context for the buyer **mobile** storefront and for AI design/coding tools working in this repository.
- Read it with `DESIGN.md` before proposing or changing an interface.
- Do not treat either file as approval to install tools or to change business policy.
- The web product file in [Doory-Store/frontend](https://github.com/Doory-Store/frontend/blob/main/PRODUCT.md) is the sibling source of truth for business facts. Keep this file aligned with it. Platform-specific scope and navigation live here.
- Verified = confirmed by Hamza, or directly observed in the cited reference study or in the web storefront implementation.
- Assumption = a proposal or working hypothesis that needs confirmation.
- Product facts below are Verified unless explicitly marked Assumption.

## 2. What Doory is
- Doory is a local online shopping business serving Homs, Syria.
- It connects customers with local merchants and delivery partners.
- Merchants supply goods; delivery partners fulfill orders; Doory holds no inventory.
- Its revenue comes from commission; the exact commission model remains open.
- The selection is focused, not a promise to stock every possible category.
- Success means orders actually delivered, clear final prices, and customers returning.
- Doory must feel like a useful shopping destination, not a startup pitch app.

## 3. Users and context
- Primary users: Homs shoppers, with a mobile-heavy audience. This app is for that primary surface.
- They need an Arabic shopping experience that works on Android and iOS phones (and tablets without inventing a separate iPad brand).
- Arabic is right-to-left; interface copy uses formal Modern Standard Arabic (MSA).
- Assumption: many visits are short, exploratory, or interrupted; preserve context (scroll position, query, selected variant, draft cart) when the process is later approved.
- Assumption: product/price clarity matters more than promotional spectacle.
- Assumption: modest devices and variable connections should shape performance budgets (image sizes, request timeouts, labelled demo fallback only when the API is actually unavailable).
- Validate those usage assumptions; do not invent audience demographics or research.

## 4. Jobs to be done
1. Find a relevant product through search, categories, or a useful product collection.
2. Compare products using truthful images, names, variants, availability, and prices.
3. Understand the selected product before deciding to add it to the cart.
4. Build and revise a cart without losing track of items and quantities.
5. Understand the final payable amount before placing an order.
6. Complete checkout with a clear final payable amount, following approved payment and delivery rules and without inventing unsettled ones.
7. Understand order progress and whether the order was actually delivered.
8. Return to a familiar storefront with consistent navigation and product information.

Jobs 4–7 are product intent. They are **not** an instruction to ship cart, checkout, or tracking screens before approved API contracts and business rules exist. The current web storefront implements discovery, product detail, listing, and search. The mobile MVP follows that same implemented scope.

## 5. Scope of this repository
- Buyer **Flutter** storefront only: Android and iOS.
- Build and maintain a production-quality Arabic RTL e-commerce app that shares system and visual identity with the web storefront.
- MVP storefront surfaces (mirroring what the web app has wired today): home, category navigation, category listing, search, and product details.
- Search, category navigation, and collections must connect to real destinations.
- Later surfaces — cart, checkout, order tracking, account, and store profile — must follow approved business rules and API contracts; do not invent unsettled payment, delivery, or returns policies in the interface.
- Keep widgets ready for production data through stable contracts; clearly labeled demo fixtures stay separate from the UI.

## 6. Non-scope and boundaries
- Seller dashboards, merchant operations, and admin dashboards are separate projects.
- The Next.js web storefront is a separate project. This file is the mobile navigation and platform specification; do not treat web header/mega-menu/footer behavior as a literal screen list.
- Do not design inventory ownership, warehouses, or fulfillment operations for Doory.
- Do not add loyalty, credit, subscriptions, or a wallet as implied requirements.
- Favorites are not a default feature; omit hearts until a real feature is approved. A non-persisting preview toggle, if shown on demo cards, must not be presented as a saved-favorites feature.
- Do not promise payment methods, shipping terms, refunds, or returns not yet decided.
- Do not invent integrations, categories, partner names, or commercial agreements.
- Do not ship app-store, payment, social, or certificate marks as if they were Doory partners. Preview assets, if used, stay labelled dummy images.

## 7. Brand personality
- Trustworthy: factual product information, clear states, and transparent totals.
- Lively: visible orange, stocked product shelves, imagery, and frequent discovery paths.
- Local: relevant to shopping in Homs, without unsupported locality or origin claims.
- Practical: easy to scan and operate on a phone.
- Focused: useful assortment and understandable categories, not artificial abundance.
- Familiar: recognizable commerce patterns rather than novel navigation experiments.
- Not calm/spare, not a luxury editorial boutique, and not a generic startup landing screen.
- Not a discount bazaar: avoid permanent urgency, decorative stamps, and offer overload.
- Assumption: the intended impression is “organized abundance, locally relevant.”

## 8. Voice and Arabic copy
- Use formal, contemporary MSA; be concise, direct, helpful, and respectful.
- Prefer familiar shopping words and concrete action labels over slogans.
- Maintain one term for each concept across navigation, cards, cart, and status messages.
- Examples: “تصفّح الفئات”, “عرض الكل”, “إضافة إلى السلة”, “متابعة التسوق”.
- Search proposal: “ابحث عن منتج أو فئة”; add brands only if supported by the catalog.
- Use real recency for “وصل حديثًا” and real sales ranking for “الأكثر مبيعًا”.
- Use “مختارة لك” only when meaningful personalization actually exists. Live featured shelves on the web use the honest title “مختارات”.
- Neutral curated collections still require real curation and an accurate title.
- Avoid slang, exaggerated superiority, false scarcity, and “everyone is buying” claims.
- Explain errors with a next step; never blame the customer or promise unconfirmed recovery.
- Assumption: maintain a small approved Arabic terminology list as the storefront grows.

## 9. Product principles
1. Delivered value beats attention: browsing is a means to successful orders.
2. Price clarity beats promotional complexity: distinguish price from conditional offers.
3. Content earns space: omit unsupported modules instead of filling decorative slots.
4. Dense does not mean cramped: preserve readable names, prices, and touch targets.
5. Consistency beats novelty: reuse navigation, card, state, and spacing patterns.
6. Accessibility is baseline: TalkBack/VoiceOver, contrast, and reduced motion matter.
7. Be honest about readiness: distinguish unavailable data from a product being unavailable.
8. Do not lock unresolved policies into interface copy, totals, or component defaults.

## 10. Content and data honesty
- Never invent deals, ratings, reviews, badges, coupons, banners, or social-proof counts.
- Never render a decorative favorites heart that does not represent a working feature.
- Product claims need a real source and applicable product/variant/merchant context.
- Old prices and percentage reductions need valid reference prices and correct calculations.
- “Lowest price” claims require sufficient price history, not a single current value.
- Delivery claims require confirmed item, destination, and service eligibility.
- Sponsorship, official-seller markers, and testimonials need genuine supporting evidence.
- Payment/certification marks and app-download links may represent only real capabilities.
- Missing optional metadata means omission, not zeros, fake stars, or invented reassurance.
- Do not convert “API unavailable” into “out of stock” or a misleading empty catalog.
- Images should depict the offered item/variant; do not fabricate product photography claims.
- Do not show a final-total claim while an applicable fee is unknown.

## 11. Demo data and API contract
- Use realistic sample products only where development needs them, clearly labeled as demo data.
- Keep fixtures separate from presentation widgets and API adapters.
- Use a visible demo label such as “بيانات تجريبية” wherever fixture content is displayed.
- Demo prices, stock, and item identities must not be presented as actual merchant offers.
- Do not use fictional reviews, ratings, sales counts, discounts, or delivery promises as filler.
- Model unsupported optional fields as absent; hide the associated UI.
- Real product data should replace fixtures through the same widget-facing contracts.
- Keep price values, currency, variants, quantities, and identifiers structured, not parsed from copy.
- Fall back to labelled demo **only** when the API is unavailable (network failure, HTTP 5xx, or missing base URL). A live 422, 401, 403, 404, or 429 is a real response — never substitute demo data for it.
- A live product 404 is “not found”. Never replace it with an unrelated demo product.
- Assumption: development fixtures are not exposed as a public purchasable catalog.

## 12. Engineering context
- Flutter and Dart; Material widgets themed with the Doory token set in `DESIGN.md`.
- A Laravel buyer API supplies business data (same contract as the web storefront, types aligned with buyer API v0.2.0).
- Follow current Flutter best practices and the conventions in `AGENTS.md`.
- Build clear reusable widgets with single responsibilities and explicit typed contracts.
- Keep data access, normalization, and business decisions out of visual widgets.
- Use framework controls (InkWell, TextField, semantics) before adding custom interaction.
- Do not install tools, create integrations, or alter architecture merely to enforce these docs.

## 13. Open business decisions — do not settle here
- Commission model: rates, basis, collection, and commercial terms.
- Delivery operator: which partners operate delivery and how responsibilities are assigned.
- Cash on delivery and other payment methods.
- Address capture: fields, timing, and location requirements.
- Delivery fee: calculation, payer, visibility, and eligibility.
- Wallet and refunds: whether a wallet exists and how refunds operate.
- SMS/WhatsApp notifications: channels, consent, events, and providers.
- Returns policy: eligibility, process, costs, and timelines.
- Mobile bottom navigation: the web design study did not include a fixed shopping tab bar. Add one only with approval, real destinations, safe-area padding, and labels. (Assumption proposal is in `DESIGN.md` and `design-plans/`.)
- Numeral style and currency presentation: need confirmation (web cards use Latin digits and the currency label “ل.س”).
- When a decision is approved, reflect it here; silence in these documents is not a policy decision.

## 14. Success measures
- Primary outcome: orders actually delivered; define the denominator and reporting window.
- Price clarity: customers can identify the final payable amount before committing.
- Trust and return: returning customers and repeat delivered orders over defined periods.
- Supporting funnel: successful discovery, product-detail visits, cart progression, checkout completion.
- Guardrails: misleading-price complaints, failed fulfillment, accessibility barriers, and errors.
- Assumption: these are measurement recommendations, not an implemented analytics schema.
- No targets, conversion benchmarks, or success percentages have been approved.

## 15. Design reference and confirmation
- Main reference: https://www.trendyol.com/ — Turkish homepage, observed 11 November 2026.
- Study: https://cursor.com/canvas/store-7cf940d4-15be-4417-b6ce-d318e6aead14/f003747f-84cc-4160-bd1e-ca9487382ed7
- Web implementation to stay aligned with: [Doory-Store/frontend](https://github.com/Doory-Store/frontend) (`DESIGN.md`, `app/globals.css`, and storefront components).
- Take shopping structure and energy; adapt identity, RTL, language, assortment, and **mobile navigation** for Doory.
- Confirm proposed typography, token choices, and any bottom-nav proposal in `DESIGN.md` before implementation.
- This document does not settle open business policy.
