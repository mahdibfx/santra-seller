import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santra_seller/models/home_model.dart';
import 'package:santra_seller/ui/screens/home_page/home_screen.dart';
import 'package:santra_seller/ui/widgets/dialogs/custom_dialogs.dart';
import 'package:santra_seller/utils/app_translation/app_translation.dart';
import 'package:santra_seller/utils/ext.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import '../../ui/widgets/snackbar/common_snackbar.dart';
import '../../utils/api_data.dart';
import '../../utils/uidata.dart';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';

class HomeProvider extends ChangeNotifier {
  final BuildContext context;
  HomeProvider(this.context);
  TextEditingController filterController = TextEditingController();
  var isFilterOrderLoading = false;
  bool isLoading = true;
  bool isAcceptOrderLoading = false;
  bool isRejectOrderLoading = false;
  bool isOrderReadyLoading = false;
  bool isCancelOrderLoading = false;
  List<Order> santraOrders = [];
  List<MultiBranchData> multiBranches = [];
  List<String> branchesNameEn = [];
  List<String> branchesNameAr = [];
  List<Order> filteredSantraOrders = [];
  List<Order> pendingOrders = [];
  List<Order> filteredPendingOrders = [];
  List<Order> manualOrders = [];
  List<Order> filteredManualOrders = [];
  List<Order> allOrders = [];
  List<Order> filteredAllOrders = [];
  String? selectedBranch;
  String? branchSellerCode;

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

  setBranchSellerCode(val) {
    int index = branchesNameEn.indexOf(val);
    branchSellerCode = multiBranches[index].sellerCode;
    selectedBranch = val;
    print(branchSellerCode);
    print(selectedBranch);
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

  getBranchName() {
    if (multiBranches.isNotEmpty) {
      branchesNameEn = multiBranches.map((data) => data.sellerTitle).toList();
      branchesNameAr = multiBranches.map((data) => data.sellerTitleAr).toList();
      selectedBranch = branchesNameEn.elementAt(0);
    }
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
    getBranchName();
    notifyListeners();
  }

  void onDispose() {
    branchSellerCode = null;
    selectedBranch = null;
  }

  Future<bool> isInternetAvailable() async {
    var tr = Get.put(AppTranslations());
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final response = await http.get(Uri.parse('https://google.com'));
        return response.statusCode == HttpStatus.ok;
      }
    } on SocketException catch (_) {
      customOntapDialog(tr.translateData("val_no_internet"),
          tr.translateData("no_internet_msg"), tr.translateData("okay"), () {
        Get.back();
      });
      // CommonSnackbar.getSnackbar(
      //     "Error", "Internet is not available ", UIDataColors.redColor);
      return false;
    }
    return false;
  }

  Future filterOrder() async {
    var tr = Get.put(AppTranslations());
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
      CommonSnackbar.getSnackbar(tr.translateData("oops_message"),
          tr.translateData("went_wrong"), UIDataColors.redColor);
    }
  }

  homeDataCall() async {
    var tr = Get.put(AppTranslations());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    allOrders = [];
    notifyListeners();
    if (sellerCode != null) {
      isLoading = true;
      notifyListeners();
      try {
        var body = <String, String>{};
        body['seller_code'] = sellerCode!;
        var res = await http.post(
            Uri.parse("${ApiData.mainurl}new_seller_home"),
            headers: ApiData.header,
            body: body);

        if (res.statusCode == 200) {
          var data = jsonDecode(res.body);
          var newdata = HomeModel.fromJson(data);
          AppConstants.homeModel = newdata;
          sellerStatusNew = data['data'][0]['seller_status'];
          prefs.setString("sellerStatus", sellerStatusNew.toString());
          res.body.debugPrint();
          debugPrint(res.body);
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
          multiBranches = homeData?.multiBranch ?? [];
          filteredAllOrders = allOrders;
          isLoading = false;
          notifyListeners();
        } else {
          CommonSnackbar.getSnackbar(
              tr.translateData("error_message"),
              tr.translateData("something_wrong_message"),
              UIDataColors.redColor);
        }
      } catch (e) {
        isLoading = false;
        notifyListeners();

        CommonSnackbar.getSnackbar(tr.translateData("serve_error"),
            tr.translateData("serve_error_internet"), UIDataColors.redColor);
      }
    }
  }

  Future cancelOrdermethod(String orderNumber) async {
    var tr = Get.put(AppTranslations());
    try {
      updateCancelOrderLoading(true);
      notifyListeners();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.parse("${ApiData.mainurl}cancel_order");
      Map<String, dynamic> body = {};
      body['seller_code'] = prefs.getString("sellercode");
      body['order_number'] = orderNumber.toString();
      var response = await http.post(url, headers: ApiData.header, body: body);
      log(response.body.toString());

      if (response.statusCode == 200) {
        notifyListeners();
        // Get.snackbar("Accepted", "Order has been accepted");
        CommonSnackbar.getSnackbar(tr.translateData("cancelled"),
            tr.translateData("order_cancelled"), UIDataColors.primaryColor);
        Get.offAll(() => const HomeScreen());
        // Get.offAllNamed(Routes.homeRoutes);
      } else {
        exceptionDialog("OOPS !",jsonDecode( response.body)['data']['message']);
        notifyListeners();
      }
    } catch (e) {
      log(e.toString());
      notifyListeners();
      CommonSnackbar.getSnackbar(tr.translateData("oops_message"),
          tr.translateData("went_wrong"), UIDataColors.redColor);
    }
    updateCancelOrderLoading(false);
  }

  Future acceptOrdermethod(
      String orderNumber, String orderType, String orderPrice) async {
    var tr = Get.put(AppTranslations());
    try {
      updateAcceptOrderLoading(true);
      notifyListeners();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.parse("${ApiData.mainurl}accept_order_new");
      Map<String, dynamic> body = {};
      body['seller_code'] = prefs.getString("sellercode");
      body['seller_code_accepted'] =
          branchSellerCode ?? prefs.getString("sellercode");
      body['order_number'] = orderNumber;

      var response = await http.post(url, headers: ApiData.header, body: body);
      if (response.statusCode == 200) {
        CommonSnackbar.getSnackbar(tr.translateData("status_accepted"),
            tr.translateData("order_accepted_msg"), UIDataColors.primaryColor);

        notifyListeners();
        // Get.snackbar("Accepted", "Order has been accepted");

        // Get.offAllNamed(Routes.homeRoutes);
        Get.offAll(() => const HomeScreen());
      } else {
        generalException();
        notifyListeners();
      }
    } catch (e) {
      notifyListeners();
      CommonSnackbar.getSnackbar(tr.translateData("oops_message"),
          tr.translateData("went_wrong"), UIDataColors.redColor);
    }
    updateAcceptOrderLoading(false);
  }

  Future rejectOrderMethod(String orderNumber) async {
    var tr = Get.put(AppTranslations());
    updateRejectOrderLoading(true);
    notifyListeners();
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.parse("${ApiData.mainurl}reject_order");
      Map<String, dynamic> body = {};
      body['seller_code'] = branchSellerCode ?? prefs.getString("sellercode");
      body['order_number'] = orderNumber.toString();
      var response = await http.post(url, headers: ApiData.header, body: body);
      if (response.statusCode == 200) {
        notifyListeners();

        CommonSnackbar.getSnackbar(tr.translateData("status_rejected"),
            tr.translateData("rejected_order"), UIDataColors.primaryColor);
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

      CommonSnackbar.getSnackbar(tr.translateData("oops_message"),
          tr.translateData("went_wrong"), UIDataColors.redColor);
    }
    updateRejectOrderLoading(false);
  }

  Future readyOrderMethod(String orderNumber) async {
    updateOrderReadyLoading(true);
    var tr = Get.put(AppTranslations());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.parse("${ApiData.mainurl}order_ready");
      Map<String, dynamic> body = {};
      body['seller_code'] = prefs.getString("sellercode");
      body['order_number'] = orderNumber.toString();
      var response = await http.post(url, headers: ApiData.header, body: body);
      if (response.statusCode == 200) {
        CommonSnackbar.getSnackbar(tr.translateData("success_message"),
            tr.translateData("order_ready_msg"), UIDataColors.primaryColor);
        Get.offAll(() => const HomeScreen());
      } else {
        generalException();

        // print(response.statusCode);
        // print("Unable to reject order");
      }
    } catch (e) {
      CommonSnackbar.getSnackbar(tr.translateData("oops_message"),
          tr.translateData("went_wrong"), UIDataColors.redColor);
    }
    updateOrderReadyLoading(false);
    notifyListeners();
  }

  Future<bool> contract() async {
    updateOrderReadyLoading(true);
    isLoading = true;
    var tr = Get.put(AppTranslations());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.parse(ApiData.contract);
      Map<String, dynamic> body = {};
      body['seller_code'] = prefs.getString("sellercode");
      body['status_accepted'] = "yes";
      var response = await http.post(url, headers: ApiData.header, body: body);
      isLoading = false;
      if (response.statusCode == 200) {
        CommonSnackbar.getSnackbar(tr.translateData("success_message"),
            tr.translateData("okay"), UIDataColors.primaryColor);
        AppConstants.homeModel.data.first.showContract = "no";
        updateOrderReadyLoading(false);
        notifyListeners();
        return true;
      } else {
        generalException();
        // print(response.statusCode);
        // print("Unable to reject order");
        updateOrderReadyLoading(false);
        notifyListeners();
        return false;
      }
    } catch (e) {
      isLoading = false;
      CommonSnackbar.getSnackbar(tr.translateData("oops_message"),
          tr.translateData("went_wrong"), UIDataColors.redColor);
      updateOrderReadyLoading(false);
      notifyListeners();
      return false;
    }
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

  String getArabicPaymentMethod(String paymentName) {
    var tr = Get.put(AppTranslations());
    switch (paymentName.toLowerCase()) {
      case 'online_paid':
        return tr.translateData("payment_online_paid");
      case 'cash':
        return tr.translateData("payment_cash");
      default:
        return tr.translateData("payment_card");
    }
  }

  String getEnglishPaymentMethod(String paymentName) {
    var tr = Get.put(AppTranslations());
    switch (paymentName.toLowerCase()) {
      case 'online_paid':
        return tr.translateData("payment_online_paid");
      case 'cash':
        return tr.translateData("payment_cash");
      default:
        return tr.translateData("payment_card");
    }
  }

  String getStatus(String status) {
    var tr = Get.put(AppTranslations());
    switch (status.toLowerCase()) {
      case 'new_order':
        return tr.translateData('status_new_order');
      case 'payment_pending':
        return tr.translateData('status_pending_payment');
      case 'assigned_3pl':
        return tr.translateData('status_pending_delivery');
      case 'devliered':
        return tr.translateData('status_delivered');
      case 'canceled':
        return tr.translateData('status_canceled_order');
      case 'rejected':
        return tr.translateData('status_rejected');
      case 'accepted':
        return tr.translateData('status_accepted');
      case 'order_ready':
        return tr.translateData('status_ready');
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

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> launchAttachedPdf(String link) async {
    String l = link.substring(7);
    final Uri launchUri = Uri(
      scheme: 'https',
      path: l,
    );
    await launchUrl(
      launchUri,
      mode: LaunchMode.externalApplication,
    );
  }
}
