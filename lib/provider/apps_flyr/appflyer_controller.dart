// import 'package:appsflyer_sdk/appsflyer_sdk.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:santra_seller/constants/app_constants.dart';
// import 'dart:io' show Platform;

// class AppFlyerController extends GetxController {
//   late AppsflyerSdk appsflyerSdk;
//   Map? deepLinkData;
//   Map? gcd;
//   bool isAppsFlyerLoading = false;
//   bool isAppsFlyerOnehasError = false;
//   String setEventName = '';
//   Future<void> appsFlyerAddToCartEvent(double price, String qty) async {
//     Map<String, dynamic> eventValues = {
//       "af_currency": "AED",
//       "af_price": price,
//       "af_quantity": qty,
//     };
//     try {
//       await logEvent('af_add_to_cart', eventValues);
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//     }
//   }

//   Future<void> appsFlyerPurchaseEvent(String id, double total) async {
//     Map<String, dynamic> body = {
//       "af_currency": "AED",
//       "af_content_id": id,
//       "af_revenue": total,
//     };
//     await logEvent('af_purchase', body);
//   }

//   Future<void> appsFlyerFirstOpen() async {
//     Map eventValues = {};
//     try {
//       await logEvent('af_first_open', eventValues);
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//     }
//   }

//   Future<void> appsFlyerAppInstall() async {
//     Map eventValues = {};
//     try {
//       await logEvent('af_install', eventValues);
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//     }
//   }

//   appflyerLogs() {
//     AppsFlyerOptions appsFlyerOptions = AppsFlyerOptions(
//       afDevKey: AppConstants.appsFlyerAndroidKey,
//       appId: AppConstants.appID,
//       showDebug: false,
//       timeToWaitForATTUserAuthorization: 50, // for iOS 14.5
//       // appInviteOneLink: oneLinkID, // Optional field
//       // disableAdvertisingIdentifier: false, // Optional field
//       // disableCollectASA: false
//     ); // Optional field

//     appsflyerSdk = AppsflyerSdk(appsFlyerOptions);
//     // final AppsFlyerOptions options = Platform.isAndroid
//     //     ? AppsFlyerOptions(
//     //         afDevKey: Secret.appsFlyerAndroidKey,
//     //         //appFlyerData!.androidDevKey.toString(),
//     //         // showDebug: true,
//     //         timeToWaitForATTUserAuthorization: 15)
//     //     : AppsFlyerOptions(
//     //         afDevKey: Secret.appsFlyerIOSKey,
//     //         //appFlyerData!.iOsKey.toString(),
//     //   appId: Secret.appFlyerID,
//     //         // showDebug: true,
//     //         timeToWaitForATTUserAuthorization: 15);
//     // appsflyerSdk = AppsflyerSdk(options);
//     // appsflyerSdk!.onAppOpenAttribution((res) {
//     //   print("onAppOpenAttribution res: " + res.toString());

//     //   deepLinkData = res;
//     //   update();
//     // });
//     // appsflyerSdk!.onInstallConversionData((res) {
//     //   // print("onInstallConversionData res: " + res.toString());

//     //   gcd = res;
//     //   update();
//     // });
//     // appsflyerSdk!.onDeepLinking((DeepLinkResult dp) {
//     //   switch (dp.status) {
//     //     case Status.FOUND:
//     //       // print(dp.deepLink?.toString());
//     //       // print("deep link value: ${dp.deepLink?.deepLinkValue}");
//     //       break;
//     //     case Status.NOT_FOUND:
//     //       // print("deep link not found");
//     //       break;
//     //     case Status.ERROR:
//     //       // print("deep link error: ${dp.error}");
//     //       break;
//     //     case Status.PARSE_ERROR:
//     //       // print("deep link status parsing error");
//     //       break;
//     //   }
//     //   // print("onDeepLinking res: " + dp.toString());

//     //   deepLinkData = dp.toJson();
//     //   update();
//     // });
//     appsflyerSdk.initSdk(
//         registerConversionDataCallback: true,
//         registerOnAppOpenAttributionCallback: false,
//         registerOnDeepLinkingCallback: true);
//   }

//   Future logEvent(String eventName, Map eventValues) {
//     return appsflyerSdk.logEvent(eventName, eventValues);
//   }
// }



// //
