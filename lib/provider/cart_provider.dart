import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:santra_seller/ui/screens/home_page/home_screen.dart';
import 'package:santra_seller/ui/widgets/dialogs/custom_dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/customers/delivery_charges.dart';
import '../../models/customers/view_all_customers.dart';
import '../../models/seller_all_products_model.dart';
import '../../models/voucher_model.dart';
import '../../utils/api_data.dart';
import '../../utils/routes/app_routes.dart';

class CartProvider extends ChangeNotifier {
  bool isLoading = false;

  bool isShowCartButton = false;
  bool receiptPaymentType = true;
  List<CartItem> cartItems = <CartItem>[].obs;
  DateTime? selectedDateTime;
  double deliveryCharges = 0.0;
  double codCharges = 0.0;
  double discount = 0.0;
  dynamic finalSubmitData;
  List<VoucherModel> vouchersList = [];
  String? discountType;
  double capAmount = 0.0;
  String? voucherCode;
  bool promoValid = false;
  Set activeOffers = {};
  bool isDiscountLoading = false;
  String? voucherAppliedMsg;
  String? voucherListVoucherCode;
  List<DateTime?> dates = [];
  var deliveryDate;
  setDeliveryDate() {
    if (dates.isNotEmpty) {
      deliveryDate = DateFormat('yyyy-MM-dd').format(dates[0]!);

      notifyListeners();
    }
  }

  flushCart() {
    deliveryCharges = 0.0;
    isShowCartButton = false;
    receiptPaymentType = true;
    cartItems.clear();
    selectedDateTime = null;
    codCharges = 0.0;
    discount = 0.0;
    discountType = null;
    vouchersList.clear();
    voucherCode = null;
    promoValid = false;
    activeOffers.clear();
    isDiscountLoading = false;
    voucherAppliedMsg = null;
    voucherListVoucherCode = null;
    finalSubmitData = null;
    dates.clear();
    deliveryDate = null;
    notifyListeners();
  }

  final String _value = "Initial value";

  String get value => _value;

  getCartItems() {
    cartItems = GetStorage().read('cart') ?? [];
  }

  void changeDiscountLoadingState(value) {
    isDiscountLoading = value;
    notifyListeners();
  }

  changeLoadingStatus(value) {
    isLoading = value;
    notifyListeners();
  }

  emptyCartList() {
    cartItems = [];
    notifyListeners();
  }

  updateDate(date) {
    selectedDateTime = date;
    notifyListeners();
  }

  bool isCartLoading = false;
  changeCartLoadingState(value) {
    isCartLoading = value;
    notifyListeners();
  }

  double get deliveryFee {
    double dFee = 0.0;
    // if (preGrandTotal < deliveryChargesCap) {
    //   dFee = deliveryChargesReal;
    // } else {
    //   dFee = deliveryCharges;
    // }
    dFee = deliveryCharges;
    print("DELIVERY FEE$dFee");
    return dFee;
  }

  get preGrandTotal {
    double preAmount = 0;
    // if (paymentType != "COD") {
    //   codCharges = 0.0;
    // }
    preAmount = totalPrice - dis + codCharges;
    print("PRE GRAND$preAmount");
    return preAmount;
  }

  double get dis {
    double disAmount = 0.0;

    if (totalPrice >= capAmount) {
      if (discountType == "AED") {
        disAmount = discount;
      } else if (discountType == "%") {
        disAmount = (discount / 100) * totalPrice;
      }
    } else {
      discount = 0.0;
      disAmount = 0.0;
      voucherCode = null;
      promoValid = false;
    }
    print("DISCOUNT$disAmount");
    return disAmount;
  }

  double get totalPrice {
    double subAmount = 0;

    cartItems.fold(subAmount, (prevValue, element) {
      double modifierAmount = 0;
      if (element.subModifiers != null) {
        for (var j in element.subModifiers) {
          modifierAmount =
              (double.parse(j.priceModifier.toString()) * element.quantity) +
                  modifierAmount;
        }
      }

      subAmount += (double.parse(element.price.toString()) * element.quantity) +
          modifierAmount;
      return subAmount;
    });
    print("TOTAL PRICE$subAmount");
    return subAmount;
  }

  get grandTotal {
    double amount = 0;
    amount = preGrandTotal + deliveryFee;

    return amount;
  }

  /// *************************METHOD TO APPLY DISCOUNT BY CLICKING APPLY ON VOUCHER TILE*******************************/
  voucherTileDiscountMethod(index) {
    capAmount = double.parse(vouchersList[index].capAmount.toString());
    discount = double.parse(vouchersList[index].discountApplied.toString());
    discountType = vouchersList[index].disType;
    voucherListVoucherCode = vouchersList[index].offerTitle;
    voucherCode = null;
    promoValid = false;
    notifyListeners();
  }

  /// *************************APPLY/APPLIED TOGGLE ON VOUHCER TILE*******************************/
  void toggleApplied(index) {
    activeOffers.clear();
    activeOffers.contains(index)
        ? activeOffers.remove(index)
        : activeOffers.add(index);
    voucherCode = null;
    promoValid = false;
    notifyListeners();
  }

  Future cartScreenData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sellerCode = prefs.getString("sellercode");
      changeCartLoadingState(true);
      var url = Uri.parse(ApiData.cartApi);
      Map<String, dynamic> body = {};
      body['seller_code'] = sellerCode ?? "";
      final response = await http.post(url, body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        var voucherL = data['data'][0]['vouchers'] as List<dynamic>;
        deliveryCharges =
            double.parse(data['data'][0]['delivery_charges'].toString());
        codCharges = double.parse(data['data'][0]['cash_charges'].toString());
        var vList = voucherL.map((e) => VoucherModel.fromJson(e)).toList();
        vouchersList = vList;
      } else {
        generalException();
      }
    } catch (e) {
      exceptionDialog("Oops", "Something went wrong");
    }
    changeCartLoadingState(false);
  }

  /// *************************PROMO DISCOUNT API*******************************/
  Future promoDiscount() async {
    try {
      changeDiscountLoadingState(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sellerCode = prefs.getString("sellercode");
      var url = Uri.parse(ApiData.promoDiscountApi);
      Map<String, dynamic> body = {};
      body['seller_code'] = sellerCode.toString();
      body['discount_coupon'] = voucherCode;
      //body['user_id'] = prefs.getString("user_id").toString();
      body['total_amount'] = grandTotal.toString();
      body['sub_total'] = totalPrice.toString();
      var response = await http.post(url, body: body);
      if (response.statusCode == 200) {
        changeDiscountLoadingState(false);
        if (kDebugMode) {
          print(response.body);
        }
        var data = jsonDecode(response.body);
        discount = double.parse(data['data'][0]['discount_applied'].toString());
        discountType = data['data'][0]['discount_type'].toString();
        capAmount = double.parse(data['data'][0]['cap_amount'].toString());
        voucherAppliedMsg = data['data'][0]['message'].toString();
        voucherListVoucherCode = null;
        activeOffers.clear();
        promoValid = true;
      } else {
        changeDiscountLoadingState(false);
        discount = 0.0;
        voucherCode = null;

        var data = jsonDecode(response.body);
        String msg = data['data']['message'].toString();

        exceptionDialog("Oops", msg);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      Get.snackbar("Oops", "An unknown error occured");
    }
    changeDiscountLoadingState(false);
    notifyListeners();
  }

  void addToCart(CartItem item) {
    isShowCartButton = true;
    notifyListeners();
    final index =
        cartItems.indexWhere((cartItem) => cartItem.code == item.code);
    if (index != -1) {
      cartItems[index].quantity += 1;
      notifyListeners();
      // showToast("Added", 'increased by one');
    } else {
      cartItems.add(item);
      notifyListeners();
    }
    print(itemCount);
    print('............,,mmmmmmmmmmmmm');
    //  GetStorage().write('cart', cartItems);
  }

  int get itemCount => cartItems.length;

  void removeFromCart(CartItem item) {
    final index =
        cartItems.indexWhere((cartItem) => cartItem.code == item.code);
    if (index != -1) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity -= 1;
        notifyListeners();
        showToast("Added", 'decreased by one');
      } else {
        cartItems.removeAt(index);
        notifyListeners();
      }
    }
    if (cartItems.isEmpty) {
      isShowCartButton = false;
      notifyListeners();
    }
    if (totalPrice < capAmount) {
      voucherCode = null;
      voucherListVoucherCode = null;
      activeOffers.clear();
    }
    //  GetStorage().write('cart', cartItems);
  }

  // double get totalPrice => cartItems.fold(
  //       0,
  //       (previousValue, cartItem) => previousValue + (cartItem.price +)* cartItem.quantity,
  //     );
  //  double get grandTotal => cartItems.fold(
  //   0,
  //   (previousValue, cartItem) => (previousValue + cartItem.price * cartItem.quantity) + deliveryCharges,
  // );

  double calculateTotalPrice() {
    double totalPrice = 0;

    for (var product in cartItems) {
      totalPrice += product.price;
      for (var addon in product.subModifiers) {
        totalPrice += double.parse(addon.priceModifier.toString());
      }
      totalPrice += totalPrice + product.quantity;
    }

    return totalPrice;
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

  addItemForCustomerCart(DeliveryChargesModel data, Customer customerDetail,
      String? sellerCode, bool receiptPaymentMethord) async {
    receiptPaymentType = receiptPaymentMethord;

    finalSubmitData = {
      "customer_name":
          customerDetail.customerName, // This is the name of the customer
      "coupn_code": "0", // coupon code if any other wise send 0
      "sub_total": "$totalPrice", // This is the subtotal amount
      "total_delivery_charges":
          data.data?.first.deliveryCharges, //this is the delivery charges
      "total_discount": "0", //this is the discount if any otherwise send 0
      "d_reason":
          "no_discount", // If there is any discount otherwise send no_discount
      "d_type":
          "no_discount", //this is discount type otherwise send no_discount
      "seller_code": sellerCode, // this is seller code
      "c_number": customerDetail.customerMobile, //this is customer number
      "c_id": sellerCode, // send seller code here
      "user_id": customerDetail.id, // send customer id here
      "payment_method": "cash", // Send cash
      "c_address":
          '${customerDetail.buildingType} ${customerDetail.buildingNumber} ${customerDetail.customerCity}', //Address of the customer
      "area_customer": "", // area of the customer
      "building_number":
          customerDetail.buildingNumber, // building  of the customer
      "order_remarks":
          "no_remarks", // order comments if any otherwise send no_remarks
      "user_tips": "0", // if any otherwise send 0
      "order_schedule": selectedDateTime != null
          ? DateFormat('yyyy-MM-dd').format(selectedDateTime!)
          : "",
// Order Item array to be posted as follows
// Field name: "", order_items and items in this array are as follows(id, name, price, quantity, item_remarks, modifiers_list(modifier_code,name_modifier,price_modifier))
      "order_items": jsonEncode(cartItems),

      // [
      //   {
      //     "id": "",
      //     "name": "",
      //     "price": "",
      //     "quantity": "",
      //     "item_remarks": "",
      //     "modifiers_list": [
      //       {"modifier_code": "", "name_modifier": "", "price_modifier ": ""}
      //     ]
      //   }
      // ],
    };
    notifyListeners();
  }

  Future orderSubmit() async {
    try {
      changeLoadingStatus(true);
      var url = Uri.parse(ApiData.orderSubmitCash);
      var response = await http.post(url, body: finalSubmitData);
      if (response.statusCode == 200) {
        // var decodedJson = jsonDecode(response.body);
        // var data = SelllerAllProductsModel.fromJson(decodedJson);
        // if (data.data![0].products!.isNotEmpty) {
        //   allProducts = data.data?[0].products;
        // }
        // selllerAllProductsModel =
        //     selllerAllProductsModelFromJson(response.body);
        // notifyListeners();
        //        Get.offAllNamed(Routes.homeRoutes);
        Get.offAll(() => const HomeScreen());
        showToast("Success", 'Successfully Completed');
        flushCart();
      } else {
        showToast("Failed", 'Unable to proceed');
        // hasError = true;
      }
    } catch (e) {
      showToast("Failed", 'Try again later, Unable to proceed');
      // generalException();
      // hasError = true;
    }
    changeLoadingStatus(false);
  }
}

class CartItem {
  final String name;
  final String code;
  final double price;
  final String imageString;
  List<SubModifier> subModifiers = [];
  int quantity;

  CartItem(
      {required this.name,
      required this.price,
      required this.code,
      required this.imageString,
      this.quantity = 1,
      required this.subModifiers});

  Map toJson() => {
        'id': code,
        'name': name,
        'price': price,
        'quantity': quantity,
        'item_remarks': "no remarks",
        'modifiers_list': subModifiers
      };
}
