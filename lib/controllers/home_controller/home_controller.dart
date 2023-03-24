import 'dart:convert';

import 'package:get/get.dart';
import 'package:santra_seller/models/home_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ui/widgets/snackbar/common_snackbar.dart';
import '../../utils/api_data.dart';
import '../../utils/uidata.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  bool isLoading = true;
  String? sellerCode;
  HomeData? homeData;
  @override
  void onInit() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
    var sellercode = prefs.getString("sellercode");
    if (sellercode != null) {
      sellerCode = sellercode;
    }
    isLoading = true;
    update();
    homeDataCall();
    update();
    super.onInit();
  }

  homeDataCall() async{
    if (sellerCode !=null) {
      print(sellerCode);
      isLoading = true;
      update();
      try {
        var body = <String, String>{};
        body['seller_code'] = sellerCode!;
        var res =
            await http.post(Uri.parse("${ApiData.mainurl}seller_home"), body: body);
        if (res.statusCode == 200) {
          var data = jsonDecode(res.body);
          var newdata = HomeModel.fromJson(data);
          homeData = newdata.data[0];
          isLoading = false;
          update();
         
        } else {
          CommonSnackbar.getSnackbar(
              "Error", "Error ", UIDataColors.redColor);
        }
      } catch (e) {
        print("check error ${e}");
        isLoading = false;
        update();
        // Get.offAllNamed(Routes.homeRoutes);
        CommonSnackbar.getSnackbar(
            "Server Error",
            "Server Error or Please Check your internet connection",
            UIDataColors.redColor);
      }
    }
  }
}
