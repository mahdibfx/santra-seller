# Santra Seller API Documentation

This document provides a manually extracted list of API endpoints used in the Santra Seller application, grouped by functional area and screen.

## Base URL
The base URL for all endpoints is defined in `Secret.api_key_url`.
**Base URL:** `https://santra.ae/api/v1/` (Deduced from typical Santra environment, though `Secret.api_key_url` is used in code).

---

## 1. Authentication & Account Management
These endpoints handle user registration, login, and profile updates.

| Endpoint Label | URL Path | Description |
| :--- | :--- | :--- |
| `login` | `login` | Authenticates the seller using email and password. Also registers the FCM token for notifications. |
| `registerSellerApi` | `signup_seller` | Registers a new seller account with business details, contact info, and city. |
| `getOtp` / `verifyResetPassword` | `request_tmp_seller` / `verify_reset` | Requests a one-time password (OTP) for password reset. |
| `resetPasswordApi` | `reset_password` | Resets the seller's password using the provided OTP and new password. |
| `logoutApi` | `logout_seller` | Logs the seller out of the application. |
| `deleteAccountApi` | `delete_seller` | Deletes the seller's account. |
| `updatePasswordApi` | `update_account_password` | Updates the logged-in seller's password. |
| `updateaAccountInfoApi` | `update_account` | Updates seller profile information (Name, Phone, etc.). |
| `updateaEmail` | `update_account_email` | Updates the seller's registered email address. |

---

## 2. Home & Order Management
Endpoints related to the main dashboard and processing orders.

| Endpoint Label | URL Path | Description |
| :--- | :--- | :--- |
| `home_main` | `home_main` | Fetches the primary dashboard data, including order summaries and branch info. |
| `ordersList` | `home_main_orders` | Fetches the list of orders for the seller with pagination (`order_index`). |
| `searchOrders` | `search_orders` | Searches for specific orders by order number. |
| `orderFilterApi` | `order_filter` | Filters orders and profit data by month and year. |
| `accept_order_new` | `accept_order_new` | Accepts a new incoming order. |
| `reject_order` | `reject_order` | Rejects an incoming order. |
| `order_ready` | `order_ready` | Marks an order as ready for pickup/delivery. |
| `cancel_order` | `cancel_order` | Cancels an existing order. |
| `generateLink` | `generate_link` | Generates a payment link for a manual order. |
| `orderSubmitCash` | `order_submit_new` | Submits a new manual order with cash payment. |

---

## 3. Product Management
Endpoints for managing the seller's catalog.

| Endpoint Label | URL Path | Description |
| :--- | :--- | :--- |
| `sellerAllProducts` | `products_new_seller` | Fetches all products available in the seller's store. |
| `productStatusApi` | `products_enable_seller` | Toggles product availability (e.g., approved to out_of_stock). |

---

## 4. Customer Management
Endpoints for managing the seller's customer database.

| Endpoint Label | URL Path | Description |
| :--- | :--- | :--- |
| `customerListApi` | `view_seller_customer` | Fetches the list of customers associated with the seller. |
| `addCustomer` | `add_seller_customer` | Adds a new customer to the seller's list. |
| `updateCustomer` | `update_seller_customer` | Updates details for an existing customer. |
| `deleteCustomerApi` | `delete_seller_customer` | Deletes a customer from the database. |
| `customerReviewsApi` | `customer_reviews` | Fetches reviews submitted by customers. |

---

## 5. Notifications
Endpoints for managing app notifications.

| Endpoint Label | URL Path | Description |
| :--- | :--- | :--- |
| `all_notifications` | `all_notifications` | Fetches consolidated list of new and old notifications for the seller. |

---

## 6. Miscellaneous & Utilities
General utility and info endpoints.

| Endpoint Label | URL Path | Description |
| :--- | :--- | :--- |
| `getCities` | `get_cities` | Fetches the list of available cities for registration and addresses. |
| `delivery_charges` | `delivery_charges` | Fetches delivery settings and charges for manual orders. |
| `cartApi` | `cart_options` | Fetches cart settings, including delivery types (Express/VIP) and available slots. |
| `promoDiscountApi` | `discount` | Validates a promo code and returns the discount amount. |
| `aboutUsApi` | `new_about` | Fetches "About Us" content. |
| `contactUsApi` | `contact_us` | Submits a contact us inquiry. |
| `termsAPi` | `terms_seller` | Fetches Terms and Conditions. |
| `privacyApi` | `new_privacy` | Fetches the Privacy Policy. |
| `contract` | `seller_contract` | Accepts the seller contract/terms. |
| `splashNew` | `new_seller_splash` | (Legacy/Splash) Initial app load endpoint for version checks. |
| `forceUpdateApi` | `force_update` | Checks if a mandatory app update is required. |
| `languageSelection` | `seller_language` | Fetches translation strings for the selected language. |
| `deliveryCharges` | `delivery_charges` | Fetches model for delivery charges based on seller code. |

---

## Headers
Most requests require the following header:
```json
{
  "Api-Key": "Client-Secret" // Values fetched from Secret class
}
```
