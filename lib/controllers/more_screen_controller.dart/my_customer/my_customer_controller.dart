import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santra_seller/models/customers/view_all_customers.dart';
import 'package:santra_seller/ui/widgets/dialogs/custom_dialogs.dart';
import 'package:santra_seller/utils/api_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyCustomerController extends GetxController {
  bool isViewCustomerLoading = false;
  bool hasViewCustomerError = false;
  late ViewAllCustomers viewAllCustomers;
  String? city = '';
  bool isAddCustomerLoading = false;
  bool isUpdateCustomerLoading = false;
  final formEdit = GlobalKey<FormState>();
  final form = GlobalKey<FormState>();
  RegExp emailRegex = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );
  updateCustomerLoadingState(bool value) {
    isViewCustomerLoading = value;
    update();
  }

  TextEditingController fnController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController buildingController = TextEditingController();
  TextEditingController aptController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  updateAddLoadingState(bool value) {
    isAddCustomerLoading = value;
    update();
  }

  updateLoadingState(bool value) {
    isUpdateCustomerLoading = value;
    update();
  }

  Future updateCustomer() async {
    if (form.currentState!.validate()) {
      try {
        updateLoadingState(true);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? sellerCode = prefs.getString("sellercode");
        var url = Uri.parse(ApiData.addCustomer);
        var request = http.MultipartRequest('POST', url);
        var body = <String, String>{};
        body['seller_code'] = sellerCode ?? "";
        body['customer_name'] = fnController.text;
        body['customer_mobile'] = mobileController.text;
        body['customer_email'] = emailController.text;
        body['customer_city'] = "formatteUserDob.toString()";
        body['building_number'] = buildingController.text;
        body['building_type'] = aptController.text;
        body['address_link'] = addressController.text;
        request.fields.addAll(body);
        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);
        if (response.statusCode == 200) {
          ///Success
        } else {
          generalException();
        }
      } catch (err) {
        generalException();
      }
    }
    updateLoadingState(false);
    update();
  }

  Future addCustomer() async {
    if (form.currentState!.validate()) {
      try {
        updateLoadingState(true);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? sellerCode = prefs.getString("sellercode");
        var url = Uri.parse(ApiData.addCustomer);
        var request = http.MultipartRequest('POST', url);
        var body = <String, String>{};
        body['seller_code'] = sellerCode ?? "";
        body['customer_name'] = fnController.text;
        body['customer_mobile'] = mobileController.text;
        body['customer_email'] = emailController.text;
        body['customer_city'] = "formatteUserDob.toString()";
        body['building_number'] = buildingController.text;
        body['building_type'] = aptController.text;
        body['address_link'] = addressController.text;
        request.fields.addAll(body);
        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);
        if (response.statusCode == 200) {
          ///Success
        } else {
          generalException();
        }
      } catch (err) {
        generalException();
      }
    }
    updateLoadingState(false);
    update();
  }

  Future viewCustomers() async {
    try {
      updateCustomerLoadingState(true);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sellerCode = prefs.getString("sellercode");
      var url = Uri.parse(ApiData.customerListApi);
      Map<String, dynamic> body = {};
      body['seller_code'] = "190";
      var response = await http.post(url, body: body);
      if (response.statusCode == 200) {
        // var data = jsonDecode(response.body);
        viewAllCustomers = viewAllCustomersFromJson(response.body);
      } else {
        hasViewCustomerError = true;
      }
    } catch (e) {
      generalException();
    }
    updateCustomerLoadingState(false);
  }

  @override
  void onInit() async {
    super.onInit();
    viewAllCustomers = ViewAllCustomers();
    viewCustomers();
    update();
  }
}
