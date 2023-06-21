// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import '../../ui/widgets/dialogs/custom_dialogs.dart';
// import '../../utils/api_data.dart';

// class LanguageProvider extends ChangeNotifier {
//  bool changeLoadingStatus = true;
//  dynamic languageData;
// dynamic languageDataEng ;
//  dynamic languageDataAr ;
//   Map<String, dynamic> ?languageDataEngDynamic;
//   Map<String, dynamic> ?languageDataARdynamic;

//   void languageTextCall()async{
//     // try {
//       changeLoadingStatus =  true;
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       var url = Uri.parse(ApiData.languageSelection);
    
//       var response = await http.post(url, headers: ApiData.header);
//       if (response.statusCode == 200) {
//      var data = jsonDecode(response.body);
//      languageData = data['data'][0];
  

//         notifyListeners();
//            languageDataEngDynamic = languageData['en_us'];
//               notifyListeners();
//             languageDataEng =
//    jsonEncode(languageDataEngDynamic!.map((key, value) => MapEntry(key, value.toString())));
//    notifyListeners();
//            print(languageDataEng);
//             languageDataARdynamic = languageData['ar_AE'];
//               notifyListeners();
//                   languageDataAr =
//     jsonEncode(languageDataARdynamic!.map((key, value) => MapEntry(key, value.toString())));
//        notifyListeners();
//       // } else {

//     //   }
//     // } catch (e) {
//     //   generalException();

//     }
//     // changeLoadingStatus = false;
//   }
// }