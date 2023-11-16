import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/constants/areas_lists.dart';
import 'package:santra_seller/models/customers/view_all_customers.dart';
import 'package:santra_seller/provider/cart_provider.dart';
import 'package:santra_seller/provider/home_provider.dart';
import 'package:santra_seller/ui/screens/more_setting/my_customer/my_customer_screen.dart';
import 'package:santra_seller/ui/widgets/dialogs/custom_dialogs.dart';
import 'package:santra_seller/utils/api_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../models/customers/delivery_charges.dart';
import '../../ui/screens/more_setting/my_customer/view_customer_details.dart';
import '../../ui/screens/order_detail/manual_order_screen.dart';
import '../../utils/app_translation/app_translation.dart';

class MyCustomerProvider extends ChangeNotifier {
  TextEditingController link = TextEditingController();

  Map<String, List<String>> cityAreas = {
    'Dubai': AreasList.dubaiAreas,
    'Sharjah': AreasList.sharjahAreas,
    "Ajman": AreasList.ajmanAreas,
    'Umm Ul Quwain': AreasList.ummUlQuwainAreas,
    'Fujairah': AreasList.fujairahAreas,
    "Al Ain": AreasList.alAinAreas,
    'Abu Dhabi': AreasList.abuDhabiAreas,
    'Ras Al Khaimah': AreasList.rasAlKhaimahAreas
  };
  List<String> cityList = [];
  setCities() {
    cityList.clear();
    cityAreas.forEach((key, value) {
      cityList.add(key);
    });
    notifyListeners();
  }

  clearCityAndArea() {
    city = "Dubai";
    area = 'Sonapur';
    notifyListeners();
  }

  List<String> areas = [
    'Sonapur',
    'Deira',
    'Dubai Police General Head Quarters',
    'Deira Clocktower',
    'Al Maktoum Rd',
    'Baniyas Rd',
    'Abu Baker Al Siddique Rd',
    'Mall of the Emirates',
    'Bur Dubai',
    'Dubai Courts',
    'Al Diyafah Street',
    'Sheikh Zayed Rd',
    'Downtown',
    'Burj Khalifa',
    'DUBAI MALL',
    'Uptown Mirdif',
    'Al Khawaneej',
    'Al Khawaneej (Farms)',
    'Al Khawaneej (Residential)',
    'Al Mizhar 1',
    'Al Mizhar 2',
    'Al Mizhar - 269',
    'Al Warqa-a 1',
    'Al Warqa-a 2',
    'Al Warqa-a 3',
    'Al Warqa-a 4',
    'Al Warqa-a 5 (Dubai Safari)',
    'Midtown',
    'Mirdif',
    'Mirdif Hills',
    'Muhaisnah 1',
    'Muhaisnah 2',
    'Muhaisnah 3',
    'Muhaisnah 4',
    'Oud Al Muteena 1',
    'Oud al Muteena 2',
    'Ghoroob Mirdif',
    'Shorooq Mirdif',
    'Mushraif',
    'Umm Ramool',
    'Abu Hail',
    'Al Baraha',
    'Al Garhoud',
    'Al Hamriya',
    'Al Hamriya Port',
    'Al Khabaisi',
    'Al Mamzar',
    'Al Muraqqabat',
    'Al Murar',
    'Al Muteena',
    'Al Nahda 1',
    'Al Nahda 2',
    'Al Qusais 1',
    'Al Qusais 2',
    'Al Qusais 3',
    'Al Qusais Industrial Area 1',
    'Al Qusais Industrial Area 2',
    'Al Qusais Industrial Area 3',
    'Al Qusais Industrial Area 4',
    'Al Qusais Industrial Area 5',
    'Al Qusais Labour Area - 267',
    'Al Qusais Labour Area - 268',
    'Al Ras',
    'Al Rashidiya',
    'Al Rigga',
    'Al Shindagha',
    'Al Souq Al Kabeer',
    'Al Twar 1',
    'Al Twar 2',
    'Al Twar 3',
    'Al Sabkha',
    'Al Wuheida',
    'Dubai Maritime City',
    'Dubai Airport Free Zone (DAFZA)',
    'Dubai International Airport',
    'Dubai Festival City (DFC)',
    'Nad Al Hammar Gardens',
    'Nadd Al Hamar',
    'Nadd Al Hamar - 417',
    'Nadd Shamma',
    'Naif',
    'Ras Al Khor',
    'Ras Al Khor Industrial Area 1',
    'Ras Al Khor Industrial Area 2',
    'Ras Al Khor Industrial Area 3',
    'Riggat Al Buteen',
    'Corniche Deira',
    'Deira Islands (Palm Deira)',
    'Hor Al Anz',
    'Hor Al Anz East',
    'Port Saeed',
    'Ayal Nasir',
    'Dubai Creek Harbour',
    'Dubai Harbour',
    'Al Buteen',
    'Al Daghaya',
    'Warsan 2',
    'Warsan 3',
    'Warsan Village',
    'Zayed University',
    'The Villa',
    'Al Barari',
    'Al Barsha 1',
    'Al Barsha 2',
    'Al Barsha 3',
    'Al Barsha South 1',
    'Al Barsha South 2',
    'Al Barsha South 3',
    'Arabian Ranches',
    'Arabian Ranches 2',
    'Arabian Ranches 2 - Azalea',
    'Arabian Ranches 2 - Casa Villas',
    'Arabian Ranches 2 - Lila Villas',
    'Arabian Ranches 2 - Palma Villas',
    'Arabian Ranches 2 - Rasha Villas',
    'Arabian Ranches 2 - Reem',
    'Arabian Ranches 2 - Rosa Villas',
    'Arabian Ranches 2 - Samara',
    'Arabian Ranches 2 - Yasmin Villas',
    'Arabian Ranches - Alma',
    'Arabian Ranches - Al Mahra',
    'Arabian Ranches - Al Reem 1',
    'Arabian Ranches - Al Reem 2',
    'Arabian Ranches - Al Reem 3',
    'Arabian Ranches - Alvorada 1',
    'Arabian Ranches - Alvorada 2',
    'Arabian Ranches - Alvorada 3',
    'Arabian Ranches - Alvorada 4',
    'Arabian Ranches - Aseel',
    'Arabian Ranches - Hattan',
    'Arabian Ranches - La Colleccion 1',
    'Arabian Ranches - La Colleccion 2',
    'Arabian Ranches - Mirador',
    'Arabian Ranches - Palmera 1',
    'Arabian Ranches - Palmera 2',
    'Arabian Ranches - Palmera 3',
    'Arabian Ranches - Palmera 4',
    'Arabian Ranches - Saheel',
    'Arabian Ranches - Savannah',
    'Arabian Ranches - Terra Nova',
    'Arjan',
    'Al Ruwayyah',
    'Dubai Academic City (DAC)',
    'Dubai Land',
    'Dubai Outsource Zone (DOZ)',
    'Dubai Sports City',
    'Dubai Studio City 1',
    'Dubai Land Residence Complex',
    'Liwan',
    'Meydan',
    'Meydan Grand Views',
    'Meydan Heights',
    'Meydan Horizon',
    'Meydan Metropolis',
    'Meydan Millennium Estates',
    'Nadd Al Shiba 1',
    'Nadd Al Shiba 2',
    'Nadd Al Shiba 3',
    'Nadd Al Shiba 4',
    'Dubai Silicon Oasis (DSO)',
    'Global Village',
    'International City (IC)',
    'International City (IC) Phase 2',
    'International Media Production Zone (IMPZ)',
    'Legends Dubailand',
    'Remraam',
    'Tecom',
    'Mohammed Bin Rashid City',
    'Mohammed Bin Rashid City - District 1',
    'Mohammed Bin Rashid City - District 11',
    'Mudon',
    'Nshama Town Square',
    'Reem',
    'Reem Mira 1',
    'Reem Mira 2',
    'Reem Mira 3',
    'Reem Mira 4',
    'Reem Mira 5',
    'Reem Mira Community Center',
    'Reem Mira Oasis 1',
    'Reem Mira Oasis 2',
    'Reem Mira Oasis 3',
    'Riverside',
    'Semmer Villas',
    'Serena',
    'Villanova',
    'Uptown Motor City',
    'Tilal Al Ghaf',
    'The Plantation Equestrian and Polo Club',
    'Textile City',
    'Majan',
    'Layan',
    'Jumeirah Golf Estates',
    'Golf City',
    'Falcon City of Wonders',
    'DUBIOTECH',
    'Dubai Sustainable City',
    'Dubai South Golf District',
    'Akoya',
    'Akoya Oxygen',
    'Al Habtoor Polo Resort & Club',
    'Business Park Motor City',
    'Cedre Villas',
    'City of Arabia',
    'Culture Village',
    'Dubai Design District',
    'Dubai Hills Estate',
    'Dubai Lifestyle City',
    'Dubai Motor City',
    'Dubai Polo & Equestrian Club',
    'Umm Suqeim 1',
    'Umm Suqeim 2',
    'Umm Suqeim 3',
    'Umm Hurair 1',
    'Umm Hurair 2',
    'Umm Al Sheif',
    'Al Bada-a',
    'Al Hudaiba',
    'Al Jaddaf',
    'Al Jafiliya',
    'Al Karama',
    'Al Manara',
    'Al Mankhool',
    'Al Mina',
    'Al Raffa',
    'Al Safa 1',
    'Al Safa 2',
    'Al Satwa',
    'Al Wasl',
    'Jumeirah 1',
    'Jumeirah 2',
    'Jumeirah 3',
    'Oud Metha',
    'Rukan',
    'Marsa Al Seef',
    'La Mer',
    'Al Kifaf',
    'Dubai Healthcare City 2 (DHCC 2)',
    'Dubai Healthcare City (DHCC)',
    'Dubai Pearl',
    'Porto Dubai',
    'Zaabeel 1',
    'Zaabeel 2',
    'Trade Centre 1',
    'Trade Centre 2',
    'The Springs',
    'The Springs 1',
    'The Springs 10',
    'The Springs 11',
    'The Springs 12',
    'The Springs 14',
    'The Springs 15',
    'The Springs 2',
    'The Springs 3',
    'The Springs 4',
    'The Springs 5',
    'The Springs 6',
    'The Springs 7',
    'The Springs 8',
    'The Springs 9',
    'Al Khail Gate',
    'Al Maktoum International Airport',
    'Al Quoz 1',
    'Al Quoz 2',
    'Al Quoz 3',
    'Al Quoz 4',
    'Al Quoz Industrial Area 1',
    'Al Quoz Industrial Area 2',
    'Al Quoz Industrial Area 3',
    'Al Quoz Industrial Area 4',
    'Al Sufouh 1',
    'Al Sufouh 2',
    'Al Waha Villas',
    'Jebel Ali',
    'Jebel Ali Business Centre',
    'Jebel Ali Free Zone (JAFZA)',
    'Jebel Ali Hills',
    'Jebel Ali Horse Racecourse',
    'Jebel Ali Industrial Area 1',
    'Jebel Ali Industrial Area 2',
    'Jebel Ali Industrial Area 3',
    'Jebel Ali South Zone 1',
    'Jebel Ali South Zone 2',
    'Jebel Ali South Zone 3',
    'Jebel Ali South Zone 4',
    'Jebel Ali South Zone 5',
    'Jebel Ali South Zone 6',
    'Jebel Ali Village',
    'Discovery Gardens',
    'DMCCA Free Zone South',
    'DMCC Business Park',
    'DMCC Enterprise Zone 1',
    'Downtown Dubai',
    'Downtown Jebel Ali',
    'Dubai Marina',
    'Dubai Media City (DMC)',
    'Dubai Parks and Resorts',
    'Dubai International Financial Centre (DIFC)',
    'Dubai Investment Park 1 (DIP 1)',
    'Dubai Investment Park 2 (DIP 2)',
    'Dubai Knowledge Village (KV)',
    'Dubai Internet City (DIC)',
    'Jumeirah Beach Residence (JBR)',
    'Jumeirah Lakes Towers (JLT)',
    'Jumeirah Park',
    'Jumeirah Village (JVC)',
    'Jumeirah Village Triangle (JVT)',
    'The Meadows',
    'The Meadows 1',
    'The Meadows 2',
    'The Meadows 3',
    'The Meadows 4',
    'The Meadows 5',
    'The Meadows 6',
    'The Meadows 7',
    'The Meadows 8',
    'The Meadows 9',
    'Al Furjan',
    'Business Bay',
    'Emaar Business Park',
    'Emirates Hills',
    'Palm Jebel Ali',
    'Palm Jumeirah',
    'Pearl Jumeirah',
    'Emirates Golf Club',
    'Jumeirah Bay Island',
    'Nakheel Harbour',
    'National Industries Park (Techno Park)',
    'Palma Spring Village',
    'Royal Estates',
    'Veneto',
    'The World',
    'The Views',
    'The Lakes - Zulal',
    'The Lakes',
    'The Lakes - Deema',
    'The Lakes - Forat',
    'The Lakes - Ghadeer Community',
    'The Lakes - Hattan 1',
    'The Lakes - Hattan 2',
    'The Lakes - Maeen',
    'The Greens',
    'The Gardens',
    'Logo Islands',
    'Jumeirah Islands',
    'Jumeirah Heights',
    'Island',
    'Green community East',
    'Green Community Motor City',
    'Green community West',
    'Garden View Villas',
    'Ewan Residences',
    'Dubai South Residential District',
    'Dubai South Logistic District',
    'Dubai South Exhibition District',
    'Dubai South Commercial District',
    'Dubai South Business Park',
    'Dubai South Aviation District',
    'Acacia Avenues',
    'Al Falaj Villas',
    'Badrah',
    'Bluewaters Island',
    'Desert Springs Village',
    'Dubai Industrial City',
    'Dubai Lagoon'
  ];
  getAreas(String? city) {
    area = null;
    areas.clear();
    List<String>? a = cityAreas[city?.trim()]?.toList();
    areas = a ?? [];
    area = areas[0];
    notifyListeners();
  }

  bool isViewCustomerLoading = false;
  bool hasViewCustomerError = false;
  bool isShowDetailScreen = false;
  bool isLoaderShowDeleteCustumer = true;
  bool isSubmitOrder = false;
  late ViewAllCustomers viewAllCustomers;
  List<String>? citiesList = [];
  String? city = 'Dubai';
  String? area = 'Sonapur';
  List<Customer> allNewCustomers = [];
  List<Customer>? allFilterCustomers = [];
  bool isAddCustomerLoading = false;
  bool isUpdateCustomerLoading = false;
  bool receiptPaymentMethord = false;
  bool onlinePayment = true;
  dynamic finalSubmitData;
  String? cidForUpdate;
  bool popupPaymentlink = false;
  RegExp emailRegex = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );
  updateCustomerLoadingState(bool value) {
    isViewCustomerLoading = value;
    notifyListeners();
  }

  var phoneMask = MaskTextInputFormatter(
      mask: '971#########',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
  String? phoneCon;
  TextEditingController fnController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController buildingController = TextEditingController();
  TextEditingController aptController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  updateAddLoadingState(bool value) {
    isAddCustomerLoading = value;
    notifyListeners();
  }

  updateLoadingState(bool value) {
    isUpdateCustomerLoading = value;
    notifyListeners();
  }

  void disposeValues() {
    receiptPaymentMethord = false;
    onlinePayment = true;
    city = "Dubai";
    area = "Sonapur";
    phoneCon = null;
    fnController.clear();
    mobileController.clear();
    emailController.clear();
    buildingController.clear();
    aptController.clear();
    addressController.clear();
    cidForUpdate = null;
    notifyListeners();
  }

  setValuesForEdit(index) {
    cidForUpdate = allFilterCustomers?[index].id;
    fnController.text = allFilterCustomers?[index].customerName ?? "";
    mobileController.text = allFilterCustomers?[index].customerMobile ?? "";
    emailController.text = allFilterCustomers?[index].customerEmail ?? "";
    buildingController.text = allFilterCustomers?[index].buildingNumber ?? "";
    aptController.text = allFilterCustomers?[index].buildingType ?? "";
    addressController.text = allFilterCustomers?[index].addressLink ?? "";
    city = allFilterCustomers?[index].customerCity ?? "";
    getAreas(city);
    area = allFilterCustomers?[index].customerArea ?? "";
    // if (area == null) getAreas(city ?? "");
    notifyListeners();
  }

  isComingFromCart(bool value) {
    isShowDetailScreen = value;
    disposeValues();
    notifyListeners();
  }

  Future updateCustomer() async {
    try {
      updateLoadingState(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sellerCode = prefs.getString("sellercode");
      var url = Uri.parse(ApiData.updateCustomer);
      var request = http.MultipartRequest('POST', url);
      var body = <String, String>{};
      body['seller_code'] = sellerCode ?? "";
      body['customer_id'] = cidForUpdate.toString();
      body['customer_name'] = fnController.text;
      body['customer_mobile'] = mobileController.text;
      body['customer_email'] = emailController.text;
      body['customer_city'] = city ?? "";
      body['customer_area'] = area ?? "";
      body['building_number'] = buildingController.text;
      body['building_type'] = aptController.text;
      body['address_link'] = addressController.text;
      request.fields.addAll(body);
      request.headers.addAll(ApiData.header);
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        disposeValues();
        Get.off(() => const MyCustomerScreen());
        viewCustomers();
      } else {
        generalException();
      }
    } catch (err) {
      generalException();
    }

    updateLoadingState(false);
    notifyListeners();
  }

  Future addCustomer() async {
    try {
      updateAddLoadingState(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sellerCode = prefs.getString("sellercode");
      var url = Uri.parse(ApiData.addCustomer);
      var request = http.MultipartRequest('POST', url);
      var body = <String, String>{};
      body['seller_code'] = sellerCode ?? "";
      body['customer_name'] = fnController.text;
      body['customer_mobile'] = mobileController.text;
      body['customer_email'] =
          emailController.text.isEmpty ? "" : emailController.text;
      body['customer_city'] = city ?? "";
      body['customer_area'] = area ?? "";
      body['building_number'] = buildingController.text;
      body['building_type'] = aptController.text;
      body['address_link'] = addressController.text;
      request.fields.addAll(body);
      request.headers.addAll(ApiData.header);
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var id = data['data']['user_id'];

        updateAddLoadingState(false);
        if (isShowDetailScreen) {
          Get.off(() => ViewCustomerDetails(
                customerDetail: Customer(
                  id: id,
                  customerCity: city ?? "",
                  customerEmail: emailController.text.isNotEmpty
                      ? emailController.text
                      : "",
                  customerMobile: mobileController.text.isNotEmpty
                      ? mobileController.text
                      : "",
                  customerName:
                      fnController.text.isNotEmpty ? fnController.text : "",
                  customerArea: area ?? "",
                  buildingType:
                      aptController.text.isNotEmpty ? aptController.text : "",
                  addressLink: addressController.text.isNotEmpty
                      ? addressController.text
                      : "",
                ),
              ));
        } else {
          disposeValues();
          Get.off(() => const MyCustomerScreen());
          viewCustomers();
        }
      } else {
        generalException();
      }
    } catch (err) {
      generalException();
    }

    updateAddLoadingState(false);
    notifyListeners();
  }

  Future viewCustomers() async {
    isLoaderShowDeleteCustumer = true;
    notifyListeners();
    allFilterCustomers!.clear();
    isLoaderShowDeleteCustumer = true;
    notifyListeners();
    try {
      updateCustomerLoadingState(true);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sellerCode = prefs.getString("sellercode");
      var url = Uri.parse(ApiData.customerListApi);
      Map<String, dynamic> body = {};
      body['seller_code'] = sellerCode;
      var response = await http.post(url, headers: ApiData.header, body: body);
      if (response.statusCode == 200) {
        var decodedJson = jsonDecode(response.body);
        var data = ViewAllCustomers.fromJson(decodedJson);
        allNewCustomers = data.data![0].customers!.toList();
        allFilterCustomers = allNewCustomers;
        notifyListeners();
        citiesList = data.data?[0].cities?.toList();
        // viewAllCustomers = viewAllCustomersFromJson(response.body);
        notifyListeners();
      } else {
        hasViewCustomerError = true;
      }
    } catch (e) {
      generalException();
    }
    isLoaderShowDeleteCustumer = false;
    updateCustomerLoadingState(false);
    notifyListeners();
  }

  void filterList(String value) {
    var valueList = allNewCustomers
        .where((e) => (e.customerName
            .toString()
            .toLowerCase()
            .contains(value.trim().toLowerCase())))
        .toList();
    allFilterCustomers = valueList;
    notifyListeners();
  }

  Future<bool> customerInfoSubmitedRequest(
      Customer customerDetail, context) async {
    var tr = Get.put(AppTranslations());
    isSubmitOrder = true;
    notifyListeners();
    try {
      // updateCustomerLoadingState(true);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sellerCode = prefs.getString("sellercode");
      var url = Uri.parse(ApiData.deliveryCharges);
      Map<String, dynamic> body = {};
      body['seller_code'] = sellerCode;
      var response = await http.post(url, headers: ApiData.header, body: body);
      if (response.statusCode == 200) {
        var decodedJson = jsonDecode(response.body);
        var data = DeliveryChargesModel.fromJson(decodedJson);
        if (receiptPaymentMethord) {
          var cartProvider = Provider.of<CartProvider>(context, listen: false);

          cartProvider.addItemForCustomerCart(
              data, customerDetail, sellerCode, receiptPaymentMethord);
          await cartProvider.orderSubmit();
          isSubmitOrder = false;
          notifyListeners();
          appFlyerController.codEvent();
          return false;
        } else {
          return await addItemForCustomerLink(
              data, customerDetail, sellerCode, context);
        }
      } else {
        showToast(
            tr.translateData("failed_message"), tr.translateData('went_wrong'));
        isSubmitOrder = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      showToast(
          tr.translateData("failed_message"), tr.translateData('went_wrong'));
      generalException();
      updateCustomerLoadingState(false);
      isSubmitOrder = true;
      notifyListeners();
      return false;
    }
  }

  Future<bool> orderSubmitByLink(context) async {
    var tr = Get.put(AppTranslations());
    var cartProvider = Provider.of<CartProvider>(context, listen: false);
    var homePro = Provider.of<HomeProvider>(context, listen: false);

    isSubmitOrder = true;
    notifyListeners();
    try {
      // updateCustomerLoadingState(true);
      var url = Uri.parse(ApiData.generateLink);
      var response =
          await http.post(url, headers: ApiData.header, body: finalSubmitData);
      if (response.statusCode == 200) {
        appFlyerController.paymentLinkEvent();
        var decodedJson = jsonDecode(response.body);
        link.text = decodedJson['data'].first['payment_link'];
        cartProvider.flushCart();
        disposeValues();
        showToast(tr.translateData("success_message"),
            tr.translateData('order_placed_success'));
        isSubmitOrder = false;
        popupPaymentlink = true;
        notifyListeners();
        homePro.homeDataCall();
        Get.offAll(() => const ManualOrderScreen());
        return true;
      } else {
        showToast(
            tr.translateData("failed_message"), tr.translateData('went_wrong'));
        isSubmitOrder = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      showToast("Failed", 'Try again later, Unable to proceed');
      isSubmitOrder = false;
      notifyListeners();

      return false;
    }
  }

  Future<bool> addItemForCustomerLink(DeliveryChargesModel data,
      Customer customerDetail, String? sellerCode, context) async {
    var cartProvider = Provider.of<CartProvider>(context, listen: false);

    finalSubmitData = {
      "customer_name":
          customerDetail.customerName, // This is the name of the customer
      "coupn_code": "0", // coupon code if any other wise send 0
      "sub_total": "${cartProvider.totalPrice}", // This is the subtotal amount
      "total_delivery_charges":
          cartProvider.delivery(), //this is the delivery charges
      "total_discount": cartProvider.dis
          .toString(), //this is the discount if any otherwise send 0
      "d_reason": cartProvider.voucherListVoucherCode ??
          cartProvider.voucherCode ??
          "no_discount", // If there is any discount otherwise send no_discount
      // "d_type":
      //     "no_discount", //this is discount type otherwise send no_discount
      "seller_code": sellerCode, // this is seller code
      "c_number": customerDetail.customerMobile, //this is customer number
      "c_id": sellerCode, // send seller code here
      "user_id": customerDetail.id, // send customer id here
      "payment_method": "online_paid", // Send cash
      "c_address":
          '${customerDetail.buildingType} ${customerDetail.buildingNumber} ${customerDetail.customerCity}', //Address of the customer
      "area_customer": customerDetail.customerCity, // area of the customer
      "building_number":
          customerDetail.customerArea, // building  of the customer
      "order_remarks":
          "no_remarks", // order comments if any otherwise send no_remarks
      "user_tips": "0", // if any otherwise send 0
      "order_schedule": cartProvider.deliveryDate ?? "",
// Order Item array to be posted as follows
// Field name: "", order_items and items in this array are as follows(id, name, price, quantity, item_remarks, modifiers_list(modifier_code,name_modifier,price_modifier))
      "order_items": jsonEncode(cartProvider.cartItems),
      "delivery_type": cartProvider.deliveryMethod,
      "tax_value": cartProvider.vatTax.toString()
    };
    print(finalSubmitData);
    return await orderSubmitByLink(context);
  }

  Future deleteCustomers(String customerID) async {
    isLoaderShowDeleteCustumer = true;
    notifyListeners();
    try {
      updateCustomerLoadingState(true);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sellerCode = prefs.getString("sellercode");
      var url = Uri.parse(ApiData.deleteCustomerApi);
      Map<String, dynamic> body = {};
      body['seller_code'] = sellerCode;
      body['customer_id'] = customerID;
      var response = await http.post(url, headers: ApiData.header, body: body);
      if (response.statusCode == 200) {
        var decodedJson = jsonDecode(response.body);
        print(decodedJson);

        Get.to(() => const MyCustomerScreen());
        await viewCustomers();
        showToast("Success", 'Successfully deleted customer');
        notifyListeners();
      } else {
        hasViewCustomerError = true;
      }
    } catch (e) {
      generalException();
    }
    updateCustomerLoadingState(false);
    notifyListeners();
  }

  paymentMethodReceipt() {
    receiptPaymentMethord = true;
    onlinePayment = false;
    notifyListeners();
  }

  paymentMethodOnline() {
    receiptPaymentMethord = false;
    onlinePayment = true;
    notifyListeners();
  }

  onInit() async {
    isLoaderShowDeleteCustumer = true;
    notifyListeners();
    viewAllCustomers = ViewAllCustomers();
    viewCustomers();
    notifyListeners();
  }

  void showToast(String title, String msg) {
    Get.snackbar(
      title,
      msg,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.grey[900],
      colorText: Colors.white,
      icon: Icon(Icons.check_circle_outline,
          color: title != "Failed" ? Colors.green : Colors.red),
    );
  }
}
