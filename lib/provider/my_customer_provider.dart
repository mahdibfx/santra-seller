import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/controllers/cart_controller/cart_controller.dart';
import 'package:santra_seller/models/customers/view_all_customers.dart';
import 'package:santra_seller/provider/cart_provider.dart';
import 'package:santra_seller/ui/screens/cart/cart_screen.dart';
import 'package:santra_seller/ui/screens/home_page/home_screen.dart';
import 'package:santra_seller/ui/screens/more_setting/my_customer/my_customer_screen.dart';
import 'package:santra_seller/ui/widgets/dialogs/custom_dialogs.dart';
import 'package:santra_seller/utils/api_data.dart';
import 'package:santra_seller/utils/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../models/customers/delivery_charges.dart';
import '../ui/screens/more_setting/my_customer/view_customer_details.dart';

class MyCustomerProvider extends ChangeNotifier {
  // final cartdController = Get.put(CartController());

  TextEditingController link = TextEditingController();
  bool isViewCustomerLoading = false;
  bool hasViewCustomerError = false;
  bool isShowDetailScreen = false;
  bool isSubmitOrder = false;
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
    notifyListeners();
  }

  TextEditingController fnController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController buildingController = TextEditingController();
  TextEditingController aptController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  updateAddLoadingState(bool value) {
    isAddCustomerLoading = value;
    notifyListeners();
  }

  updateLoadingState(bool value) {
    isUpdateCustomerLoading = value;
    notifyListeners();
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
    notifyListeners();
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
    notifyListeners();
  }

  isComingFromCart(bool value) {
    isShowDetailScreen = value;
    notifyListeners();
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
        Get.to(() => MyCustomerScreen());
        viewCustomers();
      } else {
        generalException();
      }
    } catch (err) {
      generalException();
    }

    updateLoadingState(false);
    notifyListeners();
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
        var data = jsonDecode(response.body);
        var id = data['data']['user_id'];

        print("add customer" + response.body.toString());
        updateAddLoadingState(false);
        if (isShowDetailScreen) {
          Get.to(() => ViewCustomerDetails(
                customerDetail: Customer(
                  id: id,
                  customerCity: city ?? "",
                  customerEmail: emailController.text,
                  customerMobile: mobileController.text,
                  customerName: fnController.text,
                  buildingNumber: buildingController.text,
                  buildingType: aptController.text,
                  addressLink: addressController.text,
                ),
              ));
        } else {
          disposeValues();
          Get.to(() => MyCustomerScreen());
          viewCustomers();
        }
      } else {
        generalException();
      }
    } catch (err) {
      generalException();
    }

    updateAddLoadingState(false);
    notifyListeners();
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

  Future<bool> customerInfoSubmitedRequest(
      Customer customerDetail, context) async {
    isSubmitOrder = true;
    notifyListeners();
    try {
      // updateCustomerLoadingState(true);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sellerCode = prefs.getString("sellercode");
      var url = Uri.parse(ApiData.deliveryCharges);
      Map<String, dynamic> body = {};
      body['seller_code'] = sellerCode;
      var response = await http.post(url, body: body);
      if (response.statusCode == 200) {
        var decodedJson = jsonDecode(response.body);
        var data = DeliveryChargesModel.fromJson(decodedJson);

        // updateCustomerLoadingState(false);
        if (receiptPaymentMethord) {
          // final cartProvider = context.read<CartProvider>();
          var cartProvider = Provider.of<CartProvider>(context, listen: false);
          cartProvider.addItemForCustomerCart(
              data, customerDetail, sellerCode, receiptPaymentMethord);
          // showToast("Success",'Submitted Request');
          await cartProvider.orderSubmit();
          // cartdController.flushCart();
          isSubmitOrder = false;
          notifyListeners();
          return false;
        } else {
          return await addItemForCustomerLink(
              data, customerDetail, sellerCode, context);
          //  _.customerInfoSubmitedRequest(customerDetail!);
        }
      } else {
        showToast("Failed", 'Unable to proceed');
        hasViewCustomerError = true;
        updateCustomerLoadingState(false);
        isSubmitOrder = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      showToast("Failed", "Try again later, Unable to proceed");
      generalException();
      updateCustomerLoadingState(false);
      return false;
    }
  }

  Future<bool> orderSubmitByLink(context) async {
    var cartProvider = Provider.of<CartProvider>(context, listen: false);
    isSubmitOrder = true;
    notifyListeners();
    try {
      updateCustomerLoadingState(true);
      var url = Uri.parse(ApiData.generateLink);
      var response = await http.post(url, body: finalSubmitData);
      if (response.statusCode == 200) {
        var decodedJson = jsonDecode(response.body);
        link.text = decodedJson['data'].first['payment_link'];
        cartProvider.flushCart();
        Get.offAll(() => const HomeScreen());
        showToast("Success", 'Successfully Completed');
        isSubmitOrder = false;
        popupPaymentlink = true;
        notifyListeners();
        return true;
      } else {
        showToast("Failed", 'Unable to proceed');
        isSubmitOrder = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      showToast("Failed", 'Try again later, Unable to proceed');
      isSubmitOrder = false;
      notifyListeners();

      return false;
    }
  }

  Future<bool> addItemForCustomerLink(DeliveryChargesModel data,
      Customer customerDetail, String? sellerCode, context) async {
    var cartProvider = Provider.of<CartProvider>(context, listen: false);

    finalSubmitData = {
      "customer_name":
          customerDetail.customerName, // This is the name of the customer
      "coupn_code": "0", // coupon code if any other wise send 0
      "sub_total": "${cartProvider.totalPrice}", // This is the subtotal amount
      "total_delivery_charges":
          data.data?.first.deliveryCharges, //this is the delivery charges
      "total_discount": cartProvider.dis
          .toString(), //this is the discount if any otherwise send 0
      "d_reason":
          "no_discount", // If there is any discount otherwise send no_discount
      "d_type":
          "no_discount", //this is discount type otherwise send no_discount
      "seller_code": sellerCode, // this is seller code
      "c_number": customerDetail.customerMobile, //this is customer number
      "c_id": sellerCode, // send seller code here
      "user_id": customerDetail.id, // send customer id here
      "payment_method": "online_paid", // Send cash
      "c_address":
          '${customerDetail.buildingType} ${customerDetail.buildingNumber} ${customerDetail.customerCity}', //Address of the customer
      "area_customer": "", // area of the customer
      "building_number":
          customerDetail.buildingNumber, // building  of the customer
      "order_remarks":
          "no_remarks", // order comments if any otherwise send no_remarks
      "user_tips": "0", // if any otherwise send 0
      "order_schedule": cartProvider.deliveryDate ?? "",
// Order Item array to be posted as follows
// Field name: "", order_items and items in this array are as follows(id, name, price, quantity, item_remarks, modifiers_list(modifier_code,name_modifier,price_modifier))
      "order_items": jsonEncode(cartProvider.cartItems),
    };
    return await orderSubmitByLink(context);
  }

  updatePaymentMethord(bool value) {
    receiptPaymentMethord = value;
    notifyListeners();
  }

  void onInit() async {
    viewAllCustomers = ViewAllCustomers();
    viewCustomers();
    notifyListeners();
  }

  void showToast(String title, String msg) {
    Get.snackbar(
      title,
      '$msg',
      duration: Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.grey[900],
      colorText: Colors.white,
      icon: Icon(Icons.check_circle_outline,
          color: title != "Failed" ? Colors.green : Colors.red),
    );
  }
}
