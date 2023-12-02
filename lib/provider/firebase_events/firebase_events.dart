import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';

import '../apps_flyr/appflyer_controller.dart';

class FirebaseAnalyticsController extends GetxController {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  AppFlyerController appsFlyer = Get.put(AppFlyerController());
  Future firebaseAppInstallEvent() async {
    Map<String, dynamic> body = {};

    await appsFlyer.appsFlyerAppInstall();
    await _sendAnalyticsEvent('pr_seller_install', body);
  }

  Future firebaseFirstAppOpenEvent() async {
    Map<String, dynamic> body = {};
    await appsFlyer.appsFlyerFirstOpen();
    await _sendAnalyticsEvent('pr_seller_first_open', body);
  }

  Future firebaseAddToCartEvent(String name, double price, String qty) async {
    Map<String, dynamic> body = {
      "seller_product_name": name,
      "product_price": price,
      "product_qty": qty,
    };
    await appsFlyer.appsFlyerAddToCartEvent(price, qty);
    await _sendAnalyticsEvent('pr_seller_add_cart', body);
  }

  Future firebasePurchaseEvent(
    String id,
    double total,
  ) async {
    Map<String, dynamic> body = {
      "currency": "AED",
      "transaction_id": id,
      "value": total,
    };
    await appsFlyer.appsFlyerPurchaseEvent(id, total);
    await _sendAnalyticsEvent('purchase', body);
  }
//   openAppFirstEvent() {
//     Map<String, dynamic> body = {
//       "af_channel": 'open app',
//     };
//     _sendAnalyticsEvent('pr_first_time_open', body);
//   }

//   addOrderEvent() {
//     Map<String, dynamic> body = {
//       "af_channel": 'add order Page',
//     };
//     _sendAnalyticsEvent('pr_add_order', body);
//   }

//   addItemsEvent() {
//     Map<String, dynamic> body = {
//         "af_channel": 'added to cart',
//     };
//     _sendAnalyticsEvent('pr_add_items', body);
//   }

//   viewCartEvent() {
//     Map<String, dynamic> body = {
//        "af_channel": 'Cart Page',
//     };
//     _sendAnalyticsEvent('pr_view_cart', body);
//   }
// ////////////////////////////////////////
//   voucherCodeEvent(String voucherCode) {
//     Map<String, dynamic> body = {  "voucher_code": voucherCode,};
//     _sendAnalyticsEvent('pr_vouchercode', body);
//   }

//   addCustomerEvent() {
//     Map<String, dynamic> body = {
//    "af_channel": 'click on add customer button',
//     };
//     _sendAnalyticsEvent('pr_add_customer', body);
//   }

//   customerInfoEvent() {
//     Map<String, dynamic> body = {
//       "af_channel": 'customer Info screen',
//     };
//     _sendAnalyticsEvent('pr_customer_info', body);
//   }

//   // block_product_name - example - cakes, sweets, grape leaves

//   submitOrderEvent() {
//     Map<String, dynamic> body = {
//        "af_channel": 'Submit order',
//     };
//     _sendAnalyticsEvent('pr_submit_order', body);
//   }

//   paymentLinkEvent() {
//     Map<String, dynamic> body = {
//         "af_channel": 'payment by link',
//     };
//     _sendAnalyticsEvent('pr_payment_link', body);
//   }

//   codEvent() {
//     Map<String, dynamic> body = {
//       "af_channel": 'Cash on delivery',
//     };
//     _sendAnalyticsEvent('pr_payment_cod', body);
//   }

//   orderConfirmedEvent(String orderPrice, String orderType) {
//     Map<String, dynamic> body = {
//       "order_value": orderPrice,
//       "order_type" : orderType
//     };
//     _sendAnalyticsEvent('pr_order_confirmed', body);
//   }

//   cancelOrderEvent() {
//     Map<String, dynamic> body = {
//       "af_channel": 'Cancel Order',
//     };
//     _sendAnalyticsEvent('pr_cancel_order', body);
//   }

//   customerListEvent() {
//     Map<String, dynamic> body = {
//      "af_channel": 'Customer List screen',
//     };
//     _sendAnalyticsEvent('customer_list', body);
//   }

//   customerReviewsEvent() {
//     Map<String, dynamic> body = {
//      "af_channel": 'Customer reviews screen',
//     };
//     _sendAnalyticsEvent('customer_reviews', body);
//   }

//   contactCustomerServiceEvent() {
//     Map<String, dynamic> body = {
//       "af_channel": 'Customer service screen',
//     };
//     _sendAnalyticsEvent('contact_customer_service', body);
//   }

//   contactServiceSubmitEvent() {
//     Map<String, dynamic> body = {
//  "af_channel": 'successfully send query',
//     };
//     _sendAnalyticsEvent('cs_send_success', body);
//   }

  Future<void> _sendAnalyticsEvent(
      String eventName, Map<String, dynamic> body) async {
    // Only strings and numbers (longs & doubles for android, ints and doubles for iOS) are supported for GA custom event parameters:
    // https://firebase.google.com/docs/reference/ios/firebaseanalytics/api/reference/Classes/FIRAnalytics#+logeventwithname:parameters:
    // https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics#public-void-logevent-string-name,-bundle-params
    await analytics.logEvent(
      name: eventName,
      parameters: body,
    );
  }
}
