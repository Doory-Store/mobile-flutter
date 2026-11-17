# DESIGN — Doory (دوري) mobile

## 1. Direction and evidence
- Direction: Trendyol in Arabic for Doory, adapted to a Flutter phone app — not a pixel copy of the website or of Trendyol, and not a discount-campaign clone.
- Read `PRODUCT.md` first; product/data honesty and open business decisions govern every widget.
- The web design file in [Doory-Store/frontend](https://github.com/Doory-Store/frontend/blob/main/DESIGN.md) and the implemented tokens in `app/globals.css` are the shared visual source of truth. This file maps those tokens to Flutter and records mobile-only layout decisions.
- Verified = confirmed Doory requirement, measured reference, or a value implemented as the web storefront source of truth.
- Assumption = a proposed Doory or mobile-adaptation value.
- Unless labeled Verified, concrete new mobile-only layout values below are Assumption proposals.
- Confirm unsettled token, typography, bottom-nav, and numeral proposals with Hamza.
- Reference: Turkish https://www.trendyol.com/, inspected 11 November 2026, signed out.
- Study: https://cursor.com/canvas/store-7cf940d4-15be-4417-b6ce-d318e6aead14/f003747f-84cc-4160-bd1e-ca9487382ed7
- Verified: reference viewports were 1440×900 and 390×844; phone was resize-only, not touch emulation.
- Verified: “Flutter apps are separate projects; this is not their navigation specification” (web `PRODUCT.md` §6). Mobile navigation is specified here, not copied from the web header.

## 2. Take / adapt / leave out
- Take: visible orange, compact navigation, round shortcuts, bordered cards, carousels, view-all links.
- Take: a light interface shell that lets real product imagery create variety and energy.
- Take: the exact semantic color, type, radius, spacing, and shadow tokens below.
- Adapt: Arabic RTL, MSA copy, Homs assortment, Arabic typography, accessible orange roles, and **phone composition** (full-bleed modules, one shortcut row, stacked product information, a category screen instead of a desktop mega menu).
- Adapt: fewer genuine collections rather than hundreds of repeated promotional tiles.
- Leave out: permanent discount spectacle, intrusive interest popups, and page-level overflow.
- Leave out: invented claims, a saved-favorites feature, fake offers, and unapproved service promises. The shelf-card heart in web `DESIGN.md` §11 is a non-persisting preview toggle.
- Verified: Trendyol’s observed wordmark was dark; an orange Doory wordmark is an adaptation.
- Verified: campaign frames were image-based purple/cyan; an orange Doory frame is an adaptation.
- Leave out of MVP: web-only chrome such as a multi-row desktop header, a hanging category mega menu, a wide footer link farm as the primary way to browse, and desktop hover-only behaviors.

## 3. Semantic colors — one shared source of truth
Use a single Dart token class (see §16). Widgets must not scatter raw brand hex values.
Confirmed storefront pass, 13 November 2026, recorded in web `DESIGN.md` §3 and implemented in `app/globals.css`. These hex values are the source of truth. There are **no oklch tokens** in the implemented theme. Do not restore `#B95800` as the default fill.

| Token | Hex | CSS variable (`app/globals.css`) | Role |
| --- | --- | --- | --- |
| primary | `#F27A1A` | `--primary` | Brand orange: decorative accents and the same orange as primary-strong in this pass |
| primary-strong | `#F27A1A` | `--primary-strong` | Primary fill, orange text on white, active tabs, key icons, outline button border and label |
| primary-hover | `#D56B17` | `--primary-hover` | Pressed primary fill. `#F27A1A` mixed 12% toward black (each channel × 0.88). Also the price color on the light brand tint |
| primary-subtle | `#FFF3E8` | `--primary-subtle` | Light brand tint for supported shortcut/featured accents and the maintenance strip |
| surface | `#FFFFFF` | `--surface` | Page, cards, elevated content |
| surface-subtle | `#F5F5F5` | `--surface-subtle` | Search, quiet chips, spec rows, loading blocks, footer |
| surface-inverse | `#333333` | `--surface-inverse` | Inverse surfaces; always paired with text-on-strong |
| text-primary | `#333333` | `--text-primary` | Body, titles, essential information |
| text-secondary | `#666666` | `--text-secondary` | Supporting copy, placeholder copy, old price (PDP) |
| text-on-strong | `#FFFFFF` | `--text-on-strong` | Text and icons on primary fills |
| border | `#E6E6E6` | `--border` | Card borders, dividers, and the empty star track |
| border-control | `#858585` | `--border-control` | Essential control boundary where no other cue provides contrast |
| price | `#F27A1A` | `--price` | PDP price on white, discount chips, and other brand-orange amounts. Not Trendyol Plus pink |
| card-price | `#C2410C` | `--card-price` | Current price on the shelf card only. `#F27A1A` at 16px on white is about 2.6:1, so the card amount uses this darker orange |
| text-muted | `#999999` | `--text-muted` | Struck compare-at amount on the shelf card |
| discount | `#BB0000` | `--discount` | Genuine reduced price/discount only |
| success | `#137333` | `--success` | Confirmed success/availability state, always paired with text/icon |
| danger | `#BB0000` | `--danger` | Errors, always explained with copy |
| rating | `#FFC000` | `--rating` | Filled star only when genuine review data exists |
| preview-plus | `#FF4988` | `--preview-plus` | Shelf-card Plus line only. Preview fixture, not a brand or price token |
| category-tile-teal | `#2B6E77` | `--category-tile-teal` | Popular-category / shortcut ink; white label (5.83:1) |
| category-tile-rose | `#9A404A` | `--category-tile-rose` | Reserved sixth tone (6.55:1) |
| category-tile-terracotta | `#9A4C3D` | `--category-tile-terracotta` | White label (6.04:1) |
| category-tile-green | `#407C3D` | `--category-tile-green` | White label (5.04:1) |
| category-tile-wine | `#982F49` | `--category-tile-wine` | White label (7.40:1) |
| category-tile-cyan | `#1F7B8E` | `--category-tile-cyan` | White label (4.90:1) |
| category-tile-violet | `#4A3D78` | `--category-tile-violet` | Mosaic fill only; white label (9.42:1). Purple, not Plus pink |
| shortcut-teal | `#DFF5F4` | `--shortcut-teal` | Shortcut circle pastel |
| shortcut-rose | `#FDECEF` | `--shortcut-rose` | Shortcut circle pastel |
| shortcut-terracotta | `#FFF0E7` | `--shortcut-terracotta` | Shortcut circle pastel |
| shortcut-green | `#E3F6E1` | `--shortcut-green` | Shortcut circle pastel |
| shortcut-wine | `#FDE8EF` | `--shortcut-wine` | Shortcut circle pastel |
| shortcut-cyan | `#E1F4FA` | `--shortcut-cyan` | Shortcut circle pastel |
| shortcut-border | `#E9E9E9` | `--shortcut-border` | Shortcut circle border. Neutral grey, not a category tint |
| footer-band | `#1C1C1C` | `--footer-band` | Legal band (implemented separately from `--surface-inverse`) |
| footer-band-text | `#BDBDBD` | `--footer-band-text` | Legal-band supporting copy |

- Verified: `#F27A1A`, `#F5F5F5`, `#E6E6E6`, `#333333`, `#666666`, `#BB0000` were sampled on Trendyol (web `DESIGN.md` §3).
- Do not add Plus pink `#FF4988` as a brand, price, or action token.
- `#B95800` is retired. It is not the button fill, the price, or the active-tab color.
- Keep tokens replaceable: Hamza may change the working primary without rewriting widgets.
- **Light mode only.** The web theme defines a single `:root` palette and has no `prefers-color-scheme` or `.dark` tokens (`app/globals.css`). Do not invent a dark theme.

### Contrast checks (from web `DESIGN.md` §4)
| Foreground / background | Ratio | Rule |
| --- | --- | --- |
| White / `#F27A1A` | 2.77:1 | Fails AA normal and large text. Chosen anyway for filled primary labels |
| `#F27A1A` / white | 2.77:1 | Fails AA. Used for PDP price, active tabs, outline labels, and key icons, always with a second cue (underline, fill, or 2px border). The shelf card amount uses `#C2410C` instead |
| `#C2410C` / white | 5.18:1 | Passes AA normal text. Shelf card current price |
| `#999999` / white | 2.85:1 | Fails AA. Struck compare-at on the card only |
| `#333333` / white | 12.63:1 | Body text |
| `#666666` / `#F5F5F5` | 5.27:1 | Supporting text on subtle surfaces |
| `#FFC000` / white | 1.64:1 | Star fill. The numeric score carries the rating; the star is not the only cue |

Color never carries meaning alone.

## 4. Geometry, borders, shadows, spacing
Source: web `DESIGN.md` §5 and `app/globals.css`.

Spacing scale — use shared tokens, not ad-hoc numbers:

| Token | px | CSS |
| --- | --- | --- |
| space-1 | 4 | `--space-1` |
| space-2 | 8 | `--space-2` |
| space-3 | 12 | `--space-3` |
| space-4 | 16 | `--space-4` |
| space-5 | 20 | `--space-5` |
| space-6 | 24 | `--space-6` |
| space-8 | 32 | `--space-8` |
| space-10 | 40 | `--space-10` |
| space-12 | 48 | `--space-12` |
| space-16 | 64 | `--space-16` |

Radii:

| Token | Value | CSS | Use |
| --- | --- | --- | --- |
| radius-control | 4px | `--radius-control` / `--radius-sm` | Chips, quiet rows, compact actions (40px buttons) |
| radius-card | 8px | `--radius-card` / `--radius-md` | Cards, gallery wells, delivery panels, desktop search, 48px primary buttons |
| radius-frame | 12px | `--radius-frame` / `--radius-lg` | Framed sections |
| radius-search | 20px | `--radius-search` | Mobile search field |
| radius-circle | 999px | `--radius-circle` / `--radius-full` | Circles and pills |

Shadows (Flutter `BoxShadow` equivalents):

| Token | CSS value | Flutter |
| --- | --- | --- |
| none (default card) | none | `elevation: 0`, no shadow |
| shadow-card-hover / `--shadow-card-hover` | `0 2px 8px 0 rgb(0 0 0 / 0.08)` | `offset: Offset(0, 2), blurRadius: 8, spreadRadius: 0, color: Color(0x14000000)` |
| shadow-product-card | `0 2px 8px 2px rgb(0 0 0 / 0.08)` | same with `spreadRadius: 2` |
| elevation-favorite | `0 2px 2px 0 rgb(0 0 0 / 0.2)` | `offset: Offset(0, 2), blurRadius: 2, color: Color(0x33000000)` |
| elevation-overlay | `0 8px 24px rgb(0 0 0 / 0.08)` | `offset: Offset(0, 8), blurRadius: 24, color: Color(0x14000000)` |
| elevation-shelf-arrow | `0 2px 10px color-mix(in srgb, var(--text-primary) 30%, transparent)` | `color: Color(0x4D333333)` (`#333333` at 30%), blur 10, offset (0, 2) |

- Card border: 1px solid `border` (`#E6E6E6`).
- Focus / pressed ring: 2px `primary-strong` outline, 2px offset with a contrasting surface separation. The ring is `#F27A1A` (2.77:1 on white). In Flutter, use a `Focus`/`Ink` outline or a 2px `Border` plus 2px padding — do not rely on Material’s default purple splash.
- Avoid elevated cards inside elevated cards and default heavy Material elevations (`Card` elevation must be 0 unless a documented shadow token is applied).
- Phone gutters: 16px (`space-4`). Major section spacing: 16px on the phone; reserve 32px for a true content change.
- Minimum touch target: 44×44 logical pixels, including Material 3 `visualDensity` adjustments and safe-area padding.

## 5. Arabic typography
- Verified: Cairo, one family, used at 400, 600, and 700. Coverage must include Arabic and Latin.
- Do not add a second text family beside Cairo. Trendyol’s Source Sans 3 is not Doory’s Arabic font.
- Bundle Cairo (variable or the three static weights) or load it through a well-known package such as `google_fonts` **only if** the build still works offline for already-cached fonts and Arabic shaping is preserved. Prefer self-hosted/bundled assets in `fonts/`.
- Fallback: Tahoma, then the platform sans (`sans-serif`).
- Preserve Arabic shaping; do not apply letter-spacing/tracking to connected Arabic text (`letterSpacing: 0` on Arabic styles).
- Pixel sizes below are at a 16px root, matching the web `rem` tokens in `app/globals.css`. Use the same logical-pixel sizes in Flutter `TextStyle.fontSize` / `height` (height = line-height / fontSize).

| Role | Size / line-height | Weight | Token | CSS (`app/globals.css`) |
| --- | --- | --- | --- | --- |
| Wordmark / page title | 24/36 | 700 | text-page | `--type-page-size: 1.5rem` / `--type-page-leading: 2.25rem` (28/40 from 1024px on web; stay on 24/36 in the phone app) |
| Section title | 22/28 | 600 | text-section | `--type-section-size: 1.375rem` / `1.75rem` |
| Home shelf title | 20/24 | 600 | text-shelf | `--type-shelf-size: 1.25rem` / `1.5rem` |
| Hero title | 28/36 | 700 | text-hero-title | `--type-hero-title-size: 1.75rem` / `2.25rem` |
| Body | 16/24, `#333333` | 400 | text-body | `--type-body-size: 1rem` / `1.5rem` |
| Product title (PDP) | 20/26 | 400 | text-product | `--type-product-size: 1.25rem` / `1.625rem` |
| Card title | 14/18, `#333333` | 400; brand 600 | text-card-title | `--type-card-title-size: 0.875rem` / `1.125rem` |
| Price (PDP) | 24/28 | 600 | text-price-size, color `price` | `--type-price-size: 1.5rem` / `1.75rem` |
| Card price | 16/20, `#C2410C` | 600 | text-card-price-size, color `card-price` | `--type-card-price-size: 1rem` / `1.25rem` |
| Compact price | 16/19 | 600 | text-price-compact | `--type-price-compact-size: 1rem` / `1.1875rem` |
| CTA label | 18/24 | 600 | text-cta | `--type-cta-size: 1.125rem` / `1.5rem` |
| Labels / meta | 14/20 | 400/600 | text-label | `--type-label-size: 0.875rem` / `1.25rem` |
| Card meta | 12/16 | 600 | text-card-meta | `--type-card-meta-size: 0.75rem` / `1rem` |
| Shortcut label | see note | 600 | text-shortcut | `--type-shortcut-size: 0.625rem` (10px) on small viewports, `0.875rem` (14px) from 1024px; leading `1.3`. Web `DESIGN.md` §6 lists 14/20. **Implement the CSS token:** 10px / 1.3 on the phone, 14px if a tablet width crosses 1024. |

- Never shrink critical Arabic text to fit a row. Wrap or allow horizontal shelf scroll instead.
- Currency label stays “ل.س”. Numeral style needs confirmation; web shelf social-proof digits stay Latin (`DESIGN.md` §11). Assumption: use Latin digits for prices and counts until confirmed.

## 6. Mobile layout and density
- Verified requirement: mobile-first Arabic RTL.
- Compose for a phone column. Near-full-bleed modules, 16px gutters, 16px gaps between major home sections (not the reference’s 2px rhythm, and not sideways overflow).
- Do not port `--content-max` (1200px), `--header-max` (1800px), or `--home-max` as phone constraints. On a tablet-width window, cap readable product columns rather than stretching a single card across the row (Assumption: max content width 600px on the phone column, 840px on a large tablet).
- Home structure, adapted from web `DESIGN.md` §7:
  1. Compact app bar (wordmark + search entry + cart control)
  2. Maintenance strip when `/meta/status` reports `maintenance_active`
  3. Optional delivery-promise line (live `/home.delivery_promise.message_ar`, otherwise a labelled demo line)
  4. Horizontal category chips or a “تصفّح الفئات” entry
  5. A labeled hero preview (dummy slide copy stays in fixtures)
  6. One horizontally scrolling row of round shortcuts (web desktop uses two rows; the phone keeps one)
  7. Optional brand/seller row
  8. Product shelves (a labelled discount-tier row may sit between earlier shelves)
  9. Campaign mosaic (single column of ~2.4:1 tiles, 8px radius, palette fills, demo label on dummy tiles)
  10. Suggestion pills
  11. Popular-category text links (“الفئات الشائعة”)
  12. A short SEO / about block with neutral fixture copy only
  13. Compact footer (help/policy links that exist; labelled dummy marks only if still needed for layout review)
- A deals tray may use one light orange-to-peach frame (`primary-subtle`). Cards on that tray stay white. Do not use a dark brown wash.
- Live shelves: “مختارات” from `/home.featured`, “وصل حديثًا” from `/home.latest`. Do not title them “مختارة لك” unless personalization exists.
- Keep assortment visible early; no full-screen marketing intro or empty decorative expanses.

## 7. RTL and bidirectional content
- Set `locale: const Locale('ar')`, `supportedLocales` including `ar`, and `textDirection: TextDirection.rtl` (via `MaterialApp` / `Directionality`). `MaterialApp.builder` must not reset direction.
- Use logical start/end APIs: `EdgeInsetsDirectional`, `AlignmentDirectional`, `BorderRadiusDirectional`, `TextAlign.start`, `PositionedDirectional`, `Row` that follows ambient direction.
- Avoid hardcoded `left`/`right` layout assumptions and `EdgeInsets.only(left:/right:)`.
- Carousels (`ListView`, `PageView`) start at the RTL start edge; next proceeds into undiscovered items in RTL order. Set `reverse` only when it is required to make the first item appear at the start in a horizontal list — verify with a real Arabic device/emulator, do not guess.
- Mirror directional chevrons, back/forward, and carousel arrows (`Icon` with `textDirection` or an `AutoMirrored` asset). Do not mirror the wordmark, logos, or product photos.
- Do not mirror nondirectional search, heart, cart, rating, or account symbols blindly.
- Isolate mixed-direction SKUs, phone numbers, Latin brand names, and prices with `unicodeBidi: UnicodeBidi.isolate` / `Bidi.isolate` / a `Text.rich` `WidgetSpan` equivalent (`bdi` on the web). Prices and Latin brand names sit inside an LTR isolate when needed.
- Format currency/numbers from approved locale/API rules; numeral style and currency presentation need confirmation.
- Keep focus / traversal order aligned with visual RTL order.
- Test Arabic wrapping, hyphen-less lines, and mixed-direction product names.

## 8. App chrome, search, and category navigation
Web header rules (web `DESIGN.md` §9) adapted for a phone:

- Compact top bar: orange wordmark “دوري” at the RTL start, then actions. On the web, account / favorites / cart use a 14px/600 label and a 20px icon. On the phone, icon-only actions need a 44×44 hit target and an accessible name. Favorites stay omitted or unavailable until approved. Account and cart stay **unavailable controls** (visible, announced “غير متاح بعد”) until those features have contracts.
- Search: 44px high, surface `#F5F5F5`, 20px radius, orange magnifier at the inline end. Placeholder: “ابحث عن منتج أو فئة”. Use a real labelled `TextField` / search route, not a fake box. Doory deliberately uses a 44px phone search rather than copying Trendyol’s 36px field.
- Category access: a horizontally scrolling chip row and/or a “تصفّح الفئات” screen (tree from `GET /categories`). Do not build a desktop mega menu on a phone.
- Active category: `#F27A1A` text and a 2px `#F27A1A` underline (or equivalent non-color cue).
- A small orange “جديد” pill, if shown, uses `card-price` so a 12px white label stays readable. It is demo chrome on the web, not a live drop, unless the API supplies that meaning.
- The top bar may stay pinned. Do not collapse a bar that currently holds focus. Respect the system status bar and notch (`SafeArea` / `MediaQuery.padding`).
- Utility / delivery line: show `/home.delivery_promise.message_ar` when present. Otherwise a labelled demo line is allowed. Never invent a delivery promise.

## 9. Round shortcuts and product carousels
- Shortcut circles: 68px, tinted pastel fill, `--shortcut-border` ring, label below, max two lines, weight 600.
- The phone keeps **one** horizontally scrolling row. Item width about 88px; labels must remain readable.
- Use `primary-strong` for a meaningful pressed/focused ring; never replace keyboard/D-pad focus with hover-only styling.
- Product shelves: target about 1.75 cards with a peek. Minimum card width 160px on phones; show fewer cards rather than shrinking Arabic.
- Gaps: 12px on the phone. Scroll/snap inside the shelf, not the page.
- Peek arrows are optional on a touch device when swipe is available, but swipe must not be the only method if a hardware keyboard or switch device is in use; provide a next/previous control with Arabic labels when arrows are shown. Hit area ≥ 44px.
- No auto-advancing product shelves by default. Honor `MediaQuery.disableAnimations` / `prefers-reduced-motion`.

## 10. Product card and section header
Follow web `DESIGN.md` §11 and the implemented card in `components/home/product-card/`:

- Card: white, 1px `border`, 8px radius, no default shadow. The whole card is one destination to the product route. Heart and basket controls sit outside that gesture if present.
- Image well: 2:3, flush with the card top, inner radius matching the card. Real photography uses `BoxFit.contain` on a white canvas. Missing photos use a quiet placeholder, never a fake product shot.
- Heart (if shown): 32px white circle, soft `elevation-favorite` shadow, 20px outline heart, top inline-end, 44px hit area. Demo: local non-persisting toggle labelled “أضف إلى المفضلة”. Live cards: unavailable behavior (“غير متاح بعد”), not a favorites feature.
- Stamps, strips, social proof, ratings, compare-at, and promo lines are **optional and data-driven**. Collapse when absent. Never invent them. Demo-only stamps/strips must carry “بيانات تجريبية” or live only in clearly labelled demo fixtures.
- Title: 14/18, `#333333`. Brand first at 600 inside an LTR/bidi isolate, then the name at 400. Clamp to two lines; keep the full name in the semantic label. Omit a missing brand.
- Price: 16/20 at 600 in `card-price` (`#C2410C`). Genuine compare-at may show a primary discount chip (“%20-”, white 12px/600, 4px radius, LTR isolate) and a struck old amount at 12px/600 in `text-muted`. Currency label “ل.س”. Never show a Plus-pink amount as a brand price.
- `price.amount == null` hides the price and must not be coerced to zero. `priceIsEstimate` shows “سعر تقريبي”. `available == false` shows “نفدت الكمية”. Do not infer sold-out from an API/network error.
- Section header: shelf title at RTL start (`text-shelf`, 20/24, 600, `#333333`), “عرض الكل” as a 16px pill (8px 12px padding, 20px radius) at the inline end when a real listing route exists. Without a route, use the unavailable-button pattern; do not drop the control silently.

## 11. Buttons, cart count, footer, and bottom navigation
- Primary filled button: `#F27A1A` fill, white label, height 48px, radius 8px, label 18/600. Pressed fill `#D56B17`.
- Primary outline button: 2px solid `#F27A1A` border and label, height 48px, radius 8px, label 18/600.
- Compact and sticky actions: height 40px, radius 4px, label 16/600.
- Secondary: white with `border-control` and dark label; text action uses `primary-strong`.
- Icon-only action: 44×44 hit target with an accessible name. Tooltips are not its only label.
- Cart count: derived from actual cart state only; hide a zero badge if the cart label already conveys empty. Until cart exists, do not draw a fake count.
- Footer: only real company/help/policy links. Omit business-policy claims. Preview payment marks, certificates, social icons, and app badges may appear only as labelled dummy images — they are not Doory integrations.
- **Mobile bottom nav is not approved.** Web `DESIGN.md` §12: “Mobile bottom nav is not part of the Doory layout; no fixed shopping bottom nav was observed in the study. Add one only with approval and real destinations, safe-area padding, and labels.”
- Assumption proposal (do not implement as policy): a four-tab bar — الرئيسية, الفئات, السلة, حسابي — with safe-area padding, 44px targets, `primary-strong` selected icon plus label, and the cart/account tabs using the unavailable pattern until those destinations exist. Confirm with Hamza before shipping. MVP can ship with app-bar navigation + category screen + search route only.

## 12. States
- Pressed: light shadow or stronger actionable text; no jumping geometry or large scale effects.
- Focus-visible: 2px `#F27A1A` outline, 2px offset; never remove focus indication.
- Active/selected: `#F27A1A` text and a 2px `#F27A1A` underline, or the brand fill with white text. Include a non-color cue.
- Disabled: true disabled behavior, no fake affordance; explain why when the user needs that information. Unavailable features use a control plus a screen-reader “غير متاح بعد” note.
- Loading: reserved-size skeleton matching the actual widget; `Semantics(liveRegion)` / busy state where appropriate; no fake data.
- Empty: accurate reason and useful next action; distinguish empty cart, no results, and unavailable catalog.
- Error: plain MSA explanation, accessible announcement, retry when safe, preserved entered/cart state.
- Unavailable item: actual stock/service evidence; never infer it from an API/network error.
- Validation: associate messages with fields; retain values and focus the first relevant error.
- Demo: visible “بيانات تجريبية” label; fixtures isolated from API adapters and presentation widgets.
- Maintenance: a thin full-width strip, `primary-subtle` background, `border-primary-strong` at 20% opacity, centered `text-label` 600 `text-primary`, using `maintenance.message.ar` from `GET /meta/status` when `maintenance_active` is true. If that request fails, **omit** the strip — do not invent maintenance.
- Reduced motion: `MediaQuery.disableAnimationsOf(context)` removes auto movement, decorative animation, and smooth scrolling; keep state changes clear. No social-proof rotation or animated promotion GIFs by default.

## 13. Iconography
- Simple outline icons at 20px in chrome, 14px stars, 12px meta icons, consistent stroke.
- Filled star uses `rating` (`#FFC000`); empty star track uses `border` (`#E6E6E6`), not a second rating token.
- Meaningful brand-orange icons use `primary-strong`.
- Do not use color, position, or icon alone to convey state.

## 14. Motion, imagery, and accessibility
- Prefer opacity/transform; avoid layout thrash; do not introduce an animation dependency for trivial feedback.
- Real product photography first; consistent framing, adequate resolution, and meaningful semantic labels (`Semantics` / `alt` equivalent).
- Campaign images need truthful content and accessible text equivalents; do not bake essential information only into images.
- Support TalkBack, VoiceOver, keyboard/D-pad, and switch access. Visible focus, sensible traversal order, zoom/text scaling, no traps.
- Never rely on color, position, or hover alone. Test Arabic wrapping and mixed-direction content.
- Follow the project’s approved verification workflow; these docs do not authorize new tests, servers, or tooling.

## 15. Don’ts and confirmation checklist
- No generic startup hero, calm/spare redesign, luxury editorial spacing, or unrequested visual rebrand.
- No invented deals, ratings, coupons, banners, favorites, counts, policy badges, or delivery promises.
- No scattered hardcoded brand colors, unreadable orange labels, excessive Material elevations, or pills everywhere.
- No page-level horizontal overflow, tiny Arabic metadata, or cropped product names as the only accessible label.
- No copying Trendyol’s seasonal 11.11 artwork, logos, exhaustive campaign tail, or unverified behaviors.
- No dark mode until tokens exist.
- Confirm: exact brand/tint/neutral tokens (already confirmed on web, 13 November 2026); Arabic type scale on device; card widths.
- Confirm: shortcut size; search/sticky behavior; cart-count convention; numeral/currency formatting; bottom-nav choice.
- Keep all `PRODUCT.md` business-policy questions open; do not invent answers. Design and implement to the standard of a production e-commerce app.

## 16. Flutter ThemeData mapping

Put tokens in `lib/core/theme/`. Widgets read `DooryColors`, `DooryTypography`, `DooryRadii`, `DoorySpacing`, and `DooryShadows` — never a raw `Color(0xFFF27A1A)` in a feature widget.

```dart
// lib/core/theme/colors.dart
import 'package:flutter/material.dart';

abstract final class DooryColors {
  static const primary = Color(0xFFF27A1A);
  static const primaryStrong = Color(0xFFF27A1A);
  static const primaryHover = Color(0xFFD56B17);
  static const primarySubtle = Color(0xFFFFF3E8);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceSubtle = Color(0xFFF5F5F5);
  static const surfaceInverse = Color(0xFF333333);
  static const textPrimary = Color(0xFF333333);
  static const textSecondary = Color(0xFF666666);
  static const textOnStrong = Color(0xFFFFFFFF);
  static const border = Color(0xFFE6E6E6);
  static const borderControl = Color(0xFF858585);
  static const price = Color(0xFFF27A1A);
  static const cardPrice = Color(0xFFC2410C);
  static const textMuted = Color(0xFF999999);
  static const discount = Color(0xFFBB0000);
  static const success = Color(0xFF137333);
  static const danger = Color(0xFFBB0000);
  static const rating = Color(0xFFFFC000);
  static const previewPlus = Color(0xFFFF4988); // fixture only
  static const categoryTileTeal = Color(0xFF2B6E77);
  static const categoryTileRose = Color(0xFF9A404A);
  static const categoryTileTerracotta = Color(0xFF9A4C3D);
  static const categoryTileGreen = Color(0xFF407C3D);
  static const categoryTileWine = Color(0xFF982F49);
  static const categoryTileCyan = Color(0xFF1F7B8E);
  static const categoryTileViolet = Color(0xFF4A3D78);
  static const shortcutTeal = Color(0xFFDFF5F4);
  static const shortcutRose = Color(0xFFFDECEF);
  static const shortcutTerracotta = Color(0xFFFFF0E7);
  static const shortcutGreen = Color(0xFFE3F6E1);
  static const shortcutWine = Color(0xFFFDE8EF);
  static const shortcutCyan = Color(0xFFE1F4FA);
  static const shortcutBorder = Color(0xFFE9E9E9);
  static const footerBand = Color(0xFF1C1C1C);
  static const footerBandText = Color(0xFFBDBDBD);
}
```

`ColorScheme` (Material 3, **light only**). Several Material slots are approximate; prefer `DooryColors` in Doory widgets when a slot would collide (for example card price vs brand orange).

```dart
const dooryColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: DooryColors.primaryStrong,          // #F27A1A
  onPrimary: DooryColors.textOnStrong,         // #FFFFFF
  primaryContainer: DooryColors.primarySubtle, // #FFF3E8
  onPrimaryContainer: DooryColors.primaryHover,
  secondary: DooryColors.surfaceInverse,       // #333333
  onSecondary: DooryColors.textOnStrong,
  secondaryContainer: DooryColors.surfaceSubtle,
  onSecondaryContainer: DooryColors.textPrimary,
  tertiary: DooryColors.categoryTileTeal,
  onTertiary: DooryColors.textOnStrong,
  error: DooryColors.danger,                   // #BB0000
  onError: DooryColors.textOnStrong,
  surface: DooryColors.surface,                // #FFFFFF
  onSurface: DooryColors.textPrimary,          // #333333
  onSurfaceVariant: DooryColors.textSecondary, // #666666
  outline: DooryColors.border,                 // #E6E6E6
  outlineVariant: DooryColors.borderControl,   // #858585
  shadow: Color(0x14000000),
  scrim: Color(0x66000000),
  inverseSurface: DooryColors.footerBand,      // #1C1C1C (implemented legal band)
  onInverseSurface: DooryColors.footerBandText,
  inversePrimary: DooryColors.primarySubtle,
);
```

`TextTheme` / `DooryTypography` (Cairo, sizes in logical pixels, `height` = line / size, `letterSpacing: 0`):

```dart
TextStyle _cairo({
  required double size,
  required double line,
  required FontWeight weight,
  Color color = DooryColors.textPrimary,
}) {
  return TextStyle(
    fontFamily: 'Cairo',
    fontSize: size,
    height: line / size,
    fontWeight: weight,
    color: color,
    letterSpacing: 0,
  );
}

abstract final class DooryTypography {
  static final page = _cairo(size: 24, line: 36, weight: FontWeight.w700);
  static final section = _cairo(size: 22, line: 28, weight: FontWeight.w600);
  static final shelf = _cairo(size: 20, line: 24, weight: FontWeight.w600);
  static final heroTitle = _cairo(size: 28, line: 36, weight: FontWeight.w700);
  static final body = _cairo(size: 16, line: 24, weight: FontWeight.w400);
  static final product = _cairo(size: 20, line: 26, weight: FontWeight.w400);
  static final cardTitle = _cairo(size: 14, line: 18, weight: FontWeight.w400);
  static final cardTitleBrand = _cairo(size: 14, line: 18, weight: FontWeight.w600);
  static final price = _cairo(size: 24, line: 28, weight: FontWeight.w600, color: DooryColors.price);
  static final cardPrice = _cairo(size: 16, line: 20, weight: FontWeight.w600, color: DooryColors.cardPrice);
  static final priceCompact = _cairo(size: 16, line: 19, weight: FontWeight.w600, color: DooryColors.price);
  static final cta = _cairo(size: 18, line: 24, weight: FontWeight.w600, color: DooryColors.textOnStrong);
  static final label = _cairo(size: 14, line: 20, weight: FontWeight.w400);
  static final labelStrong = _cairo(size: 14, line: 20, weight: FontWeight.w600);
  static final cardMeta = _cairo(size: 12, line: 16, weight: FontWeight.w600);
  static final shortcut = _cairo(size: 10, line: 13, weight: FontWeight.w600); // CSS 0.625rem, leading 1.3
}
```

Map into `TextTheme` approximately as: `displaySmall` ← heroTitle, `headlineMedium` ← page, `headlineSmall` ← section, `titleLarge` ← shelf / product, `titleMedium` ← cta, `titleSmall` ← cardTitle, `bodyLarge` / `bodyMedium` ← body, `bodySmall` ← label, `labelLarge` ← labelStrong, `labelSmall` ← cardMeta. Prefer named `DooryTypography` styles in storefront widgets so prices and shelf titles do not drift.

`ThemeData` sketch:

```dart
ThemeData dooryTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: dooryColorScheme,
    fontFamily: 'Cairo',
    scaffoldBackgroundColor: DooryColors.surface,
    canvasColor: DooryColors.surface,
    dividerColor: DooryColors.border,
    textTheme: /* map DooryTypography */,
    appBarTheme: const AppBarTheme(
      backgroundColor: DooryColors.surface,
      foregroundColor: DooryColors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    cardTheme: CardThemeData(
      color: DooryColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: DooryColors.border, width: 1),
      ),
      margin: EdgeInsets.zero,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: DooryColors.surfaceSubtle,
      hintStyle: DooryTypography.label.copyWith(color: DooryColors.textSecondary),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20), // mobile search
        borderSide: BorderSide.none,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: DooryColors.primaryStrong,
        foregroundColor: DooryColors.textOnStrong,
        disabledBackgroundColor: DooryColors.border,
        minimumSize: const Size(44, 48),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: DooryTypography.cta,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: DooryColors.primaryStrong,
        minimumSize: const Size(44, 48),
        side: const BorderSide(color: DooryColors.primaryStrong, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: DooryTypography.cta.copyWith(color: DooryColors.primaryStrong),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        minimumSize: const Size(44, 44),
        foregroundColor: DooryColors.textPrimary,
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: DooryColors.primaryStrong,
    ),
    splashFactory: InkRipple.splashFactory,
    splashColor: DooryColors.primarySubtle,
    highlightColor: DooryColors.primarySubtle,
    focusColor: DooryColors.primarySubtle,
    // Do not set a darkTheme / themeMode until tokens exist.
  );
}
```

Primary button pressed color `#D56B17` should be applied with a custom `ButtonStyle.overlayColor` / `WidgetStateProperty` — Material will not infer that mix on its own.

`MaterialApp` must set:

```dart
MaterialApp(
  title: 'دوري',
  locale: const Locale('ar'),
  supportedLocales: const [Locale('ar')],
  localizationsDelegates: const [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  theme: dooryTheme(),
  builder: (context, child) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: child ?? const SizedBox.shrink(),
    );
  },
);
```

## 17. Flutter architecture

### Folder structure (target)

```
lib/
  main.dart
  app/
    app.dart                 # MaterialApp, theme, locale, router
    router.dart              # GoRouter (or equivalent) route table
  core/
    theme/                   # colors, typography, radii, spacing, shadows, theme.dart
    api/
      client.dart            # GET helper, base URL, timeout, headers
      errors.dart            # ApiError kinds (mirror web lib/api/errors.ts)
      endpoints.dart         # path constants
      types/                 # Buyer* models (mirror web lib/api/types.ts)
      mappers/               # card / detail / category-tree adapters
    widgets/                 # demo label, maintenance strip, skeletons, shared buttons
  data/
    demo/                    # labelled fixtures only — never imported by visual widgets directly
    repositories/            # home, catalog, search, product, meta
  features/
    home/
    categories/
    listing/
    search/
    product/
    store/                   # phase 4
    cart/                    # later, approved contract only
    account/                 # later, approved contract only
assets/
  fonts/Cairo-*.ttf
  images/                    # wordmark, placeholders — no fake product photos in production assets
```

Mirror the web rule: fixtures stay out of presentation widgets and out of the HTTP client. Repositories return a small result type such as `ok` / `unavailable` / `rejected` / `notFound`, the same way `readProducts` and `loadProductPage` do on the web (`lib/api/products.ts`, `lib/product/load-product.ts`).

### State management and HTTP (recommendation)

- **HTTP:** `dio` (or `http`) wrapped by a single `ApiClient`. Default timeout 4000 ms (`DOORY_API_TIMEOUT_MS`). Headers: `Accept: application/json`, `Accept-Language: ar`. No `Authorization` until a contract exists. Missing `DOORY_API_BASE_URL` throws a `network` error. Do not cache a failure as a successful empty catalog.
- **State:** Riverpod (`Provider` / `Notifier` / `AsyncNotifier`) is the recommended default: repositories stay injectable, widgets stay dumb, and it maps cleanly to the web’s loader functions. `flutter_bloc` is an acceptable alternative if the team already standardizes on it. Do not put HTTP calls inside `StatefulWidget` build methods, and do not pick a store merely to enforce these docs.
- **Images:** cache safely (`cached_network_image` or equivalent), `BoxFit.contain` on a white well, meaningful semantic labels, no invented photography.
- **Routing:** `go_router` (or the Navigator 2 API) with routes that parallel the web paths, without inventing slugs:

| Web path (`lib/links.ts`) | Mobile route (proposal) |
| --- | --- |
| `/` | `/` Home |
| `/search?q=` | `/search?q=` Search |
| `/ar/c/{slug}` | `/c/:slug` Category listing |
| `/ar/p/{id}` or `/ar/p/{id}-{slug}` | `/p/:ref` Product detail (`ref` is the leading numeric id, same as `parseProductRefId`) |
| `/ar/s/{slug}` (phase 4 on web) | `/s/:slug` Store (phase 4) |

The backend owns transliteration of slugs. Never invent product or store slugs.

### Screens for MVP (phases 0–3)

1. Home
2. Category tree / “تصفّح الفئات”
3. Category listing (sort, price filters, child tiles, pager or paging)
4. Search (empty state, no-results, results, degraded search notice)
5. Product detail (gallery, price, variants, seller, details, reviews only when genuine, similar rail)
6. Maintenance strip (chrome, not a full-screen blocker unless `maintenance_active` later requires it — today the web only shows a strip)
7. Not-found and “صفحة المنتج غير متاحة بعد” (unmapped live id when the API is down and no matching fixture exists)

Placeholders, not MVP features: cart, checkout, account, favorites, store profile. If chrome shows them, use the unavailable pattern.

### Error / fallback / demo rules (must match the web)

From `lib/api/errors.ts`, `lib/home/load-home.ts`, `lib/product/load-product.ts`, `lib/listing/load-category-listing.ts`, `lib/listing/load-search-listing.ts`:

- `isApiUnavailable` = network, HTTP 5xx, or missing base URL (or a non-`ApiError` throw).
- Only then may a repository return labelled demo fixtures — and only the fixture that matches the requested id/slug/query, always with “بيانات تجريبية”.
- `rejected` (live 422 and other live client errors) keeps an empty live shell; do not swap in demo products.
- Live product `not_found` is a not-found screen, never an unrelated demo PDP.
- Empty search `q` must not call `GET /search` (the API returns 422).
- An inverted price range must not be sent (it is a 422); keep the live shell.
- Do not convert “API unavailable” into “نفدت الكمية” or an empty catalog presented as real.
- Optional API fields that are missing are omitted in the UI.

## 18. Phased plan

Implement in the same order as the web branches `cursor/phase-0-api-foundation-876e`, `cursor/phase-1-home-categories-43d4`, `cursor/phase-2-live-product-page-8ef2`, and `cursor/phase-3-listing-search-e983`. Phase 4 follows the web comment on `storeHref` in `lib/links.ts`. Later phases wait on approved contracts. Details are in `design-plans/`.
