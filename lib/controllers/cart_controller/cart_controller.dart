// import 'dart:convert';

// import 'package:get/get.dart';
// import 'package:santra_seller/utils/api_data.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../models/seller_all_products_model.dart';

// import 'dart:convert';

// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../models/seller_all_products_model.dart';
// import '../../ui/widgets/dialogs/custom_dialogs.dart';
// import '../../utils/api_data.dart';
// import '../cart_controller/cart_controller.dart';

// class CartController extends GetxController {
//   late SelllerAllProductsModel selllerAllProductsModel;
//   bool isLoading = false;
//   bool hasError = false;

//   List<Product>? allProducts = [];

//   changeLoadingStatus(bool value) {
//     isLoading = value;
//     update();
//   }

//   addItemToCart(Product product) {
//     allProducts!.add(product);
//     update();
//   }

//   Future viewSellerAllProducts() async {
//     try {
//       changeLoadingStatus(true);
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? sellerCode = prefs.getString('sellercode').toString();
//       var url = Uri.parse(ApiData.sellerAllProducts);
//       Map<String, dynamic> body = {};
//       body['seller_code'] = "190";
//       var response = await http.post(url, body: body);
//       if (response.statusCode == 200) {
//         var decodedJson = jsonDecode(response.body);
//         var data = SelllerAllProductsModel.fromJson(decodedJson);
//         if (data.data![0].products!.isNotEmpty) {
//           allProducts = data.data?[0].products;
//         }
//         selllerAllProductsModel =
//             selllerAllProductsModelFromJson(response.body);
//         update();
//       } else {
//         hasError = true;
//       }
//     } catch (e) {
//       generalException();
//       hasError = true;
//     }
//     changeLoadingStatus(false);
//   }

//   @override
//   void onInit() async {
//     isLoading = false;
//     super.onInit();
//     viewSellerAllProducts();
//     update();
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
   bool isLoading = false;
  final List<CartItem> cartItems = [];

  void addToCart(CartItem item) {
    final index = cartItems.indexWhere((cartItem) => cartItem.code == item.code);
    if (index != -1) {
      cartItems[index].quantity += 1;
      update();
      showToast('increased by one');
    } else {
      cartItems.add(item);
       update();
    }
  }

  void removeFromCart(CartItem item) {
    final index = cartItems.indexWhere((cartItem) => cartItem.code == item.code);
    if (index != -1) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity -= 1;
         update();
        showToast('decreased by one');
      } else {
        cartItems.removeAt(index);
         update();
      }
    }
  }

  double get totalPrice => cartItems.fold(
        0,
        (previousValue, cartItem) => previousValue + cartItem.price * cartItem.quantity,
      );

       void showToast(String msg) {
  Get.snackbar(
    'Added',
    '$msg',
    duration: Duration(seconds: 2),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.grey[900],
    colorText: Colors.white,
    icon: Icon(Icons.check_circle_outline, color: Colors.green),
  );
}
}

class CartItem {
  final String name;
  final String code;
  final double price;
  final String imageString;
  int quantity;

  CartItem({required this.name, required this.price, required this.code, required this.imageString, this.quantity = 1});
}