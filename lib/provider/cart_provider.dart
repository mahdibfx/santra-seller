import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:santra_seller/models/cart_model.dart';
import 'package:santra_seller/provider/firebase_events/firebase_events.dart';
import 'package:santra_seller/ui/screens/home_page/home_screen.dart';
import 'package:santra_seller/ui/widgets/dialogs/custom_dialogs.dart';
import 'package:santra_seller/utils/ext.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/customers/delivery_charges.dart';
import '../../models/customers/view_all_customers.dart';
import '../../models/seller_all_products_model.dart';
import '../../models/voucher_model.dart';
import '../../utils/api_data.dart';
import '../utils/app_translation/app_translation.dart';

class CartProvider extends ChangeNotifier {
  // final BuildContext context;

  // CartProvider(this.context);
  FirebaseAnalyticsController firebaseAnalyticsController =
      Get.put(FirebaseAnalyticsController());
  bool isLoading = false;
  bool isShowCartButton = false;
  bool receiptPaymentType = true;
  List<CartItem> cartItems = <CartItem>[];
  double deliverChargeForBackend = 0.0;
  String? showPickup;
  String? showCOD;
  String? showVip;
  DateTime? vipStart;
  DateTime? vipEnd;
  String? showExpress;
  double deliveryCharges = 0.0;
  double maxDiscount = 0.0;
  double codCharges = 0.0;
  double discount = 0.0;
  dynamic finalSubmitData;
  String? sellerCity;
  List<VoucherModel> vouchersList = [];
  String? discountType;
  double capAmount = 0.0;
  String? voucherCode;
  bool promoValid = false;
  Set activeOffers = {};
  bool isDiscountLoading = false;
  String? voucherAppliedMsg;
  String? voucherListVoucherCode;
  double deliveryChargesCap = 0.0;
  double deliveryChargesReal = 0.0;
  double deliveryChargesVip = 0.0;
  double deliveryChargesExpress = 0.0;
  List<DateTime?> dates = [];
  bool equalLists = true;
  bool checkMods = false;
  int taxFeePercantage = 0;
  int toggleValue = 0;
  var deliveryDate;
  String deliveryMethod = "delivery";
  String? selectedVipHour;
  DateTime? selectedVipDay;
  DateTime focusedVipDay = DateTime.now();
  List<String> hoursList = [];
  selectHour(String hour) {
    selectedVipHour = hour;
    notifyListeners();
  }

  setDeliveryMethod(String dMethod) {
    deliveryMethod = dMethod;
    if (deliveryMethod == "express") {
      setDateToday();
    } else if (deliveryMethod == "vip") {
      deliveryDate = null;
      dates.clear();
    } else {
      selectedVipDay = null;
      focusedVipDay = DateTime.now();
      selectedVipHour = null;
      deliveryDate = null;
      dates.clear();
    }
    print(deliveryMethod);
    notifyListeners();
  }

  onVipDaySelected(DateTime selectedDay, DateTime focusedDay) {
    selectedVipDay = selectedDay;
    focusedVipDay = focusedDay; // update `cartfocusedDay` here as well

    notifyListeners();
  }

  setDeliveryDate() {
    if (dates.isNotEmpty) {
      deliveryDate = DateFormat('yyyy-MM-dd').format(dates[0]!);

      notifyListeners();
    }
  }

  setDateToday() {
    deliveryDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    notifyListeners();
  }

  flushCart() {
    deliveryMethod = "delivery";
    showExpress = null;
    showPickup = null;
    deliveryCharges = 0.0;
    maxDiscount = 0.0;
    isShowCartButton = false;
    receiptPaymentType = true;
    deliveryChargesExpress = 0.0;
    cartItems.clear();
    deliveryChargesCap = 0.0;
    deliveryChargesReal = 0.0;
    deliveryChargesVip = 0.0;
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
    taxFeePercantage = 0;
    selectedVipDay = null;
    selectedVipHour = null;
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

  bool isCartLoading = false;
  changeCartLoadingState(value) {
    isCartLoading = value;
    notifyListeners();
  }

  double get deliveryFee {
    double dFee = 0.0;
    if (deliveryMethod != "pickup") {
      if (preGrandTotal < deliveryChargesCap && deliveryMethod == "express") {
        dFee = deliveryChargesExpress;
        deliverChargeForBackend = dFee;
      } else if (preGrandTotal < deliveryChargesCap &&
          deliveryMethod == "vip") {
        dFee = deliveryChargesVip;
        deliverChargeForBackend = dFee;
      } else if (preGrandTotal < deliveryChargesCap &&
          deliveryMethod != "express") {
        dFee = deliveryChargesReal;
        deliverChargeForBackend = dFee;
      } else {
        dFee = deliveryCharges;
        deliverChargeForBackend = dFee;
      }
    }
    return dFee;
  }

  double get vatTax {
    double vat = 0.0;
    double v = totalPrice + deliveryFee - dis;
    double c = (v * taxFeePercantage) / 100;
    vat = c;
    return vat;
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
    if (disAmount > maxDiscount) {
      return maxDiscount;
    } else {
      return disAmount;
    }
  }

  double get totalPrice {
    double subAmount = 0;

    cartItems.fold(subAmount, (prevValue, element) {
      double modifierAmount = 0;
      for (var j in element.subModifiers) {
        modifierAmount =
            (double.parse(j.priceModifier.toString()) * element.quantity) +
                modifierAmount;
      }

      subAmount += (double.parse(element.price.toString()) * element.quantity) +
          modifierAmount;
      return subAmount;
    });
    return subAmount;
  }

  get preGrandTotal {
    double preAmount = 0;
    // if (paymentType != "COD") {
    //   codCharges = 0.0;
    // }
    preAmount = totalPrice - dis + codCharges;

    return preAmount;
  }

  get grandTotal {
    double amount = 0;
    amount = preGrandTotal + deliveryFee + vatTax;

    return amount;
  }

  /// *************************METHOD TO APPLY DISCOUNT BY CLICKING APPLY ON VOUCHER TILE*******************************/
  voucherTileDiscountMethod(index) {
    capAmount = double.parse(vouchersList[index].capAmount.toString());
    discount = double.parse(vouchersList[index].discountApplied.toString());
    discountType = vouchersList[index].disType;
    voucherListVoucherCode = vouchersList[index].offerTitle;
    maxDiscount = double.parse(vouchersList[index].maxDiscount.toString());
    voucherCode = null;
    promoValid = false;
    notifyListeners();
  }

  /// *************************APPLY/APPLIED TOGGLE ON VOUHCER TILE*******************************/
  void toggleApplied(index) {
    activeOffers.clear();
    activeOffers.contains(index)
        ? {activeOffers.remove(index), discount = 0.0}
        : activeOffers.add(index);
    voucherCode = null;
    promoValid = false;
    notifyListeners();
  }

  Future cartScreenData() async {
    var tr = Get.put(AppTranslations());
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sellerCode = prefs.getString("sellercode");
      changeCartLoadingState(true);
      var url = Uri.parse(ApiData.cartApi);
      Map<String, dynamic> body = {};
      body['seller_code'] = sellerCode ?? "";
      final response =
          await http.post(url, headers: ApiData.header, body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var cartData = CartModel.fromJson(data);
        var voucherL = data['data'][0]['vouchers'] as List<dynamic>;
        deliveryCharges =
            double.parse(cartData.data![0].deliveryCharges.toString());
        deliveryChargesCap =
            double.parse(cartData.data![0].deliveryChargesCap.toString());
        deliveryChargesReal =
            double.parse(cartData.data![0].deliveryChargesReal.toString());
        deliveryChargesExpress =
            double.parse(cartData.data![0].deliveryChargesExpress.toString());
        deliveryChargesVip =
            double.parse(cartData.data![0].deliveryChargesVip.toString());
        taxFeePercantage = cartData.data?[0].taxFee ?? 0;
        codCharges = double.parse(cartData.data![0].cashCharges.toString());
        var vList = voucherL.map((e) => VoucherModel.fromJson(e)).toList();
        sellerCity = cartData.data?[0].sellerCity;
        prefs.setString("sellercity", sellerCity ?? "");
        vouchersList = vList;
        showExpress = cartData.data?[0].checkFlags?[0].expressFlag;
        showPickup = cartData.data?[0].checkFlags?[0].pickupAllowed;
        showVip = cartData.data?[0].checkFlags?[0].vipFlag;
        showCOD = cartData.data?[0].checkFlags?[0].cashOnDelivery;
        vipStart = cartData.data?[0].checkFlags?[0].vipStart;
        vipEnd = cartData.data?[0].checkFlags?[0].vipEnd;
        hoursList = cartData.data?[0].vipSlots ?? [];

        response.body.debugPrint();
      } else {
        generalException();
      }
    } catch (e) {
      exceptionDialog(
          tr.translateData("oops_message"), tr.translateData("went_wrong"));
    }
    changeCartLoadingState(false);
    notifyListeners();
  }

  /// *************************PROMO DISCOUNT API*******************************/
  Future promoDiscount() async {
    var tr = Get.put(AppTranslations());
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
      var response = await http.post(url, headers: ApiData.header, body: body);
      if (response.statusCode == 200) {
        changeDiscountLoadingState(false);
        if (kDebugMode) {
          print(response.body);
        }
        var data = jsonDecode(response.body);
        discount = double.parse(data['data'][0]['discount_applied'].toString());
        maxDiscount = double.parse(data['data'][0]['max_discount'].toString());
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

        exceptionDialog(tr.translateData("oops_message"), msg);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      // Get.snackbar(tr.translateData("oops_message"), tr.translateData("went_wrong"));
    }
    changeDiscountLoadingState(false);
    notifyListeners();
  }

  checkModes(CartItem item) {
    equalLists = true;
    notifyListeners();
    var isexistsModsWithsameCode = cartItems.where((e) {
      if (e.code == item.code &&
          e.subModifiers.length == item.subModifiers.length) {
        for (int i = 0; i < e.subModifiers.length; i++) {
          if (e.subModifiers == item.subModifiers) {
            equalLists = true;
            notifyListeners();

            notifyListeners();
            // break;
            return equalLists;
          }
        }
      }

      return equalLists;
    });
  }

  increaseProductQuantity(CartItem item) {
    isShowCartButton = true;
    for (var e in cartItems) {
      if (e == item && item.quantity < 99) {
        item.quantity++;
        notifyListeners();
      }
    }
  }

  addToCart(CartItem item) {
    isShowCartButton = true;
    notifyListeners();
    // final index =
    //     cartItems.indexWhere((cartItem) => cartItem.code == item.code);

    final checkValue = cartItems
        .where((cartItem) =>
            cartItem.code == item.code &&
            cartItem.subModifiers.length == item.subModifiers.length)
        .toList();

    List<SubModifier> matchArray = item.subModifiers;
    notifyListeners();
    bool newcheckVal() {
      bool containsExactMatch = checkValue.any((array) =>
          array.subModifiers.every((item) => matchArray.contains(item)));
      return containsExactMatch;
    }

    final index = checkValue.indexWhere((element) =>
        element.subModifiers.every((item) => matchArray.contains(item)));

    if (index != -1 && newcheckVal()) {
      if (cartItems[index].quantity < 99) {
        cartItems[index].quantity += 1;
        notifyListeners();
      }
    } else {
      cartItems.add(item);
      notifyListeners();
    }
  }

  int get itemCount => cartItems.length;

  void decreaseQuantity(CartItem item) {
    final index =
        cartItems.indexWhere((cartItem) => cartItem.code == item.code);
    if (index != -1) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity -= 1;
        notifyListeners();
      } else {
        cartItems.removeAt(index);
        notifyListeners();
      }
    }
    if (cartItems.isEmpty) {
      isShowCartButton = false;
      flushCart();
      notifyListeners();
    }
    if (totalPrice < capAmount) {
      voucherCode = null;
      voucherListVoucherCode = null;
      activeOffers.clear();
    }
    notifyListeners();
  }

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
      msg,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.grey[900],
      colorText: Colors.white,
      icon: Icon(Icons.check_circle_outline,
          color: title != "Failed" ? Colors.green : Colors.red),
    );
  }

  String delivery() {
    return deliveryFee.toString();
  }

  addItemForCustomerCart(DeliveryChargesModel data, Customer customerDetail,
      String? sellerCode, bool receiptPaymentMethord) async {
    receiptPaymentType = receiptPaymentMethord;

    finalSubmitData = {
      "customer_name":
          customerDetail.customerName, // This is the name of the customer
      "coupn_code": "0", // coupon code if any other wise send 0
      "sub_total": "$totalPrice", // This is the subtotal amount
      "total_delivery_charges": delivery(), //this is the delivery charges
      "total_discount":
          dis.toString(), //this is the discount if any otherwise send 0
      "d_reason": voucherListVoucherCode ??
          voucherCode ??
          "no_discount", // If there is any discount otherwise send no_discount
      // "d_type":
      //     "no_discount", //this is discount type otherwise send no_discount
      "seller_code": sellerCode, // this is seller code
      "c_number": customerDetail.customerMobile, //this is customer number
      "c_id": sellerCode, // send seller code here
      "user_id": customerDetail.id, // send customer id here
      "payment_method": "cash", // Send cash
      "c_address":
          '${customerDetail.buildingType} ${customerDetail.buildingNumber} ${customerDetail.customerCity}', //Address of the customer
      "area_customer": customerDetail.customerCity, // area of the customer
      "building_number":
          customerDetail.customerArea, // building  of the customer
      "order_remarks":
          "no_remarks", // order comments if any otherwise send no_remarks
      "user_tips": "0", // if any otherwise send 0
      "order_schedule": deliveryMethod == "vip"
          ? DateFormat('yyyy-MM-dd').format(selectedVipDay!).toString()
          : deliveryDate ?? "",
// Order Item array to be posted as follows
// Field name: "", order_items and items in this array are as follows(id, name, price, quantity, item_remarks, modifiers_list(modifier_code,name_modifier,price_modifier))
      "order_items": jsonEncode(cartItems),
      "delivery_type": deliveryMethod,
      "pickup_slot": selectedVipHour ?? "",
      "tax_value": vatTax.toString()
    };
    notifyListeners();
  }

  Future orderSubmit() async {
    try {
      changeLoadingStatus(true);
      var url = Uri.parse(ApiData.orderSubmitCash);

      var response =
          await http.post(url, headers: ApiData.header, body: finalSubmitData);
      var body = jsonDecode(response.body);

      String id = body['data']['order_number'].toString();

      if (response.statusCode == 200) {
        await firebaseAnalyticsController.firebasePurchaseEvent(id, grandTotal);
        Get.offAll(() => const HomeScreen());
        flushCart();
      }
    } catch (e) {
      // showToast(tr.translateData("oops_message"), tr.translateData('error_load_data'));
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
      required this.quantity,
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
