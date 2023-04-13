import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santra_seller/models/customers/customer_reviews_model.dart';
import 'package:santra_seller/ui/screens/more_setting/customer_reviews.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../ui/widgets/dialogs/custom_dialogs.dart';
import '../../utils/api_data.dart';
import '../../utils/uidata.dart';

class CustomerReviewsController extends GetxController {
  bool isReviewsLoading = false;
  bool hasReviewsError = false;
  late CustomerReviewsModel customerReviews;
  updateCustomerLoadingState(bool value) {
    isReviewsLoading = value;
    update();
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
      body['seller_code'] = "110";
      var response = await http.post(url, body: body, headers: ApiData.header);
      if (response.statusCode == 200) {
        // var data = jsonDecode(response.body);
        customerReviews = customerReviewsModelFromJson(response.body);
      } else {
        hasReviewsError = true;
      }
    } catch (e) {
      generalException();
    }
    updateCustomerLoadingState(false);
  }

  @override
  void onInit() async {
    super.onInit();
    customerReviews = CustomerReviewsModel();
    viewCustomerReviews();
    update();
  }
}
