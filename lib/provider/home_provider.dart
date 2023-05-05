import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santra_seller/models/home_model.dart';
import 'package:santra_seller/ui/screens/home_page/home_screen.dart';
import 'package:santra_seller/ui/widgets/dialogs/custom_dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../../ui/widgets/snackbar/common_snackbar.dart';
import '../../utils/api_data.dart';
import '../../utils/uidata.dart';
import 'package:http/http.dart' as http;

class HomeProvider extends ChangeNotifier {
  TextEditingController filterController = TextEditingController();
  var isFilterOrderLoading = false;
  bool isLoading = true;
  bool isAcceptOrderLoading = false;
  bool isRejectOrderLoading = false;
  bool isOrderReadyLoading = false;
  bool isCancelOrderLoading = false;
  List<Order> santraOrders = [];
  List<Order> filteredSantraOrders = [];
  List<Order> pendingOrders = [];
  List<Order> filteredPendingOrders = [];
  List<Order> manualOrders = [];
  List<Order> filteredManualOrders = [];
  List<Order> allOrders = [];
  List<Order> filteredAllOrders = [];

  String selectedOrderOption = '';

  String? sellerCode;
  HomeData? homeData;
  var orderMonthly = '0';
  var profitMonthly = '0';

  String newOrderSantraCount = '0';

  var sellerStatusNew;
  List<String> years = [
    'Year',
    '2022',
    '2023',
    '2024',
    '2025',
  ];
  List<String> months = [
    'Month',
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12'
  ];
  var selectedYear = 'Year';
  var selectedMonth = 'Month';
  updateCancelOrderLoading(bool value) {
    isCancelOrderLoading = value;
    notifyListeners();
  }

  updateAcceptOrderLoading(bool value) {
    isAcceptOrderLoading = value;
    notifyListeners();
  }

  updateOrderReadyLoading(bool value) {
    isOrderReadyLoading = value;
    notifyListeners();
  }

  updateRejectOrderLoading(bool value) {
    isRejectOrderLoading = value;
    notifyListeners();
  }

  void onInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sellercode = prefs.getString("sellercode");
    if (sellercode != null) {
      sellerCode = sellercode;
    }
    isLoading = true;
    notifyListeners();
    isInternetAvailable();
    sellerSt();
    await homeDataCall();
    notifyListeners();
  }

  Future<bool> isInternetAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final response = await http.get(Uri.parse('https://google.com'));
        return response.statusCode == HttpStatus.ok;
      }
    } on SocketException catch (_) {
      customOntapDialog(
          "No Internet", "Looks like you are not connected to internet", "okay".tr,
          () {
        Get.back();
      });
      // CommonSnackbar.getSnackbar(
      //     "Error", "Internet is not available ", UIDataColors.redColor);
      return false;
    }
    return false;
  }

  Future filterOrder() async {
    try {
      isFilterOrderLoading = true;
      notifyListeners();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.parse(ApiData.orderFilterApi);
      Map<String, dynamic> body = {};
      body['seller_code'] = prefs.getString("sellercode");
      body['filter_month'] = selectedMonth;
      body['filter_year'] = selectedYear;
      var response = await http.post(url, headers: ApiData.header, body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        profitMonthly = data['data'][0]['profit_monthly'];
        orderMonthly = data['data'][0]['orders_monthly'];
        isFilterOrderLoading = false;
        notifyListeners();
      } else {
        generalException();
      }
    } catch (e) {
      CommonSnackbar.getSnackbar(
          "oops_message".tr, "went_wrong".tr, UIDataColors.redColor);
    }
  }

  homeDataCall() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    allOrders = [];
    notifyListeners();
    if (sellerCode != null) {
      isLoading = true;
      notifyListeners();
      try {
        var body = <String, String>{};
        body['seller_code'] = sellerCode!;
        var res = await http.post(Uri.parse("${ApiData.mainurl}seller_home"),
            headers: ApiData.header, body: body);

        if (res.statusCode == 200) {
          var data = jsonDecode(res.body);
          var newdata = HomeModel.fromJson(data);
          sellerStatusNew = data['data'][0]['seller_status'];
          prefs.setString("sellerStatus", sellerStatusNew.toString());
          print("SEEEEEEE $sellerStatusNew");
          print(res.body);
          homeData = newdata.data[0];
          allOrders.addAll(homeData!.santraOrders[0].santraOrders);
          allOrders.addAll(homeData!.manualOrders[0].manualOrders);
          // allOrders.addAll(homeData!.pendingOrders[0].pendingOrders);
          newOrderSantraCount = data['data'][0]['santra_orders'][0]
                  ['order_count_notification']
              .toString();
          santraOrders = homeData!.santraOrders[0].santraOrders;
          filteredSantraOrders = santraOrders;
          pendingOrders = homeData!.pendingOrders[0].pendingOrders;
          filteredPendingOrders = pendingOrders;
          manualOrders = homeData!.manualOrders[0].manualOrders;
          filteredManualOrders = manualOrders;
          filteredAllOrders = allOrders;
          isLoading = false;
          notifyListeners();
          print(newOrderSantraCount);
        } else {
          CommonSnackbar.getSnackbar("error_message".tr,
              "something_wrong_message".tr, UIDataColors.redColor);
        }
      } catch (e) {
        isLoading = false;
        notifyListeners();

        CommonSnackbar.getSnackbar(
            "serve_error".tr,
            "serve_error_internet".tr,
            UIDataColors.redColor);
      }
    }
  }

  Future cancelOrdermethod(String orderNumber) async {
    try {
      updateCancelOrderLoading(true);
      notifyListeners();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.parse("${ApiData.mainurl}cancel_order");
      Map<String, dynamic> body = {};
      body['seller_code'] = prefs.getString("sellercode");
      body['order_number'] = orderNumber.toString();
      var response = await http.post(url, headers: ApiData.header, body: body);
      if (response.statusCode == 200) {
        notifyListeners();
        // Get.snackbar("Accepted", "Order has been accepted");
        CommonSnackbar.getSnackbar(
            "cancelled".tr, "order_cancelled".tr, UIDataColors.primaryColor);
        Get.offAll(() => const HomeScreen());
        // Get.offAllNamed(Routes.homeRoutes);
      } else {
        generalException();
        notifyListeners();
      }
    } catch (e) {
      notifyListeners();
      CommonSnackbar.getSnackbar(
          "oops_message".tr, "went_wrong".tr, UIDataColors.redColor);
    }
    updateCancelOrderLoading(false);
  }

  Future acceptOrdermethod(String orderNumber) async {
    try {
      updateAcceptOrderLoading(true);
      notifyListeners();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.parse("${ApiData.mainurl}accept_order");
      Map<String, dynamic> body = {};
      body['seller_code'] = prefs.getString("sellercode");
      body['order_number'] = orderNumber.toString();
      var response = await http.post(url, headers: ApiData.header, body: body);
      if (response.statusCode == 200) {
        notifyListeners();
        // Get.snackbar("Accepted", "Order has been accepted");
        CommonSnackbar.getSnackbar(
            "Accepted", "Order has been accepted", UIDataColors.primaryColor);
        // Get.offAllNamed(Routes.homeRoutes);
        Get.offAll(() => const HomeScreen());
      } else {
        generalException();
        notifyListeners();
      }
    } catch (e) {
      notifyListeners();
      CommonSnackbar.getSnackbar(
          "oops_message".tr, "went_wrong".tr, UIDataColors.redColor);
    }
    updateAcceptOrderLoading(false);
  }

  Future rejectOrderMethod(String orderNumber) async {
    updateRejectOrderLoading(true);
    notifyListeners();
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.parse("${ApiData.mainurl}reject_order");
      Map<String, dynamic> body = {};
      body['seller_code'] = prefs.getString("sellercode");
      body['order_number'] = orderNumber.toString();
      var response = await http.post(url, headers: ApiData.header, body: body);
      if (response.statusCode == 200) {
        notifyListeners();

        CommonSnackbar.getSnackbar(
            "status_rejected".tr, "rejected_order".tr, UIDataColors.primaryColor);
        // Get.offAllNamed(Routes.homeRoutes);
        Get.offAll(() => const HomeScreen());
      } else {
        generalException();
        notifyListeners();
        // print(response.statusCode);
        // print("Unable to reject order");
      }
    } catch (e) {
      notifyListeners();

      CommonSnackbar.getSnackbar(
          "oops_message".tr, "went_wrong".tr, UIDataColors.redColor);
    }
    updateRejectOrderLoading(false);
  }

  Future readyOrderMethod(String orderNumber) async {
    updateOrderReadyLoading(true);

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.parse("${ApiData.mainurl}order_ready");
      Map<String, dynamic> body = {};
      body['seller_code'] = prefs.getString("sellercode");
      body['order_number'] = orderNumber.toString();
      var response = await http.post(url, headers: ApiData.header, body: body);
      if (response.statusCode == 200) {
        CommonSnackbar.getSnackbar("success_message".tr, "Order has been marked as ready",
            UIDataColors.primaryColor);
        Get.offAll(() => const HomeScreen());
      } else {
        generalException();

        // print(response.statusCode);
        // print("Unable to reject order");
      }
    } catch (e) {
      CommonSnackbar.getSnackbar(
          "oops_message".tr, "went_wrong".tr, UIDataColors.redColor);
    }
    updateOrderReadyLoading(false);
    notifyListeners();
  }

  //////////////////////////////--------Filteration START--------///////////
  bool _doesActionSatisfy(Order e, String query) {
    bool found = e.orderNumber.toString().toLowerCase().contains(query) &&
        e.orderStatus.toString().toLowerCase().contains(selectedOrderOption);

    return found;
  }

  checkfilterCondition() {
    santraOrders.where((e) {
      bool matchesCondition1 = e.orderNumber
          .toString()
          .toLowerCase()
          .contains(filterController.text.trim());
      bool matchesCondition2 =
          e.orderStatus.toString().toLowerCase().contains(selectedOrderOption);
      return matchesCondition1 && matchesCondition2;
    }).toList();
  }

  void filterSantraOrders() {
    var valueList = santraOrders
        .where((e) =>
            e.orderNumber.contains(filterController.text.trim().toLowerCase()))
        .toList();
    filteredSantraOrders = valueList
        .where((e) => e.orderStatus
            .toString()
            .toLowerCase()
            .contains(selectedOrderOption))
        .toList();
    notifyListeners();
  }

  void filterPendingOrders() {
    var valueList = pendingOrders
        .where((e) =>
            e.orderNumber.contains(filterController.text.trim().toLowerCase()))
        .toList();
    filteredPendingOrders = valueList
        .where((e) => e.orderStatus
            .toString()
            .toLowerCase()
            .contains(selectedOrderOption))
        .toList();
    notifyListeners();
  }

  void filtermanualOrders() {
    var valueList = manualOrders
        .where((e) =>
            e.orderNumber.contains(filterController.text.trim().toLowerCase()))
        .toList();
    filteredManualOrders = valueList
        .where((e) => e.orderStatus
            .toString()
            .toLowerCase()
            .contains(selectedOrderOption))
        .toList();
    notifyListeners();
  }

  void filterAllOrders() {
    var valueList = allOrders
        .where((e) =>
            e.orderNumber.contains(filterController.text.trim().toLowerCase()))
        .toList();
    filteredAllOrders = valueList
        .where((e) => e.orderStatus
            .toString()
            .toLowerCase()
            .contains(selectedOrderOption))
        .toList();
    notifyListeners();
  }

  changeOrderGroupValue(value) {
    selectedOrderOption = value;
    notifyListeners();
    filterSantraOrders();
    filterPendingOrders();
    filtermanualOrders();
    filterAllOrders();
  }

  resetOrderGroupValue() {
    selectedOrderOption = '';
    filterController.clear();
    notifyListeners();
    filterSantraOrders();
    filterPendingOrders();
    filtermanualOrders();
    filterAllOrders();
  }

//////////////////////////////--------Filteration END--------///////////

  Color getColor(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'new_order':
        return const Color(0xff0098B1);
      case 'payment_pending':
        return const Color(0xff7B7B7B);
      case 'assigned_3pl':
        return const Color(0xff265198);
      case 'devliered':
        return const Color(0xff01957A);
      case 'canceled':
        return const Color(0xffC23C4C);
      case 'rejected':
        return const Color(0xffC23C4C);
      default:
        return const Color(0xff0098B1);
    }
  }

  String getStatus(String status) {
    switch (status.toLowerCase()) {
      case 'new_order':
        return 'status_new_order'.tr;
      case 'payment_pending':
        return 'status_pending_payment'.tr;
      case 'assigned_3pl':
        return 'status_pending_delivery'.tr;
      case 'devliered':
        return 'status_delivered'.tr;
      case 'canceled':
        return 'status_canceled_order'.tr;
      case 'rejected':
        return 'status_rejected'.tr;
      case 'accepted':
        return 'status_accepted'.tr;
      case 'order_ready':
        return 'status_ready'.tr;
      default:
        return status;
    }
  }

  sellerSt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sellerStatusNew = prefs.getString('sellerStatus');
    notifyListeners();
    print(sellerStatusNew);
  }
}
