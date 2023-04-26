import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/seller_all_products_model.dart';
import '../../../ui/widgets/dialogs/custom_dialogs.dart';
import '../../../ui/widgets/snackbar/common_snackbar.dart';
import '../../../utils/api_data.dart';

class ProductSettingsProvider extends ChangeNotifier {
  late SelllerAllProductsModel selllerAllProductsModel;
  bool isViewAllProductsLoading = false;
  bool isChangeAvailibilityLoading = false;
  bool hasError = false;
  List<Product> onLoadProducts = [];
  List<Product>? allProducts = [];
  changeLoadingStatus(bool value) {
    isViewAllProductsLoading = value;
    notifyListeners();
  }

  updateChangeAvailibilityLoadingStatus(bool value) {
    isChangeAvailibilityLoading = value;
    notifyListeners();
  }

  void toggleStatus(index) {
    if (allProducts?[index].productStatus == "approved") {
      allProducts?[index].productStatus = "out_of_stock";
    } else {
      allProducts?[index].productStatus = "approved";
    }
    notifyListeners();
  }

  Future viewSellerAllProducts() async {
    try {
      changeLoadingStatus(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var sellercode = prefs.getString("sellercode");
      var url = Uri.parse(ApiData.sellerAllProducts);
      Map<String, dynamic> body = {};
      body['seller_code'] = sellercode.toString();
      var response = await http.post(url, headers: ApiData.header, body: body);
      if (response.statusCode == 200) {
        var decodedJson = jsonDecode(response.body);
        var data = SelllerAllProductsModel.fromJson(decodedJson);
        if (data.data![0].products!.isNotEmpty) {
          allProducts = data.data?[0].products;
          onLoadProducts = data.data![0].products!;
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

  Future changeProductAvailability(
      String? productCode, String? newStatus) async {
    try {
      updateChangeAvailibilityLoadingStatus(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var sellercode = prefs.getString("sellercode");
      var url = Uri.parse(ApiData.productStatusApi);
      Map<String, dynamic> body = {};
      body['seller_code'] = sellercode.toString();
      body['product_code'] = productCode;
      body['new_status'] = newStatus;
      var response = await http.post(url, headers: ApiData.header, body: body);
      if (response.statusCode == 200) {
        notifyListeners();
      } else {
        hasError = true;
      }
    } catch (e) {
      generalException();
      hasError = true;
    }
    updateChangeAvailibilityLoadingStatus(false);
  }

  void filterList(String value) {
    var valueList = onLoadProducts
        .where((e) => (e.productName
            .toString()
            .toLowerCase()
            .contains(value.trim().toLowerCase())))
        .toList();
    allProducts = valueList;
    notifyListeners();
  }

  void onInit() async {
    selllerAllProductsModel = SelllerAllProductsModel();
    viewSellerAllProducts();
  }
}
