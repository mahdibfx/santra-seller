import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:santra_seller/models/customers/customer_reviews_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../ui/widgets/dialogs/custom_dialogs.dart';
import '../../utils/api_data.dart';
import '../../utils/uidata.dart';

class CustomerReviewsProvider with ChangeNotifier {
  bool isReviewsLoading = false;
  bool hasReviewsError = false;
  CustomerReviewsModel customerReviews = CustomerReviewsModel();
  updateCustomerLoadingState(bool value) {
    isReviewsLoading = value;
    notifyListeners();
  }

  List<Color> barColors = [
    UIDataColors.green,
    UIDataColors.greenLite,
    UIDataColors.amber,
    UIDataColors.pink,
    UIDataColors.orange,
  ];
  List<int> noOfStars = [5, 4, 3, 2, 1];
  Future viewCustomerReviews() async {
    try {
      updateCustomerLoadingState(true);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sellerCode = prefs.getString("sellercode");
      var url = Uri.parse(ApiData.customerReviewsApi);
      Map<String, dynamic> body = {};
      body['seller_code'] = sellerCode ?? "";
      var response = await http.post(url, body: body, headers: ApiData.header);
      if (response.statusCode == 200) {
        updateCustomerLoadingState(false);
        hasReviewsError = false;

        customerReviews = customerReviewsModelFromJson(response.body);

        print(response.body);
      } else {
        updateCustomerLoadingState(false);
        hasReviewsError = true;
      }
    } catch (e) {
      generalException();
    }
    updateCustomerLoadingState(false);
    notifyListeners();
  }
}
