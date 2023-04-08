import 'dart:convert';
import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:santra_seller/provider/cart_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/seller_all_products_model.dart';
import '../../ui/widgets/dialogs/custom_dialogs.dart';
import '../../utils/api_data.dart';
import '../controllers/cart_controller/cart_controller.dart';

class AddManualOrderProvider extends ChangeNotifier {
  late SelllerAllProductsModel selllerAllProductsModel;
  // var cartController = Get.put(CartController());
  bool showAddButton = true;

  bool isLoading = true;
  bool hasError = false;
  bool isShowViewButton = false;
  var arguments;

  List<Product>? allProducts = [];
  List<Product> filteredProducts = [];
    List<SubModifier> addOnProducts = [];


    clearAddonPro(){
      addOnProducts =[];
      notifyListeners();
    }

  changeLoadingStatus(bool value) {
    isLoading = value;
    notifyListeners();
  }

  addIntoCart() {
    isShowViewButton = true;
    notifyListeners();
    showToast();
  }
 void increaseDefaultQuanity(Product product) {
    if (product.productQuantity >= 0 && product.productQuantity < 99) {
      product.productQuantity += 1;
    }
    notifyListeners();
  }

  void decreaseDefaultQuanity(Product product) {
    if (product.productQuantity >1) {
      product.productQuantity -= 1;
    }
    notifyListeners();
  }

  void resetDefaultQuanity(Product product) {
     product.productQuantity = 1;
    notifyListeners();
  }
 

showAddIcon(){
  showAddButton = true;
  notifyListeners();
}

hideAddButton(){
  showAddButton = false;
  notifyListeners();
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
      body['seller_code'] = sellercode.toString();
      var response = await http.post(url, body: body);
      if (response.statusCode == 200) {
        var decodedJson = jsonDecode(response.body);
        var data = SelllerAllProductsModel.fromJson(decodedJson);
        if (data.data![0].products!.isNotEmpty) {
          allProducts = data.data?[0].products;
          filteredProducts = allProducts ?? [];
          debugPrint(allProducts.toString());
        }

        selllerAllProductsModel =
            selllerAllProductsModelFromJson(response.body);
        notifyListeners();
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
    bool found = e.productName.toString().toLowerCase().contains(query);
    //  bool found =        allProducts!.any((s) => query
    //         .toLowerCase()
    //         .contains(s.productName.toString().toLowerCase()));

    return found;
  }

  void filterList(String value) {
    var valueList = allProducts!
        .where((e) => _doesActionSatisfy(e, value.trim().toLowerCase()))
        .toList();
    filteredProducts = valueList;
    notifyListeners();
  }

  changeStatus(String newData, bool value){
if(value){
  newData == "1";
  notifyListeners();
}else{
  newData == "0";
  notifyListeners();
}
  }


  void onInit() async {
    //// @todo after change in provider, need to add param
    if (Get.arguments != null) {
      arguments = (Get.arguments);
      print("arguments:" + arguments);
      notifyListeners();
      // await gettingdata(name!);
    } else {
      selllerAllProductsModel = SelllerAllProductsModel();
      viewSellerAllProducts();
    }


  }
}


class CheckProduct {
  String groupCode;
  String minValue;
  String maxValue;
  SubModifier subModifier;
  bool isChecked = false;
  CheckProduct({
    required this.subModifier,
    required this.groupCode,
    required this.maxValue,
    required this.minValue,
    required this.isChecked,
  });
}