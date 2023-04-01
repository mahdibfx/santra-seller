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

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/customers/delivery_charges.dart';
import '../../models/customers/view_all_customers.dart';
import '../../models/seller_all_products_model.dart';
import '../../utils/api_data.dart';

class CartController extends GetxController {
   bool isLoading = false;
   int deliveryCharges = 10;
   bool isShowCartButton = false;
   bool receiptPaymentType = true;
  final List<CartItem> cartItems = [];

  dynamic finalSubmitData;


  changeLoadingStatus(value) {
    isLoading = value;
    update();
  }

  void addToCart(CartItem item) {
    isShowCartButton = true;
    update();
    final index = cartItems.indexWhere((cartItem) => cartItem.code == item.code);
    if (index != -1) {
      cartItems[index].quantity += 1;
      update();
      showToast("Added",'increased by one');
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
        showToast("Added",'decreased by one');
      } else {
        cartItems.removeAt(index);
         update();
      }
    }
    if(cartItems.isEmpty){
      isShowCartButton = false;
      update();
    }
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

      subAmount +=
          (double.parse(element.price.toString()) * element.quantity) +
              modifierAmount;
      return subAmount;
    });
    print("sub$subAmount");
    return subAmount;
  }
  // double get totalPrice => cartItems.fold(
  //       0,
  //       (previousValue, cartItem) => previousValue + (cartItem.price +)* cartItem.quantity,
  //     );
      //  double get grandTotal => cartItems.fold(
      //   0,
      //   (previousValue, cartItem) => (previousValue + cartItem.price * cartItem.quantity) + deliveryCharges,
      // );
      double get grandTotal {
    double amount = 0;
    amount = totalPrice + deliveryCharges;

    return amount;
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
    '$msg',
    duration: Duration(seconds: 2),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.grey[900],
    colorText: Colors.white,
    icon: Icon(Icons.check_circle_outline, color: title != "Failed" ? Colors.green : Colors.red),
  );
}

addItemForCustomer(DeliveryChargesModel data, Customer customerDetail, String? sellerCode, bool receiptPaymentMethord) async {
  receiptPaymentType = receiptPaymentMethord;
 
    finalSubmitData  = {
      "customer_name": customerDetail.customerName, // This is the name of the customer
      "coupn_code": "0", // coupon code if any other wise send 0
      "sub_total": "$totalPrice", // This is the subtotal amount
      "total_delivery_charges": data.data?.first.deliveryCharges, //this is the delivery charges
      "total_discount": "0", //this is the discount if any otherwise send 0
      "d_reason": "no_discount", // If there is any discount otherwise send no_discount
      "d_type": "no_discount", //this is discount type otherwise send no_discount
      "seller_code": sellerCode, // this is seller code
      "c_number": customerDetail.customerMobile, //this is customer number
      "c_id": sellerCode, // send seller code here
      "user_id": customerDetail.id, // send customer id here
      "payment_method": "cash" , // Send cash
      "c_address": '${customerDetail.buildingType} ${customerDetail.buildingNumber} ${customerDetail.customerCity}', //Address of the customer
      "area_customer": "", // area of the customer
      "building_number": customerDetail.buildingNumber, // building  of the customer
      "order_remarks": "no_remarks", // order comments if any otherwise send no_remarks
      "user_tips": "0", // if any otherwise send 0
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
    update();
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
        // update();
           showToast("Success", 'Successfully Completed');
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

  CartItem({required this.name, required this.price, required this.code, required this.imageString, this.quantity = 1,required this.subModifiers});

  Map toJson() => {
        'id': code,
        'name': name,
        'price': price,
        'quantity': quantity,
        'item_remarks': "no remarks",
        'modifiers_list' : subModifiers
      };

}
