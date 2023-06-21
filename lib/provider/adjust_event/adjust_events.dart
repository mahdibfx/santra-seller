import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_attribution.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:adjust_sdk/adjust_event_failure.dart';
import 'package:adjust_sdk/adjust_event_success.dart';
import 'package:adjust_sdk/adjust_session_failure.dart';
import 'package:adjust_sdk/adjust_session_success.dart';
import 'package:get/get.dart';
import 'dart:io' show Platform;

import 'package:santra_seller/constants/app_constants.dart';

class AdjustAnalyticsController extends GetxController {
  openAppFirstEvent() {
    Map<String, dynamic> body = {};
    _sendAnalyticsEvent(Platform.isIOS ? 'khkf2t' : 'cssae9', body);
  }

  addOrderEvent() {
    Map<String, dynamic> body = {};
    _sendAnalyticsEvent(Platform.isIOS ? '1pp26h' : 'oe81ej', body);
  }

  addItemsEvent() {
    Map<String, dynamic> body = {
      "af_channel": 'added to cart',
    };
    _sendAnalyticsEvent(Platform.isIOS ? 'wqy7uu' : 'w2cs9x', body);
  }

  viewCartEvent() {
    Map<String, dynamic> body = {
      "af_channel": 'Cart Page',
    };
    _sendAnalyticsEvent(Platform.isIOS ? 'mi5ykn' : 'xsmeeu', body);
  }

  voucherCodeEvent(String voucherCode) {
    Adjust.trackEvent(buildVoucher(voucherCode));
  }

  static AdjustEvent buildVoucher(String voucherCode) {
    AdjustEvent event = AdjustEvent(Platform.isIOS ? 'l9ve2z' : 'noy9rf');
    event.addCallbackParameter('voucher_code', voucherCode);
    return event;
  }

  addCustomerEvent() {
    Map<String, dynamic> body = {
      "af_channel": 'click on add customer button',
    };
    _sendAnalyticsEvent(Platform.isIOS ? '96cg1b' : '1eiwq4', body);
  }

  customerInfoEvent() {
    Map<String, dynamic> body = {
      "af_channel": 'customer Info screen',
    };
    _sendAnalyticsEvent(Platform.isIOS ? 'xhfxr2' : '8vddrw', body);
  }

  submitOrderEvent() {
    Map<String, dynamic> body = {
      "af_channel": 'Submit order',
    };
    _sendAnalyticsEvent(Platform.isIOS ? 'uokqh9' : 'e1u9vm', body);
  }

  paymentLinkEvent() {
    Map<String, dynamic> body = {
      "af_channel": 'payment by link',
    };
    _sendAnalyticsEvent(Platform.isIOS ? 'o6wljo' : 'u5r3f5', body);
  }

  codEvent() {
    Map<String, dynamic> body = {
      "af_channel": 'Cash on delivery',
    };
    _sendAnalyticsEvent(Platform.isIOS ? 'wsw4vr' : 'a4zd9g', body);
  }

  orderConfirmedEvent(String orderPrice, String orderType) {
    Adjust.trackEvent(buildRevenueEvent(orderPrice, orderType));
  }

  static AdjustEvent buildRevenueEvent(String orderPrice, String orderType) {
    AdjustEvent event = AdjustEvent(Platform.isIOS ? 'e1wx9b' : 'ab868g');
    event.setRevenue(int.parse(orderPrice), 'AED');
    event.transactionId = orderType;
    return event;
  }

  cancelOrderEvent() {
    Map<String, dynamic> body = {
      "af_channel": 'Cancel Order',
    };
    _sendAnalyticsEvent(Platform.isIOS ? 'hphf2g' : '1ka0cl', body);
  }

  customerListEvent() {
    Map<String, dynamic> body = {
      "af_channel": 'Customer List screen',
    };
    _sendAnalyticsEvent(Platform.isIOS ? 'vyflr8' : '3r8irn', body);
  }

  customerReviewsEvent() {
    Map<String, dynamic> body = {
      "af_channel": 'Customer reviews screen',
    };
    _sendAnalyticsEvent(Platform.isIOS ? '2xkhcw' : 'nzido2', body);
  }

  contactCustomerServiceEvent() {
    Map<String, dynamic> body = {
      "af_channel": 'Customer service screen',
    };
    _sendAnalyticsEvent(Platform.isIOS ? 'w8tuu4' : 'o6nidk', body);
  }

  contactServiceSubmitEvent() {
    Map<String, dynamic> body = {
      "af_channel": 'successfully send query',
    };
    _sendAnalyticsEvent(Platform.isIOS ? 'o0lyss' : '3wn83a', body);
  }
//////////////////////////////////////////// END EVENTS ///////////

  Future<void> _sendAnalyticsEvent(
      String eventToken, Map<String, dynamic> body) async {
    AdjustEvent myAdjustEvent = AdjustEvent(eventToken);
    Adjust.trackEvent(myAdjustEvent);
  }

  initPlatformState() async {
    AdjustConfig config = AdjustConfig(
        Platform.isIOS
            ? AppConstants.adjustIosKey
            : AppConstants.adjustAndroidKey,
        AdjustEnvironment.production);
    config.logLevel = AdjustLogLevel.verbose;

    config.attributionCallback = (AdjustAttribution attributionChangedData) {
      // print('[Adjust]: Attribution changed!');

      if (attributionChangedData.trackerToken != null) {
        // print(
        //   '[Adjust]: Tracker token: ${attributionChangedData.trackerToken!}');
      }
      if (attributionChangedData.trackerName != null) {
        //   print('[Adjust]: Tracker name: ${attributionChangedData.trackerName!}');
      }
      if (attributionChangedData.campaign != null) {
        //   print('[Adjust]: Campaign: ${attributionChangedData.campaign!}');
      }
      if (attributionChangedData.network != null) {
        //  print('[Adjust]: Network: ${attributionChangedData.network!}');
      }
      if (attributionChangedData.creative != null) {
        //  print('[Adjust]: Creative: ${attributionChangedData.creative!}');
      }
      if (attributionChangedData.adgroup != null) {
        //  print('[Adjust]: Adgroup: ${attributionChangedData.adgroup!}');
      }
      if (attributionChangedData.clickLabel != null) {
        //   print('[Adjust]: Click label: ${attributionChangedData.clickLabel!}');
      }
      if (attributionChangedData.adid != null) {
        //  print('[Adjust]: Adid: ${attributionChangedData.adid!}');
      }
      if (attributionChangedData.costType != null) {
        //  print('[Adjust]: Cost type: ${attributionChangedData.costType!}');
      }
      if (attributionChangedData.costAmount != null) {
        //  print('[Adjust]: Cost amount: ${attributionChangedData.costAmount!}');
      }
      if (attributionChangedData.costCurrency != null) {
        //  print(
        //  '[Adjust]: Cost currency: ${attributionChangedData.costCurrency!}');
      }
    };

    config.sessionSuccessCallback = (AdjustSessionSuccess sessionSuccessData) {
      //   print('[Adjust]: Session tracking success!');

      if (sessionSuccessData.message != null) {
        //  print('[Adjust]: Message: ${sessionSuccessData.message!}');
      }
      if (sessionSuccessData.timestamp != null) {
        //   print('[Adjust]: Timestamp: ${sessionSuccessData.timestamp!}');
      }
      if (sessionSuccessData.adid != null) {
        //   print('[Adjust]: Adid: ${sessionSuccessData.adid!}');
      }
      if (sessionSuccessData.jsonResponse != null) {
        //  print('[Adjust]: JSON response: ${sessionSuccessData.jsonResponse!}');
      }
    };

    config.sessionFailureCallback = (AdjustSessionFailure sessionFailureData) {
      //  print('[Adjust]: Session tracking failure!');

      if (sessionFailureData.message != null) {
        //   print('[Adjust]: Message: ${sessionFailureData.message!}');
      }
      if (sessionFailureData.timestamp != null) {
        //  print('[Adjust]: Timestamp: ${sessionFailureData.timestamp!}');
      }
      if (sessionFailureData.adid != null) {
        //  print('[Adjust]: Adid: ${sessionFailureData.adid!}');
      }
      if (sessionFailureData.willRetry != null) {
        //   print('[Adjust]: Will retry: ${sessionFailureData.willRetry}');
      }
      if (sessionFailureData.jsonResponse != null) {
        //   print('[Adjust]: JSON response: ${sessionFailureData.jsonResponse!}');
      }
    };

    config.eventSuccessCallback = (AdjustEventSuccess eventSuccessData) {
      //  print('[Adjust]: Event tracking success!');

      if (eventSuccessData.eventToken != null) {
        //  print('[Adjust]: Event token: ${eventSuccessData.eventToken!}');
      }
      if (eventSuccessData.message != null) {
        //  print('[Adjust]: Message: ${eventSuccessData.message!}');
      }
      if (eventSuccessData.timestamp != null) {
        //  print('[Adjust]: Timestamp: ${eventSuccessData.timestamp!}');
      }
      if (eventSuccessData.adid != null) {
        // print('[Adjust]: Adid: ${eventSuccessData.adid!}');
      }
      if (eventSuccessData.callbackId != null) {
        // print('[Adjust]: Callback ID: ${eventSuccessData.callbackId!}');
      }
      if (eventSuccessData.jsonResponse != null) {
        // print('[Adjust]: JSON response: ${eventSuccessData.jsonResponse!}');
      }
    };

    config.eventFailureCallback = (AdjustEventFailure eventFailureData) {
      //  print('[Adjust]: Event tracking failure!');

      if (eventFailureData.eventToken != null) {
        //    print('[Adjust]: Event token: ${eventFailureData.eventToken!}');
      }
      if (eventFailureData.message != null) {
        //   print('[Adjust]: Message: ${eventFailureData.message!}');
      }
      if (eventFailureData.timestamp != null) {
        //  print('[Adjust]: Timestamp: ${eventFailureData.timestamp!}');
      }
      if (eventFailureData.adid != null) {
        //   print('[Adjust]: Adid: ${eventFailureData.adid!}');
      }
      if (eventFailureData.callbackId != null) {
        //  print('[Adjust]: Callback ID: ${eventFailureData.callbackId!}');
      }
      if (eventFailureData.willRetry != null) {
        //  print('[Adjust]: Will retry: ${eventFailureData.willRetry}');
      }
      if (eventFailureData.jsonResponse != null) {
        //  print('[Adjust]: JSON response: ${eventFailureData.jsonResponse!}');
      }
    };

    config.deferredDeeplinkCallback = (String? uri) {
      //   print('[Adjust]: Received deferred deeplink: ${uri!}');
    };

    config.conversionValueUpdatedCallback = (num? conversionValue) {
      //   print('[Adjust]: Received conversion value update: ${conversionValue!}');
    };

    config.skad4ConversionValueUpdatedCallback =
        (num? conversionValue, String? coarseValue, bool? lockWindow) {
      // print('[Adjust]: Received conversion value update!');
      // print('[Adjust]: Conversion value: ${conversionValue!}');
      // print('[Adjust]: Coarse value: ${coarseValue!}');
      // print('[Adjust]: Lock window: ${lockWindow!}');
    };

    // Add session callback parameters.
    Adjust.addSessionCallbackParameter('scp_foo_1', 'scp_bar');
    Adjust.addSessionCallbackParameter('scp_foo_2', 'scp_value');

    // Add session Partner parameters.
    Adjust.addSessionPartnerParameter('spp_foo_1', 'spp_bar');
    Adjust.addSessionPartnerParameter('spp_foo_2', 'spp_value');

    // Remove session callback parameters.
    Adjust.removeSessionCallbackParameter('scp_foo_1');
    Adjust.removeSessionPartnerParameter('spp_foo_1');

    // Clear all session callback parameters.
    Adjust.resetSessionCallbackParameters();

    // Clear all session partner parameters.
    Adjust.resetSessionPartnerParameters();

    // Ask for tracking consent.
    Adjust.requestTrackingAuthorizationWithCompletionHandler().then((status) {
      //  print('[Adjust]: Authorization status update!');
      switch (status) {
        case 0:
          //  print(
          //  '[Adjust]: Authorization status update: ATTrackingManagerAuthorizationStatusNotDetermined');
          break;
        case 1:
          //  print(
          // '[Adjust]: Authorization status update: ATTrackingManagerAuthorizationStatusRestricted');
          break;
        case 2:
          //   print(
          //   '[Adjust]: Authorization status update: ATTrackingManagerAuthorizationStatusDenied');
          break;
        case 3:
          //  print(
          //  '[Adjust]: Authorization status update: ATTrackingManagerAuthorizationStatusAuthorized');
          break;
      }
    });

    // COPPA compliance.
    // config.coppaCompliantEnabled = true;

    // Google Play Store kids apps.
    // config.playStoreKidsAppEnabled = true;

    // Start SDK.
    Adjust.start(config);
  }
}
