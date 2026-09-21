# Santra Partner App — Full API Reference

**Version:** 2026-07-20 · **Base URL (staging):** `https://api-staging.santra.ae/api/v1/partner`

Every endpoint below is written as `METHOD /path` relative to that base. So
`GET /orders` means `GET https://api-staging.santra.ae/api/v1/partner/orders`.

Response examples are **real responses captured from staging** wherever the
endpoint could be called without partner-specific test data.

---

## Contents

1. [Conventions](#1-conventions)
2. [Errors](#2-errors)
3. [Authentication](#3-authentication)
4. [Become a partner (public)](#4-become-a-partner-public)
5. [Geography — cities & areas](#5-geography--cities--areas)
6. [Dashboard](#6-dashboard)
7. [Orders](#7-orders)
8. [Manual orders](#8-manual-orders)
9. [Products](#9-products)
10. [Add-ons](#10-add-ons)
11. [My customers](#11-my-customers)
12. [Invoices & settlement](#12-invoices--settlement)
13. [Reviews](#13-reviews)
14. [Notifications](#14-notifications)
15. [Profile](#15-profile)
16. [App content](#16-app-content)
17. [What the app cannot do yet](#17-what-the-app-cannot-do-yet)

---

## 1. Conventions

Identical to the customer API:

- **Envelope:** `{ "data": … }`; lists add `meta` with `page`, `limit`,
  `total`, `totalPages`.
- **Pagination:** `?page=` (default 1), `?limit=` (default 20, max 100).
- **Languages:** bilingual rows return `name_en` + `name_ar` together — pick
  by app language, no `Accept-Language` header.
- **Booleans:** DB-backed flags are `0`/`1`; computed fields are real booleans.
- **Money:** AED numbers, 2 decimals.
- **Dates:** `YYYY-MM-DD`, timestamps ISO-8601 UTC; business-day logic runs in
  **Asia/Dubai**.
- **Auth:** endpoints marked 🔒 need `Authorization: Bearer <accessToken>`.

**Important:** a partner token only works on `/partner/*` and the shared
portal endpoints. Using it on `/customer/*` returns `403`.

---

## 2. Errors

```json
{ "error": { "code": "UNAUTHORIZED", "message": "Missing bearer token" } }
```
(real response from `GET /orders` without a token)

| HTTP | Code | Meaning |
|---|---|---|
| 400 | `VALIDATION_ERROR` | Bad/missing field; `message` names it |
| 401 | `UNAUTHORIZED` | Missing/expired token → refresh and retry |
| 403 | `FORBIDDEN` | Wrong token type, or account disabled |
| 404 | `NOT_FOUND` | Unknown id, or a record belonging to another partner |
| 409 | `INVALID_STATUS_TRANSITION` | Illegal order status jump |
| 429 | `RATE_LIMITED` | Too many requests (OTP especially) |
| 500 | `INTERNAL_ERROR` | Server fault — safe to retry once |

Every record is scoped to the authenticated partner. Another partner's order
id returns `404`, never someone else's data.

---

## 3. Authentication

Phone + OTP — but unlike customers, **partners cannot self-register**. The
phone must already belong to a partner account created/approved by Santra.

> **Staging:** no SMS provider connected, so the response includes
> `debugCode`. It disappears in production.

### `POST /auth/otp/request`
| Field | Type | Required | Notes |
|---|---|---|---|
| `countryCode` | string | ✅ | Format `+971` |
| `phone` | string | ✅ | Digits only, 5–14 |
| `deviceInfo` | string | — | Max 255 |

```json
{ "countryCode": "+971", "phone": "501234567", "deviceInfo": "iPhone 14" }
```
**200**
```json
{ "message": "OTP sent", "expiresInSeconds": 300, "debugCode": "123456" }
```
Errors: `404` no partner account for this phone · `403` account disabled
(checked **before** an OTP is sent) · `429` cooldown.

### `POST /auth/otp/verify`
| Field | Type | Required |
|---|---|---|
| `countryCode` | string | ✅ |
| `phone` | string | ✅ |
| `code` | string | ✅ (6 digits) |
| `deviceInfo` | string | — |

**200**
```json
{
  "accessToken": "eyJhbGciOi…",
  "refreshToken": "9f3c…",
  "expiresIn": 900,
  "partner": {
    "id": 42, "nameEn": "Mimi Bakery", "nameAr": "مخبز ميمي",
    "phone": "501234567", "countryCode": "+971", "email": "owner@mimibakery.com"
  }
}
```
Access token 15 min · refresh token 30 days.

### `POST /auth/refresh` — `{ "refreshToken": "…", "deviceInfo": "…" }`
### `POST /auth/logout` — `{ "refreshToken": "…" }` (that device only)

---

## 4. Become a partner (public)

### `POST /auth/register-request`
The "Become a partner" form. Creates an onboarding lead; the business
**cannot log in** until Santra's team contacts and approves them.

| Field | Type | Required | Notes |
|---|---|---|---|
| `businessName` | string | ✅ | 2–200 chars |
| `businessNameAr` | string | — | Arabic trade name |
| `contactName` | string | — | Owner/manager |
| `countryCode` | string | — | Default `+971` |
| `phone` | string | ✅ | Digits only, 5–14 |
| `email` | string | ✅ | Valid email |
| `cityId` | int | — | From `GET /cities`; defaults to Dubai |

```json
{
  "businessName": "Mimi Bakery",
  "businessNameAr": "مخبز ميمي",
  "contactName": "Sara Ahmed",
  "countryCode": "+971",
  "phone": "501234567",
  "email": "owner@mimibakery.com",
  "cityId": 1
}
```
**200** — real response:
```json
{ "data": { "received": true } }
```

⚠️ **The response is ALWAYS this same 200** — including when the phone or
email already belongs to a partner. That's deliberate (the endpoint must
never reveal whether a number is registered). Always show
*"Thanks — our team will contact you."*

Errors: `400` validation (bad phone/email) · `429` rate-limited.

---

## 5. Geography — cities & areas

Public — no auth. Needed for the city picker on the form above and for
address fields on manual orders/customers.

### `GET /cities`
**200** — real response:
```json
{ "data": [
  { "id": 1, "name_en": "Dubai", "name_ar": "دبي" },
  { "id": 2, "name_en": "Sharjah", "name_ar": "الشارقة" },
  { "id": 3, "name_en": "Ajman", "name_ar": "عجمان" },
  { "id": 4, "name_en": "Abu Dhabi", "name_ar": "أبوظبي" },
  { "id": 5, "name_en": "Umm Ul Quwain", "name_ar": "أم القيوين" },
  { "id": 6, "name_en": "Ras Al Khaimah", "name_ar": "رأس الخيمة" },
  { "id": 7, "name_en": "Fujairah", "name_ar": "الفجيرة" },
  { "id": 8, "name_en": "Al Ain", "name_ar": "العين" }
] }
```

### `GET /areas`
| Param | Type | Required | Notes |
|---|---|---|---|
| `cityId` | int | — | Omit for every area in one call |

**200** — real response for `?cityId=1`:
```json
{ "data": [
  { "id": 1586, "city_id": 1, "name_en": "Abu Baker Al Siddique Rd", "name_ar": "Abu Baker Al Siddique Rd", "is_scheduled_only": 0 },
  { "id": 26, "city_id": 1, "name_en": "Abu Hail", "name_ar": "Abu Hail", "is_scheduled_only": 0 }
] }
```
Unknown city → `404`, non-numeric → `400`. Area `name_ar` still repeats
English — see §17.

---

## 6. Dashboard 🔒

### `GET /dashboard`
The home screen of the partner app: today's counts and revenue, pending
orders needing action, and recent activity. Call it on app open and on
pull-to-refresh.

---

## 7. Orders 🔒

### `GET /orders`
| Param | Type | Default | Notes |
|---|---|---|---|
| `page` / `limit` | int | 1 / 20 | |
| `search` | string | — | Order number (max 30 chars) |
| `status` | enum | — | `pending`, `confirmed`, `preparing`, `ready`, `out_for_delivery`, `delivered`, `cancelled`, `failed` |
| `dateFrom` | date | — | `YYYY-MM-DD` |
| `dateTo` | date | — | `YYYY-MM-DD` |

Only this partner's orders. Customer PII is **masked** — the app sees the
customer's first name and area, never the full phone/address book.

### `GET /orders/:id`
Full order: items with modifiers and notes, add-ons, totals, delivery
type/date, and the status timeline.

### `PATCH /orders/:id/status`
The order board action.

| Field | Type | Required | Notes |
|---|---|---|---|
| `status` | enum | ✅ | `confirmed` \| `preparing` \| `ready` \| `cancelled` |
| `note` | string | — | Max 500 — required by policy when cancelling |

```json
{ "status": "preparing" }
```
A partner can move an order forward through *confirmed → preparing → ready*
(or cancel). Later stages (`out_for_delivery`, `delivered`) belong to
delivery/ops, so the API rejects them with `409`.

### `POST /orders/:id/payment-link`
Generates a pay-by-link for an unpaid manual order and returns the URL to
share with the customer.

---

## 8. Manual orders 🔒

Orders the partner takes by phone/WhatsApp and enters themselves.
**No commission and no service fee** are charged on manual orders.

### `GET /orders/delivery-quote`
| Param | Type | Required |
|---|---|---|
| `areaId` | int | ✅ |

**200**
```json
{ "data": { "deliveryFee": 5, "cityId": 1 } }
```
Quote the fee **before** placing, so the partner sees the cost up front.

### `POST /orders/manual`
| Field | Type | Required | Notes |
|---|---|---|---|
| `partnerCustomerId` | int | either/or | An existing saved customer… |
| `customer` | object | either/or | …or an inline new one |
| `customer.name` | string | ✅ | |
| `customer.countryCode` | string | — | Default `+971` |
| `customer.phone` | string | ✅ | Digits only, 5–14 |
| `customer.cityId` / `areaId` | int | — | |
| `customer.addressLine` / `building` / `unit` | string | — | |
| `areaId` | int | — | Delivery area (fee basis) |
| `addressLine` | string | — | Delivery address |
| `items[]` | array | ✅ | |
| `items[].productId` | int | ✅ | |
| `items[].quantity` | int | ✅ | 1–99 |
| `items[].note` | string | — | Max 255 |
| `discountAmount` | number | — | Partner-funded discount |
| `paymentMethod` | enum | ✅ | `cash` \| `payment_link` |
| `gatewayFeeBorneBy` | enum | — | `partner` (default) \| `customer` |
| `deliveryInstructions` | string | — | Max 255 |
| `orderNotes` | string | — | Max 1000 |

```json
{
  "customer": { "name": "Aisha", "phone": "501112233", "cityId": 1, "areaId": 26, "addressLine": "Villa 8, Street 4" },
  "areaId": 26,
  "items": [ { "productId": 7578, "quantity": 2, "note": "No nuts" } ],
  "paymentMethod": "payment_link",
  "gatewayFeeBorneBy": "customer"
}
```
Provide **either** `partnerCustomerId` **or** `customer` — supplying neither
is a `400`. `gatewayFeeBorneBy` decides who absorbs the payment-gateway fee
on pay-by-link orders; it's a per-order choice.

---

## 9. Products 🔒

### `GET /products`
| Param | Type | Default | Notes |
|---|---|---|---|
| `page` / `limit` | int | 1 / 20 | |
| `search` | string | — | Name (EN/AR) |
| `approvalStatus` | enum | — | `draft`, `pending_review`, `approved`, `rejected` |
| `availabilityStatus` | enum | — | `online`, `offline`, `out_of_stock` |

### `GET /products/:id` — full product with modifier groups

### `POST /products`
New products are **submitted for Santra review** — they don't go live
immediately.

| Field | Type | Required | Notes |
|---|---|---|---|
| `categoryId` | int | ✅ | |
| `nameEn` / `nameAr` | string | ✅ | Max 200 |
| `descriptionEn` / `descriptionAr` | string | — | Max 2000 |
| `price` | number | ✅ | ≥ 0 |
| `compareAtPrice` | number | — | "Was" price |
| `quantityLabel` | string | — | e.g. `"500 g"` |
| `calories` | int | — | |
| `prepTimeMinutes` | int | — | Default 0 — **drives the delivery date** |
| `ingredientsEn` / `ingredientsAr` | string | — | Max 2000 |
| `isVegan` | bool | — | Default false |
| `allergenInfo` | string | — | Max 255 |
| `isExpress` / `isVip` / `isPickup` / `isGiftEligible` | bool | — | Default false |

⚠️ `prepTimeMinutes` matters: the longest prep time in a customer's cart is
rounded up to whole days and paid down on **working days only** (closed days
prepare nothing), which sets the delivery date. Getting it wrong promises
customers the wrong date.

### `PATCH /products/:id/availability`
The fast toggle used on the product list.
```json
{ "status": "out_of_stock" }
```
`status` ∈ `online` | `offline` | `out_of_stock`. Out-of-stock products stay
visible to customers but are non-orderable.

---

## 10. Add-ons 🔒

Extras a customer can attach to an order (gift card, candle, ribbon, note
card, packaging).

| Endpoint | Purpose |
|---|---|
| `GET /addons` | List (`?page=&limit=&search=`) |
| `GET /addons/:id` | One add-on |
| `POST /addons` | Create |
| `PUT /addons/:id` | Update |
| `PATCH /addons/:id/activate` | Make available |
| `PATCH /addons/:id/deactivate` | Hide without deleting |

---

## 11. My customers 🔒

The partner's own address book, used to speed up manual orders. Separate
from Santra's customer accounts.

| Endpoint | Purpose |
|---|---|
| `GET /customers` | `?page=&limit=&search=` |
| `GET /customers/:id` | One record |
| `POST /customers` | Create |
| `PUT /customers/:id` | Update |
| `DELETE /customers/:id` | Remove |

| Field | Type | Required | Notes |
|---|---|---|---|
| `name` | string | ✅ | Max 100 |
| `countryCode` | string | — | Default `+971` |
| `phone` | string | ✅ | Digits only, 5–14 |
| `cityId` / `areaId` | int | — | |
| `addressLine` | string | — | Max 255 |
| `building` / `unit` | string | — | |
| `notes` | string | — | Max 500 |

---

## 12. Invoices & settlement 🔒

### `GET /invoices`
`?page=&limit=&status=` where `status` ∈ `draft`, `verification`,
`finance_review`, `approved`, `payment_review`, `paid`, `overdue`.

### `GET /invoices/:id`
The invoice with its order lines, commission, fees, adjustments and VAT.

### `POST /invoices/:id/payments`
Records a payment the partner made against an invoice (e.g. a bank
transfer), which Santra Finance then verifies. Submitting a payment moves
the invoice to `payment_review` — it does **not** mark it paid; only Finance
does that after matching the bank statement.

---

## 13. Reviews 🔒

### `GET /reviews`
Reviews customers left for this partner: rating, comment, customer **first
name only**, date, and the order reference. Read-only.

---

## 14. Notifications 🔒

| Endpoint | Purpose |
|---|---|
| `GET /notifications` | `?page=&limit=` |
| `GET /notifications/unread-count` | Badge |
| `PATCH /notifications/:id/read` | Mark one read |
| `POST /notifications/read-all` | Mark all read |

Note the method difference from the customer app: here read-all is a
**POST**, not a PATCH.

---

## 15. Profile 🔒

### `GET /me`
Store profile: names, logo/cover, contact, city, delivery settings, rating.
Excludes password, banking and commission details.

### `PATCH /me`
| Field | Type | Notes |
|---|---|---|
| `email` | string | Valid email |
| `ownerName` | string | Max 100 |
| `preferredLanguage` | enum | `en` \| `ar` |
| `descriptionEn` / `descriptionAr` | string | Max 2000 |

At least one field must be present, else `400`.

Deliberately **not editable** from the app: business name, phone, commission,
banking details and operating hours — those are Santra-managed (see §17).

---

## 16. App content

### `GET /content/about`
**200** — real response:
```json
{ "data": {
  "whatsapp_number": null, "call_number": null, "support_email": null,
  "website_url": null,
  "office_address": "Techno Hub 1, Office 154, DSO, Dubai, UAE"
} }
```
`null` = not configured yet; hide those rows.

### `GET /content/legal` — terms & privacy (EN + AR)

### `GET /content/app-version`
**200** — real response:
```json
{ "data": { "platform": "ios", "minVersion": null, "latestVersion": null, "storeUrl": null } }
```
Version gate. `minVersion: null` means no gate is configured yet — treat as
"no forced update". Once set, block the app if the installed build is lower.

---

## 17. What the app cannot do yet

Real API behavior — not bugs. None of these need app changes when they land.

| Area | Status |
|---|---|
| **Operating hours** | Managed by Santra admin only. There is no partner-app endpoint to edit the weekly open/close days yet. Hours drive delivery dates (a closed day prepares and delivers nothing), so an update is planned — we'll send the endpoint when it ships. |
| **Order status** | Partners move orders only through `confirmed → preparing → ready` (or cancel). `out_for_delivery` / `delivered` are ops-side. |
| **Invoice payment** | Partners submit a payment record; only Santra Finance marks an invoice `paid`. |
| **Self-registration** | Impossible by design — `register-request` creates a lead, Santra approves. |
| **Product images** | No upload endpoint yet (image-storage strategy pending). Products created from the app have no image. |
| **Area `name_ar`** | Repeats English text; the 1,735 areas await a translation pass. Cities are already translated. |
| **App version gate** | Not configured (`minVersion: null`). |
| **Staging orders** | No historical orders. Place test orders through the customer app to populate the order board. |

---

## Quick test recipe (staging)

```bash
# Public — no auth
curl https://api-staging.santra.ae/api/v1/partner/cities
curl "https://api-staging.santra.ae/api/v1/partner/areas?cityId=1"

# "Become a partner" — always returns {"data":{"received":true}}
curl -X POST https://api-staging.santra.ae/api/v1/partner/auth/register-request \
  -H "Content-Type: application/json" \
  -d '{"businessName":"Mimi Bakery","phone":"501234567","email":"owner@mimibakery.com","cityId":1}'

# Login (needs a partner account that already exists — ask Ahmad for a test one)
curl -X POST https://api-staging.santra.ae/api/v1/partner/auth/otp/request \
  -H "Content-Type: application/json" \
  -d '{"countryCode":"+971","phone":"PARTNER_PHONE"}'

curl -X POST https://api-staging.santra.ae/api/v1/partner/auth/otp/verify \
  -H "Content-Type: application/json" \
  -d '{"countryCode":"+971","phone":"PARTNER_PHONE","code":"PASTE_debugCode"}'

# Authenticated
curl https://api-staging.santra.ae/api/v1/partner/orders \
  -H "Authorization: Bearer PASTE_accessToken"
```

Questions → Ahmad.
