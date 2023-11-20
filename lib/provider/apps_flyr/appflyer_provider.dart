// import 'package:appsflyer_sdk/appsflyer_sdk.dart';
// import 'package:get/get.dart';
// import 'package:santra_seller/provider/adjust_event/adjust_events.dart';
// import 'package:santra_seller/provider/firebase_events/firebase_events.dart';
// import 'dart:io' show Platform;
// import '../../constants/app_constants.dart';

// class AppFlyerController extends GetxController {
//   AppsflyerSdk? appsflyerSdk;
//   Map? deepLinkData;
//   Map? gcd;

//   openAppFirstEvent() {
//     Map eventValues = {
//       "af_channel": 'open app',
//     };
//     logEvent('pr_first_time_open', eventValues);
//     // adjustEventController.openAppFirstEvent();
//     // firebaseEvenntController.openAppFirstEvent();
//   }

//   addOrderEvent() {
//     Map eventValues = {
//       "af_channel": 'add order Page',
//     };
//     logEvent('pr_add_order', eventValues);
//     //adjustEventController.addOrderEvent();
//     //firebaseEvenntController.addOrderEvent();
//   }

//   addItemsEvent() async {
//     Map eventValues = {
//       "af_channel": 'added to cart',
//     };
//     await logEvent('pr_add_items', eventValues);
//     //adjustEventController.addItemsEvent();
//     //firebaseEvenntController.addItemsEvent();
//   }

//   viewCartEvent() {
//     Map eventValues = {
//       "af_channel": 'Cart Page',
//     };
//     logEvent('pr_view_cart', eventValues);
//     // adjustEventController.viewCartEvent();
//     // firebaseEvenntController.viewCartEvent();
//   }

//   voucherCodeEvent(String voucherCode) {
//     Map eventValues = {
//       "voucher_code": voucherCode,
//     };
//     logEvent('pr_vouchercode', eventValues);
//     // adjustEventController.voucherCodeEvent(voucherCode);
//     //  firebaseEvenntController.voucherCodeEvent(voucherCode);
//   }

//   addCustomerEvent() {
//     Map eventValues = {
//       "af_channel": 'click on add customer button',
//     };
//     logEvent('pr_add_customer', eventValues);
//     //adjustEventController.addCustomerEvent();
//     // firebaseEvenntController.addCustomerEvent();
//   }

//   customerInfoEvent() {
//     Map eventValues = {
//       "af_channel": 'customer Info screen',
//     };
//     logEvent('pr_customer_info', eventValues);
//     // adjustEventController.customerInfoEvent();
//     //  firebaseEvenntController.customerInfoEvent();
//   }

//   submitOrderEvent() {
//     Map eventValues = {
//       "af_channel": 'Submit order',
//     };
//     logEvent('pr_submit_order', eventValues);
//     // adjustEventController.submitOrderEvent();
//     // firebaseEvenntController.submitOrderEvent();
//   }

//   paymentLinkEvent() {
//     Map eventValues = {
//       "af_channel": 'payment by link',
//     };
//     logEvent('pr_payment_link', eventValues);
//     // adjustEventController.paymentLinkEvent();
//     //  firebaseEvenntController.paymentLinkEvent();
//   }

//   codEvent() {
//     Map eventValues = {
//       "af_channel": 'Cash on delivery',
//     };
//     logEvent('pr_payment_cod', eventValues);
//     // adjustEventController.codEvent();
//     //  firebaseEvenntController.codEvent();
//   }

//   orderConfirmedEvent(String orderPrice, String orderType) {
//     Map eventValues = {"order_value": orderPrice, "order_type": orderType};
//     logEvent('pr_order_confirmed', eventValues);
//     //adjustEventController.orderConfirmedEvent(orderPrice, orderType);
//     // firebaseEvenntController.orderConfirmedEvent(orderPrice,orderType);
//   }

//   cancelOrderEvent() {
//     Map eventValues = {
//       "af_channel": 'Cancel Order',
//     };
//     logEvent('pr_cancel_order', eventValues);
//     // adjustEventController.cancelOrderEvent();
//     //  firebaseEvenntController.cancelOrderEvent();
//   }

//   customerListEvent() {
//     Map eventValues = {
//       "af_channel": 'Customer List screen',
//     };
//     logEvent('customer_list', eventValues);
//     // adjustEventController.customerListEvent();
//     // firebaseEvenntController.customerListEvent();
//   }

//   customerReviewsEvent() {
//     Map eventValues = {
//       "af_channel": 'Customer reviews screen',
//     };
//     logEvent('customer_reviews', eventValues);
//     // adjustEventController.customerReviewsEvent();
//     // firebaseEvenntController.customerReviewsEvent();
//   }

//   contactCustomerServiceEvent() {
//     Map eventValues = {
//       "af_channel": 'Customer service screen',
//     };
//     logEvent('contact_customer_service', eventValues);
//     //adjustEventController.contactCustomerServiceEvent();
//     // firebaseEvenntController.contactCustomerServiceEvent();
//   }

//   contactServiceSubmitEvent() {
//     Map eventValues = {
//       "af_channel": 'successfully send query',
//     };
//     logEvent('cs_send_success', eventValues);
//     // adjustEventController.contactServiceSubmitEvent();
//     //  firebaseEvenntController.contactServiceSubmitEvent();
//   }

//   appflyerLogs() {
//     final AppsFlyerOptions options = Platform.isAndroid
//         ? AppsFlyerOptions(
//             afDevKey: AppConstants.appsFlyerAndroidKey,
//             //appFlyerData!.androidDevKey.toString(),
//             // showDebug: true,
//             timeToWaitForATTUserAuthorization: 15)
//         : AppsFlyerOptions(
//             afDevKey: AppConstants.appsFlyerIOSKey,
//             //appFlyerData!.iOsKey.toString(),
//             appId: AppConstants.appID,
//             // showDebug: true,
//             timeToWaitForATTUserAuthorization: 15);
//     appsflyerSdk = AppsflyerSdk(options);
//     appsflyerSdk!.onAppOpenAttribution((res) {
//       print("onAppOpenAttribution res: " + res.toString());

//       deepLinkData = res;
//       update();
//     });
//     appsflyerSdk!.onInstallConversionData((res) {
//       // print("onInstallConversionData res: " + res.toString());

//       gcd = res;
//       update();
//     });
//     appsflyerSdk!.onDeepLinking((DeepLinkResult dp) {
//       switch (dp.status) {
//         case Status.FOUND:
//           // print(dp.deepLink?.toString());
//           // print("deep link value: ${dp.deepLink?.deepLinkValue}");
//           break;
//         case Status.NOT_FOUND:
//           // print("deep link not found");
//           break;
//         case Status.ERROR:
//           // print("deep link error: ${dp.error}");
//           break;
//         case Status.PARSE_ERROR:
//           // print("deep link status parsing error");
//           break;
//       }
//       // print("onDeepLinking res: " + dp.toString());

//       deepLinkData = dp.toJson();
//       update();
//     });
//     appsflyerSdk!.initSdk(
//         registerConversionDataCallback: true,
//         registerOnAppOpenAttributionCallback: false,
//         registerOnDeepLinkingCallback: true);
//   }

//   Future<bool?> logEvent(String eventName, Map eventValues) {
//     return appsflyerSdk!.logEvent(eventName, eventValues);
//   }
// }
