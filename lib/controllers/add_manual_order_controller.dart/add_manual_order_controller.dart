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
 bool isShowViewButton = false;
  var arguments;

  List<Product>? allProducts = [];
  List<Product> filteredProducts = [];

  changeLoadingStatus(bool value) {
    isLoading = value;
    update();
  }

  addIntoCart(CartItem product) {
    isShowViewButton = true;
    update();
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
          filteredProducts = allProducts??[];
        debugPrint(allProducts.toString());
        }

        selllerAllProductsModel =
            selllerAllProductsModelFromJson(response.body);
            update();
      } else {
        hasError = true;
      }
    } catch (e) {
      generalException();
      hasError = true;
    }
    changeLoadingStatus(false);
  }

  bool _doesActionSatisfy(Product e, String query) {

    bool found = e.productName.toString()
            .toLowerCase().contains(query) ||
            e.categoryName.toString().toLowerCase().contains(query);
    //  bool found =        allProducts!.any((s) => query
    //         .toLowerCase()
    //         .contains(s.productName.toString().toLowerCase()));
            

    return found;
  }
void filterList(String value){
 var valueList = allProducts!
        .where((e) => _doesActionSatisfy(e, value.trim().toLowerCase()))
        .toList();
       filteredProducts =   valueList;
        update();
}
  @override
  void onInit() async {
    if (Get.arguments != null) {
        arguments = (Get.arguments);
        print("arguments:" +arguments);
        update();
        // await gettingdata(name!);
      }else{
         selllerAllProductsModel = SelllerAllProductsModel();
    viewSellerAllProducts();
      }
   
    super.onInit();
  }
}
