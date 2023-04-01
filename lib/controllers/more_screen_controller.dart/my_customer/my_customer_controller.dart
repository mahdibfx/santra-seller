import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santra_seller/models/customers/view_all_customers.dart';
import 'package:santra_seller/ui/widgets/dialogs/custom_dialogs.dart';
import 'package:santra_seller/utils/api_data.dart';
import 'package:santra_seller/utils/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../models/customers/delivery_charges.dart';
import '../../cart_controller/cart_controller.dart';

class MyCustomerController extends GetxController {

  final cartdController = Get.find<CartController>();
  
  TextEditingController link = TextEditingController();
  bool isViewCustomerLoading = false;
  bool hasViewCustomerError = false;
  late ViewAllCustomers viewAllCustomers;
  List<String>? citiesList = [];
  String? city = 'Dubai';
  List<Customer>? allCustomers = [];
  bool isAddCustomerLoading = false;
  bool isUpdateCustomerLoading = false;
  bool receiptPaymentMethord = true;
  dynamic finalSubmitData;
  String? cidForUpdate;
  bool popupPaymentlink = false;
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

  void disposeValues() {
    city = "Dubai";
    fnController.clear();
    mobileController.clear();
    emailController.clear();
    buildingController.clear();
    aptController.clear();
    addressController.clear();
    cidForUpdate = null;
    update();
  }

  setValuesForEdit(index) {
    cidForUpdate = allCustomers?[index].id;
    fnController.text = allCustomers?[index].customerName ?? "";
    mobileController.text = allCustomers?[index].customerMobile ?? "";
    emailController.text = allCustomers?[index].customerEmail ?? "";
    buildingController.text = allCustomers?[index].buildingNumber ?? "";
    aptController.text = allCustomers?[index].buildingType ?? "";
    addressController.text = allCustomers?[index].addressLink ?? "";
    city = allCustomers?[index].customerCity ?? "";
    update();
  }

  Future updateCustomer() async {
    try {
      updateLoadingState(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sellerCode = prefs.getString("sellercode");
      var url = Uri.parse(ApiData.updateCustomer);
      var request = http.MultipartRequest('POST', url);
      var body = <String, String>{};
      body['seller_code'] = sellerCode ?? "";
      body['customer_id'] = cidForUpdate.toString();
      body['customer_name'] = fnController.text;
      body['customer_mobile'] = mobileController.text;
      body['customer_email'] = emailController.text;
      body['customer_city'] = city ?? "";
      body['building_number'] = buildingController.text;
      body['building_type'] = aptController.text;
      body['address_link'] = addressController.text;
      request.fields.addAll(body);
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        disposeValues();
        Get.toNamed(Routes.mycustomerscreen);
        viewCustomers();
      } else {
        generalException();
      }
    } catch (err) {
      generalException();
    }

    updateLoadingState(false);
    update();
  }

  Future addCustomer() async {
    try {
      updateAddLoadingState(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sellerCode = prefs.getString("sellercode");
      var url = Uri.parse(ApiData.addCustomer);
      var request = http.MultipartRequest('POST', url);
      var body = <String, String>{};
      body['seller_code'] = sellerCode ?? "";
      body['customer_name'] = fnController.text;
      body['customer_mobile'] = mobileController.text;
      body['customer_email'] = emailController.text;
      body['customer_city'] = city ?? "";
      body['building_number'] = buildingController.text;
      body['building_type'] = aptController.text;
      body['address_link'] = addressController.text;
      request.fields.addAll(body);
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        disposeValues();
        Get.toNamed(Routes.mycustomerscreen);
        viewCustomers();
      } else {
        generalException();
      }
    } catch (err) {
      generalException();
    }

    updateAddLoadingState(false);
    update();
  }

  Future viewCustomers() async {
    try {
      updateCustomerLoadingState(true);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sellerCode = prefs.getString("sellercode");
      var url = Uri.parse(ApiData.customerListApi);
      Map<String, dynamic> body = {};
      body['seller_code'] = sellerCode;
      var response = await http.post(url, body: body);
      if (response.statusCode == 200) {
        var decodedJson = jsonDecode(response.body);
        var data = ViewAllCustomers.fromJson(decodedJson);
        allCustomers = data.data?[0].customers?.toList();
        citiesList = data.data?[0].cities?.toList();
        viewAllCustomers = viewAllCustomersFromJson(response.body);
      } else {
        hasViewCustomerError = true;
      }
    } catch (e) {
      generalException();
    }
    updateCustomerLoadingState(false);
  }

    Future<bool> customerInfoSubmitedRequest(Customer customerDetail) async {
    try {
      updateCustomerLoadingState(true);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sellerCode = prefs.getString("sellercode");
      var url = Uri.parse(ApiData.deliveryCharges);
      Map<String, dynamic> body = {};
      body['seller_code'] = sellerCode;
      var response = await http.post(url, body: body);
      if (response.statusCode == 200) {
        var decodedJson = jsonDecode(response.body);
        var data = DeliveryChargesModel.fromJson(decodedJson);
      
        updateCustomerLoadingState(false);
        if (receiptPaymentMethord) {
             cartdController.addItemForCustomer(data, customerDetail, sellerCode, receiptPaymentMethord);
              showToast("Success",'Submitted Request');
             return false;
             
        } else {
         return await addItemForCustomer(data, customerDetail, sellerCode,);
          //  _.customerInfoSubmitedRequest(customerDetail!);
        }
  
      } else {
         showToast("Failed",'Unable to proceed');
        hasViewCustomerError = true;
            updateCustomerLoadingState(false);
         return false;
      }
      
    } catch (e) {
       showToast("Failed", "Try again later, Unable to proceed");
      generalException();
          updateCustomerLoadingState(false);
      return false;
    }
  }

        Future<bool> orderSubmit() async {
    try {
      updateCustomerLoadingState(true);
      var url = Uri.parse(ApiData.generateLink);
      var response = await http.post(url, body: finalSubmitData);
      if (response.statusCode == 200) {
        // var decodedJson = jsonDecode(response.body);
        // var data = SelllerAllProductsModel.fromJson(decodedJson);
        // if (data.data![0].products!.isNotEmpty) {
        //   allProducts = data.data?[0].products;
        // }
        // selllerAllProductsModel =
        //     selllerAllProductsModelFromJson(response.body);
        // update();
        link.text =  "asdasdasdasdasdas";
         updateCustomerLoadingState(false);
          popupPaymentlink = true;
          return true;
      } else {
          showToast("Failed", 'Unable to proceed');
        // hasError = true;
          updateCustomerLoadingState(false);
          return false;
      }
     

    } catch (e) {
          showToast("Failed", 'Try again later, Unable to proceed');
      // generalException();
      // hasError = true;
         updateCustomerLoadingState(false);
          return false;
    }
 
  }

  Future<bool> addItemForCustomer(DeliveryChargesModel data, Customer customerDetail, String? sellerCode) async {

    finalSubmitData  = {
      "customer_name": customerDetail.customerName, // This is the name of the customer
      "coupn_code": "0", // coupon code if any other wise send 0
      "sub_total": "${cartdController.totalPrice}", // This is the subtotal amount
      "total_delivery_charges": data.data?.first.deliveryCharges, //this is the delivery charges
      "total_discount": "0", //this is the discount if any otherwise send 0
      "d_reason": "no_discount", // If there is any discount otherwise send no_discount
      "d_type": "no_discount", //this is discount type otherwise send no_discount
      "seller_code": sellerCode, // this is seller code
      "c_number": customerDetail.customerMobile, //this is customer number
      "c_id": sellerCode, // send seller code here
      "user_id": customerDetail.id, // send customer id here
      "payment_method": "online_paid" , // Send cash
      "c_address": '${customerDetail.buildingType} ${customerDetail.buildingNumber} ${customerDetail.customerCity}', //Address of the customer
      "area_customer": "", // area of the customer
      "building_number": customerDetail.buildingNumber, // building  of the customer
      "order_remarks": "no_remarks", // order comments if any otherwise send no_remarks
      "user_tips": "0", // if any otherwise send 0
// Order Item array to be posted as follows
// Field name: "", order_items and items in this array are as follows(id, name, price, quantity, item_remarks, modifiers_list(modifier_code,name_modifier,price_modifier))
      "order_items": jsonEncode(cartdController.cartItems),
    };
    return await orderSubmit();
  }


    updatePaymentMethord(bool value) {
    receiptPaymentMethord = value;
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    viewAllCustomers = ViewAllCustomers();
    viewCustomers();
    update();
  }

  void showToast(String title, String msg) {
  Get.snackbar(
    title,
    '$msg',
    duration: Duration(seconds: 2),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.grey[900],
    colorText: Colors.white,
    icon: Icon(Icons.check_circle_outline, color: title != "Failed" ? Colors.green : Colors.red),
  );
}

}
