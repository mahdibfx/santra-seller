import 'dart:convert';
import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/seller_all_products_model.dart';
import '../../ui/widgets/dialogs/custom_dialogs.dart';
import '../../utils/api_data.dart';
import '../cart_controller/cart_controller.dart';

class AddManualOrderController extends GetxController {
  late SelllerAllProductsModel selllerAllProductsModel;
  var cartController = Get.put(CartController());

  bool isLoading = true;
  bool hasError = false;

  List<Product>? allProducts = [];
  changeLoadingStatus(bool value) {
    isLoading = value;
    update();
  }

  addIntoCart(CartItem product) {
    cartController.addToCart(product);
    showToast();

  }
  void showToast() {
  Get.snackbar(
    'Added',
    'Add in the cart',
    duration: Duration(seconds: 2),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.grey[900],
    colorText: Colors.white,
    icon: Icon(Icons.check_circle_outline, color: Colors.green),
  );
}

  var productsByCategory;
  Future viewSellerAllProducts() async {
    try {
      changeLoadingStatus(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var sellercode = prefs.getString("sellercode");
      var url = Uri.parse(ApiData.sellerAllProducts);
      Map<String, dynamic> body = {};
      body['seller_code'] = '190';  //sellercode.toString();
      var response = await http.post(url, body: body);
      if (response.statusCode == 200) {
        var decodedJson = jsonDecode(response.body);
        var data = SelllerAllProductsModel.fromJson(decodedJson);
        if (data.data![0].products!.isNotEmpty) {
          allProducts = data.data?[0].products;
        }

        selllerAllProductsModel =
            selllerAllProductsModelFromJson(response.body);
      } else {
        hasError = true;
      }
    } catch (e) {
      generalException();
      hasError = true;
    }
    changeLoadingStatus(false);
  }

  @override
  void onInit() async {
    selllerAllProductsModel = SelllerAllProductsModel();
    viewSellerAllProducts();
    super.onInit();
  }
}
