import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santra_seller/models/home_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ui/widgets/snackbar/common_snackbar.dart';
import '../../utils/api_data.dart';
import '../../utils/routes/app_routes.dart';
import '../../utils/uidata.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  bool isFilterOrderLoading = false;
  bool isLoading = false;
  bool acceptOrder = false;
  bool rejectOrder = false;
  bool cancelOrder = false;
  String? sellerCode;
  HomeData? homeData;
  String? orderMonthly;
  String? profitMonthly;
  List<Order> allOrders = [];
  List<String> years = [
    '2022',
    '2023',
    '2024',
    '2025',
    '2026',
    '2027',
    '2028',
    '2029',
    '2030'
  ];
  List<String> months = [
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
  String selectedYear = "2023";
  String selectedMonth = "01";
  updateFilterStatus(bool value) {
    isFilterOrderLoading = value;
    update();
  }

  @override
  void onInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sellercode = prefs.getString("sellercode");
    if (sellercode != null) {
      sellerCode = sellercode;
    }
    isLoading = true;
    update();
    homeDataCall();
    update();
    super.onInit();
  }

  Future filterOrder() async {
    try {
      updateFilterStatus(true);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.parse(ApiData.orderFilterApi);
      Map<String, dynamic> body = {};
      body['seller_code'] = prefs.getString("sellercode");
      body['filter_month'] = selectedMonth.toString();
      body['filter_year'] = selectedYear.toString();
      var response = await http.post(url, body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        profitMonthly = data['data'][0]['profit_monthly'];
        orderMonthly = data['data'][0]['orders_monthly'];
        print(response.body);
        print(profitMonthly);
      } else {
        print(response.body);
      }
    } catch (e) {
      CommonSnackbar.getSnackbar(
          "Oops", "Something went wrong", UIDataColors.redColor);
    }
    updateFilterStatus(false);
  }

  homeDataCall() async {
    if (sellerCode != null) {
      isLoading = true;
      update();
      // try {
      var body = <String, String>{};
      body['seller_code'] = sellerCode!;
      var res = await http.post(Uri.parse("${ApiData.mainurl}seller_home"),
          body: body);
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        var newdata = HomeModel.fromJson(data);
        homeData = newdata.data[0];
        allOrders.addAll(homeData!.santraOrders[0].santraOrders);
        allOrders.addAll(homeData!.manualOrders[0].manualOrders);
        allOrders.addAll(homeData!.pendingOrders[0].pendingOrders);
        isLoading = false;
        update();
      } else {
        CommonSnackbar.getSnackbar("Error", "Error ", UIDataColors.redColor);
      }
      // } catch (e) {
      //   print("check error ${e}");
      //   isLoading = false;
      //   update();
      //   // Get.offAllNamed(Routes.homeRoutes);
      //   CommonSnackbar.getSnackbar(
      //       "Server Error",
      //       "Server Error or Please Check your internet connection",
      //       UIDataColors.redColor);
      // }
    }
  }

  Future cancelOrdermethod(String orderNumber) async {
    try {
      cancelOrder = true;
      update();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.parse("${ApiData.mainurl}cancel_order");
      Map<String, dynamic> body = {};
      body['seller_code'] = prefs.getString("sellercode");
      body['order_number'] = orderNumber.toString();
      var response = await http.post(url, body: body);
      if (response.statusCode == 200) {
        cancelOrder = false;
        update();
        // Get.snackbar("Accepted", "Order has been accepted");
        CommonSnackbar.getSnackbar(
            "Accepted", "Order has been cancelled", UIDataColors.primaryColor);
        Get.offAllNamed(Routes.homeRoutes);
        print("Order has been cancelled");
      } else {
        cancelOrder = false;
        update();
        print(response.statusCode.toString());
        print("Unable to cancel order");
      }
    } catch (e) {
      cancelOrder = false;
      update();
      CommonSnackbar.getSnackbar(
          "Oops", "Something went wrong", UIDataColors.redColor);
    }
  }

  Future acceptOrdermethod(String orderNumber) async {
    try {
      acceptOrder = true;
      update();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.parse("${ApiData.mainurl}accept_order");
      Map<String, dynamic> body = {};
      body['seller_code'] = prefs.getString("sellercode");
      body['order_number'] = orderNumber.toString();
      var response = await http.post(url, body: body);
      if (response.statusCode == 200) {
        acceptOrder = false;
        update();
        // Get.snackbar("Accepted", "Order has been accepted");
        CommonSnackbar.getSnackbar(
            "Accepted", "Order has been accepted", UIDataColors.primaryColor);
        Get.offAllNamed(Routes.homeRoutes);
        print("Order has been Accepted");
      } else {
        acceptOrder = false;
        update();
        print(response.statusCode.toString());
        print("Unable to accept order");
      }
    } catch (e) {
      acceptOrder = false;
      update();
      CommonSnackbar.getSnackbar(
          "Oops", "Something went wrong", UIDataColors.redColor);
    }
  }

  Future rejectOrderMethod(String orderNumber) async {
    rejectOrder = true;
    update();
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.parse("${ApiData.mainurl}reject_order");
      Map<String, dynamic> body = {};
      body['seller_code'] = prefs.getString("sellercode");
      body['order_number'] = orderNumber.toString();
      var response = await http.post(url, body: body);
      if (response.statusCode == 200) {
        rejectOrder = false;
        update();

        CommonSnackbar.getSnackbar(
            "Rejected", "Order has been Rejected ", UIDataColors.primaryColor);
        Get.offAllNamed(Routes.homeRoutes);
      } else {
        rejectOrder = false;
        update();
        // print(response.statusCode);
        // print("Unable to reject order");
      }
    } catch (e) {
      rejectOrder = false;
      update();

      CommonSnackbar.getSnackbar(
          "Oops", "Something went wrong", UIDataColors.redColor);
    }
  }

  Color getColor(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'new_order':
        return Color(0xff0098B1);
      case 'payment_pending':
        return Color(0xff7B7B7B);
      case 'assigned_3pl':
        return Color(0xff265198);
      case 'devliered':
        return Color(0xff01957A);
      case 'canceled':
        return Color(0xffC23C4C);
      case 'rejected':
        return Color(0xffC23C4C);
      default:
        return Color(0xff0098B1);
    }
  }

  String getStatus(String status) {
    switch (status.toLowerCase()) {
      case 'new_order':
        return 'New Order';
      case 'payment_pending':
        return 'Pending Payment';
      case 'assigned_3pl':
        return 'Pending Delivery';
      case 'devliered':
        return 'Delivered';
      case 'canceled':
        return 'Cancelled';
      case 'rejected':
        return 'Rejected';
      case 'accepted':
        return 'Accepted';
      case 'order_ready':
        return 'Order Ready';
      default:
        return status;
    }
  }
}
