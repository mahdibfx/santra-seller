# Santra Partner App API

> 📘 **See also: [FULL-REFERENCE.md](FULL-REFERENCE.md)** — the same API with
> request-parameter tables and real response examples captured from staging.
> That document is the one to hand to the app developer.

This is the API reference for the **partner mobile app** (restaurants/shops managing
their own orders, products, add-ons, and invoices from their phone).

**Base URL (staging):** `https://api-staging.santra.ae/api/v1/partner`

All responses are JSON. Paginated list endpoints return:
```json
{ "data": [...], "meta": { "page": 1, "limit": 20, "total": 137, "totalPages": 7 } }
```
Errors return:
```json
{ "error": { "code": "SOME_CODE", "message": "Human readable message" } }
```

---

## Staging environment notes (read first)

- **No SMS provider configured on staging** — `POST /auth/otp/request` returns the
  OTP code directly in the response as `debugCode`. Use it to log in without a real
  phone carrier. This field disappears automatically once production SMS is wired up.
- **Test data**: staging carries the full migrated catalog (partners, products,
  categories, modifiers) but **no historical orders**. Place fresh test orders
  through the customer app to have something to manage here.
- Partner accounts are **never self-registered** from the app — an account must
  already exist (created by Santra admin, or migrated) before OTP login works.
  Disabled partner accounts are rejected before an OTP is even sent.

---

## Auth — phone + OTP

Unlike the customer app, a partner phone number must already be attached to an
existing partner account. There is no self-ACTIVATION flow — but the app can
submit a registration REQUEST (below) that puts the business into Santra's
onboarding pipeline for the sales team to follow up.

### `POST /auth/register-request` (PUBLIC — no auth) — NEW 2026-07-18
"Become a partner" form in the app. Creates an onboarding lead; the business
CANNOT log in until Santra's team contacts them and approves the account.
```json
{
  "businessName": "Mimi Bakery",          // required, 2-200 chars
  "businessNameAr": "مخبز ميمي",           // optional
  "contactName": "Sara Ahmed",             // optional
  "countryCode": "+971",                   // optional, default +971
  "phone": "501234567",                    // required, digits only 5-14
  "email": "owner@mimibakery.com",         // required, valid email
  "cityId": 1                              // optional (default Dubai) — see GET /cities below
}
```
→ `200 { "data": { "received": true } }`

The response is ALWAYS the same 200, including when the phone/email already
belongs to a partner (deliberate — the endpoint never reveals whether a
number is registered). Show the user "Thanks — our team will contact you."
Errors: `400` validation (bad phone/email format), `429` rate-limited.

### `GET /cities` and `GET /areas?cityId=1` (PUBLIC — no auth) — NEW 2026-07-20
Geography lookup for the city picker on the form above (and any address
screen). Identical payload to the customer app:
```json
{ "data": [ { "id": 1, "name_en": "Dubai", "name_ar": "دبي" } ] }
{ "data": [ { "id": 26, "city_id": 1, "name_en": "Abu Hail", "name_ar": "…", "is_scheduled_only": 0 } ] }
```
`cityId` is optional on `/areas` (omit to get every area in one call).
Unknown city → `404`, non-numeric → `400`. Note: area `name_ar` still holds
English text until the translation pass lands — no app change needed then.

### `POST /auth/otp/request`
```json
{ "countryCode": "+971", "phone": "501234567", "deviceInfo": "iPhone 14" }
```
→ `200 { "message": "OTP sent", "expiresInSeconds": 300, "debugCode": "123456" }`

Errors: `404` no partner account for this phone, `403` account disabled,
`429` cooldown/rate-limited.

### `POST /auth/otp/verify`
```json
{ "countryCode": "+971", "phone": "501234567", "code": "123456", "deviceInfo": "iPhone 14" }
```
→ `200`:
```json
{
  "accessToken": "...", "refreshToken": "...", "expiresIn": 900,
  "partner": { "id": 42, "nameEn": "...", "nameAr": "...", "phone": "...", "countryCode": "+971", "email": "..." }
}
```
Send `accessToken` as `Authorization: Bearer <token>` on every request below.
It expires in 15 minutes.

### `POST /auth/refresh`
```json
{ "refreshToken": "...", "deviceInfo": "iPhone 14" }
```
→ new `{ accessToken, refreshToken, expiresIn }`. **Refresh tokens rotate** — the
old one is invalidated the moment you use it. Always persist the newly returned
pair, never reuse an old refresh token (it will be rejected — `401`, code
`TOKEN_REUSE_DETECTED` — if reused, e.g. after a race between two requests).

### `POST /auth/logout`
```json
{ "refreshToken": "..." }
```
→ `200 { "message": "Logged out" }`. Revokes that one refresh token.

---

## Profile

### `GET /me`
The partner's own profile (name, contact, delivery settings, rating, language).

### `PATCH /me`
```json
{ "email": "new@mail.com", "ownerName": "...", "preferredLanguage": "ar", "descriptionEn": "...", "descriptionAr": "..." }
```
All fields optional (send only what changed). Brand/identity fields (name,
logo, phone, category) and commercial terms are admin-managed — contact
Santra to change those. `409 EMAIL_TAKEN` if the email is in use.

---

## Dashboard (home screen)

### `GET /dashboard`
One call returning everything the home screen shows:
```json
{
  "data": {
    "actionNeeded": { "pendingOrders": 2 },
    "today":   { "revenue": 450.5, "orders": 7, "byStatus": { "pending": 2, "preparing": 3, "delivered": 2 } },
    "month":   { "revenue": 8210.0, "orders": 122 },
    "products": { "online": 27, "outOfStock": 1, "pendingReview": 2 },
    "rating": 4.6, "reviewCount": 213
  }
}
```
`actionNeeded.pendingOrders` counts ALL pending orders (not just today's) —
it's the "new orders waiting for you" badge.

---

## Products

A partner manages their own product catalog. New products/edits go to
`pending_review` for Santra admin approval before going live — check `approvalStatus`
in the response.

### `GET /products?page=1&limit=20&search=&approvalStatus=&availabilityStatus=`
- `approvalStatus`: `draft` | `pending_review` | `approved` | `rejected`
- `availabilityStatus`: `online` | `offline` | `out_of_stock`

### `GET /products/:id`
`404` if the product doesn't belong to your partner account.

### `POST /products`
```json
{
  "categoryId": 5,
  "nameEn": "Chocolate Cake", "nameAr": "...",
  "descriptionEn": "...", "descriptionAr": "...",
  "price": 85.00, "compareAtPrice": 100.00,
  "quantityLabel": "1 kg", "calories": 350, "prepTimeMinutes": 30,
  "ingredientsEn": "...", "ingredientsAr": "...",
  "isVegan": false, "allergenInfo": "Contains nuts",
  "isExpress": false, "isVip": false, "isPickup": true, "isGiftEligible": true
}
```
`categoryId` is the **catalog category** (Cakes/Flowers/Drinks — the taxonomy
customers browse), not your partner business type. → `201`, new product with
`approvalStatus: "pending_review"`.

### `PATCH /products/:id/availability`
```json
{ "status": "out_of_stock" }
```
`status`: `online` | `offline` | `out_of_stock`. The partner's own lever —
takes effect immediately, **no re-approval needed**. `out_of_stock` products
stay visible to customers but greyed out/not orderable; `offline` hides them
completely.

No PATCH/edit or delete endpoint yet — deferred until there's a real need
(current flow: create new, or ask admin to edit).

---

## Orders

A partner only ever sees their own orders, and only fields relevant to fulfilling
them — customer contact details are masked (see below).

### `GET /orders?page=1&limit=20&search=&status=&dateFrom=&dateTo=`
- `status`: `pending` | `confirmed` | `preparing` | `ready` | `out_for_delivery` |
  `delivered` | `cancelled` | `failed`
- `dateFrom`/`dateTo`: `YYYY-MM-DD`

### `GET /orders/:id`
Returns the order plus `items` (line items with modifiers/add-ons).

**Customer privacy**: the customer's phone/name are masked in what you see
(e.g. partial phone, first name only) — full contact details aren't needed to
fulfil an order and aren't exposed to partners.

### `PATCH /orders/:id/status`
```json
{ "status": "confirmed", "note": "optional note" }
```
A partner can only move an order through the stages they control:
`confirmed`, `preparing`, `ready`, or `cancelled`. Handoff to delivery
(`out_for_delivery`/`delivered`) and `failed` are operations/system-driven and
are **not** available here — you'll get `409 INVALID_STATUS_TRANSITION` if you
try, with the message listing what transitions actually are allowed from the
order's current status.

---

## Manual orders (phone/WhatsApp orders)

The partner enters an order taken by phone/WhatsApp and either collects cash
on delivery or sends the customer a Geidea payment link. Business rules:
**no Santra commission** and **no service fee** on manual orders (the partner
brought the customer); **Santra always delivers** (area-based fee).

### `GET /orders/delivery-quote?areaId=12`
→ `{ "data": { "deliveryFee": 5, "cityId": 1 } }` — quote before placing.
(This is the base fee for the area. Free-delivery offers are promotions
managed by Santra and don't apply to manual orders.)

### `POST /orders/manual`
```json
{
  "partnerCustomerId": 7,
  "items": [
    { "productId": 379, "quantity": 2 },
    { "productId": 381, "quantity": 1, "note": "extra lemon" }
  ],
  "discountAmount": 5,
  "paymentMethod": "payment_link",
  "gatewayFeeBorneBy": "partner",
  "deliveryInstructions": "...", "orderNotes": "..."
}
```
- **Customer**: either `partnerCustomerId` (a saved contact, see Customer book
  below) or an inline `customer` object (`{ name, phone, areaId, addressLine,
  building, unit, countryCode? }`) — inline contacts are auto-saved to the book.
  An `areaId` must be available (saved on the contact or passed top-level).
- **Prices are server-side** — items are priced from the partner's live
  products; the app never sends prices. Only `approved`, non-`offline`
  products belonging to this partner are accepted.
- `discountAmount`: optional flat AED discount, partner-funded, capped at the subtotal.
- `paymentMethod`: `cash` | `payment_link`.
- `gatewayFeeBorneBy` (payment_link only): `partner` (default — fee is settled
  like normal card orders) or `customer` (the gateway fee is added on top of
  the total and paid by the paying customer).

→ `201` with the full order. For `payment_link`, also:
```json
{ "paymentLink": "https://payments.geidea.ae/hpp/checkout/?id=...", "linkError": null }
```
Share `paymentLink` with the customer (WhatsApp/SMS) — it opens Geidea's
hosted payment page; when they pay, the webhook marks the order paid
automatically. If `paymentLink` is null and `linkError` is set, the order WAS
created but the gateway session failed — retry with the endpoint below
rather than re-entering the order.

Manual orders start at `confirmed` (no accept step — entering it is accepting
it) and are **never masked**: the partner sees the full contact/address they
typed themselves.

### `POST /orders/:id/payment-link`
Fresh payment link for an unpaid `payment_link` order (sessions expire).
`400 NOT_LINK_ORDER` for non-link orders, `409 ALREADY_PAID` if already paid.

---

## Customer book

The partner's own saved contacts for manual orders. Completely private to
this partner — never shared across partners or with Santra marketing.

### `GET /customers?page=&limit=&search=` — search matches name or phone
### `GET /customers/:id`
### `POST /customers`
```json
{ "name": "Om Ahmad", "phone": "5599...", "countryCode": "+971",
  "cityId": 1, "areaId": 12, "addressLine": "Villa 12, Street 4",
  "building": "", "unit": "", "notes": "regular Friday order" }
```
`409 PHONE_EXISTS` if the phone is already in this partner's book.
### `PUT /customers/:id` — same fields, all optional (send what changed)
### `DELETE /customers/:id` → `204`

---

## Reviews

### `GET /reviews?page=&limit=`
Reviews customers left on this partner's store (rating, comment, date,
customer **first name only** — same privacy rule as everywhere else).

---

## Notifications

### `GET /notifications?page=&limit=` — newest first, `is_read` flag on each
### `GET /notifications/unread-count` → `{ "data": { "count": 3 } }`
### `PATCH /notifications/:id/read` → `204`
### `POST /notifications/read-all` → `204`

---

## App shell / content (PUBLIC — no auth, usable from the splash screen)

### `GET /content/about`
Contact info (whatsapp_number, call_number, support_email, website_url, office_address).

### `GET /content/legal`
`{ privacy_policy_url, terms_conditions_url, seller_contract_url }` — render
in a webview. (Values are admin-configured; may be null until set.)

### `GET /content/app-version?platform=ios|android`
```json
{ "data": { "platform": "ios", "minVersion": "2.0.0", "latestVersion": "2.1.0", "storeUrl": "https://..." } }
```
Compare the running app version: below `minVersion` → force-update screen;
below `latestVersion` → soft "update available" prompt. Nulls = no gate set.

---

## Add-ons (gift wrapping, candles, ribbons, notes, etc.)

Partners can offer optional add-ons customers attach to an order (e.g. "add a
candle for AED 5"). New add-ons need Santra admin approval before they're live —
check `approvalStatus`.

### `GET /addons?page=1&limit=20&approvalStatus=`
`approvalStatus`: `pending_review` | `approved` | `rejected`

### `GET /addons/:id`

### `POST /addons`
```json
{
  "nameEn": "Birthday Candle", "nameAr": "...",
  "type": "candle",
  "imageUrl": "https://...",
  "price": 5.00,
  "appliesTo": "all_products",
  "productIds": []
}
```
`type` must be one of: `gift_card`, `candle`, `ribbon`, `note_card`, `packaging`, `other`.
If `appliesTo` is `selected_products`, `productIds` is required (must be non-empty).
→ `201`, `approvalStatus: "pending_review"`.

### `PUT /addons/:id`
Same body shape as create. **Editing an approved add-on resets it to
`pending_review`** — it goes live again only after admin re-approves.

### `PATCH /addons/:id/activate` / `PATCH /addons/:id/deactivate`
Turn an already-approved add-on on/off without editing it (no re-review needed).
→ `204` no body.

---

## Invoices (settlement with Santra)

Santra generates a settlement invoice periodically (commission owed, delivery
fees, VAT, any refund adjustments). Partners can view invoices and, if an
invoice shows the partner owes Santra money, declare that they've made the
transfer.

### `GET /invoices?page=1&limit=20`
Only invoices past the internal draft/verification/finance-review stages are
visible here — you won't see an invoice while Santra finance is still
preparing/checking it.

### `GET /invoices/:id`
Returns the invoice header plus `lineItems` (per-order breakdown), `adjustments`
(refunds, corrections), and `payments` (declared/verified transfers).

Key fields on the invoice header:
- `settlementAmount` — **positive** means Santra owes the partner, **negative**
  means the partner owes Santra.
- `status` — `approved` | `payment_review` | `paid` | `overdue`.

### `POST /invoices/:id/payments`
Only usable when `settlementAmount` is negative (you owe Santra) — otherwise
`400 NOTHING_OWED`.
```json
{
  "amount": 450.00,
  "method": "bank_transfer",
  "bankReference": "TRX123456",
  "receiptUrl": "https://...",
  "valueDate": "2026-07-10",
  "note": "Paid via Wio transfer"
}
```
`method`: `bank_transfer` | `payment_link` | `cash_deposit` | `other`.
→ `201`, the created payment record (`status: "pending_verification"` until
Santra finance confirms receipt on their side).

---

## What's shared with the partner web portal

Everything above is identical business logic to the partner web portal
(`portal.santra.ae`, used on desktop) — same database, same rules, same
approval workflows. The only difference is how you log in: the portal uses
email+password, the app uses phone+OTP. A partner can use both interchangeably;
actions taken in one show up immediately in the other.

## Legacy → new endpoint mapping (old seller app)

| Legacy endpoint | New equivalent |
|---|---|
| login / request_tmp_seller | `POST /auth/otp/request` + `/verify` (phone+OTP) |
| signup_seller | **Dropped** — partner accounts are created by Santra; show a "Want to join Santra?" contact screen using `/content/about` |
| logout_seller | `POST /auth/logout` |
| delete_seller | **Dropped** (no in-app signup → no in-app deletion required; partners contact Santra to offboard) |
| reset_password / verify_reset | N/A in app (OTP login, no password) |
| update_account / update_account_email / seller_language | `PATCH /me` |
| update_account_password | N/A in app (web portal only) |
| home_main | `GET /dashboard` |
| new_seller_splash / force_update | `GET /content/app-version` |
| get_cities | `GET /api/v1/customer/catalog/cities` (public, shared) |
| home_main_orders / search_orders / order_filter | `GET /orders?search=&status=&dateFrom=&dateTo=` |
| accept_order_new / order_ready / reject_order / cancel_order | `PATCH /orders/:id/status` |
| order_submit_new | `POST /orders/manual` |
| delivery_charges | `GET /orders/delivery-quote` |
| generate_link | returned by `POST /orders/manual`; re-issue via `POST /orders/:id/payment-link` |
| discount | `discountAmount` field on `POST /orders/manual` |
| cart_options | N/A (manual order body is self-contained) |
| products_new_seller | `GET /products` |
| products_enable_seller | `PATCH /products/:id/availability` |
| view/add/update/delete_seller_customer | `GET/POST/PUT/DELETE /customers` |
| customer_reviews | `GET /reviews` |
| all_notifications | `GET /notifications` |
| new_about / contact_us | `GET /content/about` |
| new_privacy / terms_seller / seller_contract | `GET /content/legal` |

## Not built yet

- Editing/deleting an existing product (currently create-only; ask admin to edit)
- Push notifications for new orders (will follow once a push provider is chosen)
- Modifier selection on manual-order items (manual items are base products + a
  free-text note per item; use the note for "large size, extra sauce" style requests)
- Operating hours / service area self-management from the app (currently admin-set)

Message Ahmad if anything here doesn't match what you see, or if you need an
endpoint that isn't listed.
