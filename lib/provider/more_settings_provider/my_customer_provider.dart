import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/models/customers/view_all_customers.dart';
import 'package:santra_seller/provider/cart_provider.dart';
import 'package:santra_seller/provider/home_provider.dart';
import 'package:santra_seller/ui/screens/more_setting/my_customer/my_customer_screen.dart';
import 'package:santra_seller/ui/widgets/dialogs/custom_dialogs.dart';
import 'package:santra_seller/utils/api_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../models/customers/delivery_charges.dart';
import '../../ui/screens/more_setting/my_customer/view_customer_details.dart';
import '../../ui/screens/order_detail/manual_order_screen.dart';
import '../../utils/app_translation/app_translation.dart';

class MyCustomerProvider extends ChangeNotifier {


  TextEditingController link = TextEditingController();
  bool isViewCustomerLoading = false;
  bool hasViewCustomerError = false;
  bool isShowDetailScreen = false;
  bool isLoaderShowDeleteCustumer = true;
  bool isSubmitOrder = false;
  late ViewAllCustomers viewAllCustomers;
  List<String>? citiesList = [];
  String? city = 'Dubai';
  List<Customer> allNewCustomers = [];
  List<Customer>? allFilterCustomers = [];
  bool isAddCustomerLoading = false;
  bool isUpdateCustomerLoading = false;
  bool receiptPaymentMethord = false;
  bool onlinePayment = true;
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

  var phoneMask = MaskTextInputFormatter(
      mask: '971#########',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
  String? phoneCon;
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
    receiptPaymentMethord = false;
    onlinePayment = true;
    city = "Dubai";
    phoneCon = null;
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
    cidForUpdate = allFilterCustomers?[index].id;
    fnController.text = allFilterCustomers?[index].customerName ?? "";
    mobileController.text = allFilterCustomers?[index].customerMobile ?? "";
    emailController.text = allFilterCustomers?[index].customerEmail ?? "";
    buildingController.text = allFilterCustomers?[index].buildingNumber ?? "";
    aptController.text = allFilterCustomers?[index].buildingType ?? "";
    addressController.text = allFilterCustomers?[index].addressLink ?? "";
    city = allFilterCustomers?[index].customerCity ?? "";
    notifyListeners();
  }

  isComingFromCart(bool value) {
    isShowDetailScreen = value;
    disposeValues();
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
      request.headers.addAll(ApiData.header);
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        disposeValues();
        Get.off(() => const MyCustomerScreen());
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
      body['customer_email'] =
          emailController.text.isEmpty ? "" : emailController.text;
      body['customer_city'] = city ?? "";
      body['building_number'] = buildingController.text;
      body['building_type'] = aptController.text;
      body['address_link'] = addressController.text;
      request.fields.addAll(body);
      request.headers.addAll(ApiData.header);
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var id = data['data']['user_id'];

        updateAddLoadingState(false);
        if (isShowDetailScreen) {
          Get.off(() => ViewCustomerDetails(
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
          Get.off(() => const MyCustomerScreen());
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
    isLoaderShowDeleteCustumer = true;
    notifyListeners();
    allFilterCustomers!.clear();
    isLoaderShowDeleteCustumer = true;
    notifyListeners();
    try {
      updateCustomerLoadingState(true);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sellerCode = prefs.getString("sellercode");
      var url = Uri.parse(ApiData.customerListApi);
      Map<String, dynamic> body = {};
      body['seller_code'] = sellerCode;
      var response = await http.post(url, headers: ApiData.header, body: body);
      if (response.statusCode == 200) {
        var decodedJson = jsonDecode(response.body);
        var data = ViewAllCustomers.fromJson(decodedJson);
        allNewCustomers = data.data![0].customers!.toList();
        allFilterCustomers = allNewCustomers;
        notifyListeners();
        citiesList = data.data?[0].cities?.toList();
        // viewAllCustomers = viewAllCustomersFromJson(response.body);
        notifyListeners();
      } else {
        hasViewCustomerError = true;
      }
    } catch (e) {
      generalException();
    }
    isLoaderShowDeleteCustumer = false;
    updateCustomerLoadingState(false);
    notifyListeners();
  }

  void filterList(String value) {
    var valueList = allNewCustomers
        .where((e) => (e.customerName
            .toString()
            .toLowerCase()
            .contains(value.trim().toLowerCase())))
        .toList();
    allFilterCustomers = valueList;
    notifyListeners();
  }

  Future<bool> customerInfoSubmitedRequest(
      Customer customerDetail, context) async {
         var tr = Get.put(AppTranslations());
    isSubmitOrder = true;
    notifyListeners();
    try {
      // updateCustomerLoadingState(true);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sellerCode = prefs.getString("sellercode");
      var url = Uri.parse(ApiData.deliveryCharges);
      Map<String, dynamic> body = {};
      body['seller_code'] = sellerCode;
      var response = await http.post(url, headers: ApiData.header, body: body);
      if (response.statusCode == 200) {
        var decodedJson = jsonDecode(response.body);
        var data = DeliveryChargesModel.fromJson(decodedJson);
        if (receiptPaymentMethord) {
          var cartProvider = Provider.of<CartProvider>(context, listen: false);
          
          cartProvider.addItemForCustomerCart(
              data, customerDetail, sellerCode, receiptPaymentMethord);
          await cartProvider.orderSubmit();
          isSubmitOrder = false;
          notifyListeners();
          appFlyerController.codEvent();
          return false;
        } else {
          return await addItemForCustomerLink(
              data, customerDetail, sellerCode, context);
        }
      } else {
        showToast(tr.translateData("failed_message"), tr.translateData('went_wrong'));
        isSubmitOrder = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      showToast(tr.translateData("failed_message"), tr.translateData('went_wrong'));
      generalException();
      updateCustomerLoadingState(false);
      isSubmitOrder = true;
    notifyListeners();
      return false;
    }
  }

  Future<bool> orderSubmitByLink(context) async {
    var tr = Get.put(AppTranslations());
    var cartProvider = Provider.of<CartProvider>(context, listen: false);
    var homePro = Provider.of<HomeProvider>(context, listen: false);

    isSubmitOrder = true;
    notifyListeners();
    try {
      // updateCustomerLoadingState(true);
      var url = Uri.parse(ApiData.generateLink);
      var response =
          await http.post(url, headers: ApiData.header, body: finalSubmitData);
      if (response.statusCode == 200) {
        appFlyerController.paymentLinkEvent();
        var decodedJson = jsonDecode(response.body);
        link.text = decodedJson['data'].first['payment_link'];
        cartProvider.flushCart();
        disposeValues();
        showToast(tr.translateData("success_message"), tr.translateData('order_placed_success'));
        isSubmitOrder = false;
        popupPaymentlink = true;
        notifyListeners();
        homePro.homeDataCall();
        Get.offAll(() => const ManualOrderScreen());
        return true;
      } else {
        showToast(tr.translateData("failed_message"), tr.translateData('went_wrong'));
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
          cartProvider.delivery(), //this is the delivery charges
      "total_discount": cartProvider.dis
          .toString(), //this is the discount if any otherwise send 0
      "d_reason": cartProvider.voucherListVoucherCode ??
          cartProvider.voucherCode ??
          "no_discount", // If there is any discount otherwise send no_discount
      // "d_type":
      //     "no_discount", //this is discount type otherwise send no_discount
      "seller_code": sellerCode, // this is seller code
      "c_number": customerDetail.customerMobile, //this is customer number
      "c_id": sellerCode, // send seller code here
      "user_id": customerDetail.id, // send customer id here
      "payment_method": "online_paid", // Send cash
      "c_address":
          '${customerDetail.buildingType} ${customerDetail.buildingNumber} ${customerDetail.customerCity}', //Address of the customer
      "area_customer": customerDetail.customerCity, // area of the customer
      "building_number":
          customerDetail.buildingNumber, // building  of the customer
      "order_remarks":
          "no_remarks", // order comments if any otherwise send no_remarks
      "user_tips": "0", // if any otherwise send 0
      "order_schedule": cartProvider.deliveryDate ?? "",
// Order Item array to be posted as follows
// Field name: "", order_items and items in this array are as follows(id, name, price, quantity, item_remarks, modifiers_list(modifier_code,name_modifier,price_modifier))
      "order_items": jsonEncode(cartProvider.cartItems),
      "delivery_type": cartProvider.toggleValue == 0 ?  "Delivery" : "Pickup",

    };
    print(finalSubmitData);
    return await orderSubmitByLink(context);
  }

  Future deleteCustomers(String customerID) async {
    isLoaderShowDeleteCustumer = true;
    notifyListeners();
    try {
      updateCustomerLoadingState(true);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sellerCode = prefs.getString("sellercode");
      var url = Uri.parse(ApiData.deleteCustomerApi);
      Map<String, dynamic> body = {};
      body['seller_code'] = sellerCode;
      body['customer_id'] = customerID;
      var response = await http.post(url, headers: ApiData.header, body: body);
      if (response.statusCode == 200) {
        var decodedJson = jsonDecode(response.body);
        print(decodedJson);

        Get.to(() => const MyCustomerScreen());
        await viewCustomers();
        showToast("Success", 'Successfully deleted customer');
        notifyListeners();
      } else {
        hasViewCustomerError = true;
      }
    } catch (e) {
      generalException();
    }
    updateCustomerLoadingState(false);
    notifyListeners();
  }

  paymentMethodReceipt() {
    receiptPaymentMethord = true;
    onlinePayment = false;
    notifyListeners();
  }

  paymentMethodOnline() {
    receiptPaymentMethord = false;
    onlinePayment = true;
    notifyListeners();
  }

  onInit() async {
    isLoaderShowDeleteCustumer = true;
    notifyListeners();
    viewAllCustomers = ViewAllCustomers();
    viewCustomers();
    notifyListeners();
  }

  void showToast(String title, String msg) {
    Get.snackbar(
      title,
      msg,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.grey[900],
      colorText: Colors.white,
      icon: Icon(Icons.check_circle_outline,
          color: title != "Failed" ? Colors.green : Colors.red),
    );
  }
}
