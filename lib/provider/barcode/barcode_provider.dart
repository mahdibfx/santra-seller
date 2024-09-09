import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:santra_seller/services/barcode_service.dart';
import 'package:santra_seller/ui/widgets/barcode/linked_succesfuly_bottomsheet.dart';
import 'package:santra_seller/ui/widgets/dialogs/custom_dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BarcodeProvider extends ChangeNotifier {
  final BarcodeService barcodeService;
  final List<String> _barcodes = [];
  final List<String> _alreadyBarcodes = [];

  BarcodeProvider({required this.barcodeService});
  List<String> get barcodes => _barcodes;

  List<String> get alreadyBarcodes => _alreadyBarcodes;

  bool _isLoading = true;
  bool get isLoading => _isLoading;
     bool _linkingOrders = false;
  bool get linkingOrders => _linkingOrders;

  bool _isCameraPermissionsGranted = false;
  bool get isCameraPermissionsGranted => _isCameraPermissionsGranted;

  bool _isScanning = true;
  bool get isScanning => _isScanning;

  Uint8List? _lastImage;
  Uint8List? get lastImage => _lastImage;

  String? _lastBarcode;
  String? get lastBarcode => _lastBarcode;

  Future<void> loadCurrentBarCodes(String orderNumber) async {
    _isLoading = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? sellerCode = prefs.getString("sellercode");

      final apiResponse =
          await barcodeService.viewOrderBarcodes(sellerCode!, orderNumber);

      if (apiResponse.status == true) {
        _alreadyBarcodes.clear();
        _barcodes.clear();
        final List<String> barCodesFromApi =
            List<String>.from(apiResponse.data.map((e) => e['bar_code']));
        _alreadyBarcodes.addAll(barCodesFromApi);
        _barcodes.addAll(barCodesFromApi);

        notifyListeners();
      }
    } catch (e) {
      log(e.toString());
      generalException();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> chekCameraPermissions() async {
    _isCameraPermissionsGranted = await Permission.camera.isGranted;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> demandPermissions() async {
    _isLoading = true;
    notifyListeners();

    final requestCameraPermissions = await Permission.camera.request();
    _isCameraPermissionsGranted = requestCameraPermissions.isGranted;

    _isLoading = false;
    notifyListeners();
  }

  void addBarcodeWithImage(String barcode, Uint8List image) {
    if (!_barcodes.contains(barcode)) {
      _barcodes.add(barcode);
    }
    _lastBarcode = barcode;
    _lastImage = image;
    _isScanning = false;
    notifyListeners();
  }

  void deleteBarcode(String barcode) {
    _barcodes.remove(barcode);
    if (_barcodes.isEmpty) {
      resumeScanning();
    }
    notifyListeners();
  }

  void resumeScanning() {
    _isScanning = true;
    _lastImage = null;
    _lastBarcode = null;
    notifyListeners();
  }

//

  loadExistingBarCodesToFrontendForModification() {
    _barcodes.clear();
    _barcodes.addAll(_alreadyBarcodes);
  }

  // This is used to link the barcodes to order
  Future<void> linkBarcodesToOrder(String orderNumber) async {
    // Implement the logic to link barcodes to an order
  _linkingOrders = true ;
  notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? sellerCode = prefs.getString("sellercode")!;
    try {
      final apiResponse =
          await barcodeService.linkBarcodes(_barcodes, sellerCode, orderNumber);

      if (apiResponse.status == true) {
        _alreadyBarcodes.clear();
        _alreadyBarcodes.addAll(_barcodes);
        notifyListeners();
        Get.bottomSheet(
            Container(
                constraints: BoxConstraints(maxHeight: 257.h),
                child:  LinkedSuccesfulyBottomsheet(orderNumber: orderNumber,)),
            elevation: 20.0);
      } else {
        exceptionDialog("OOPs !", apiResponse.errorMessage!);
      }
    } catch (e) {
      generalException();
    }
_linkingOrders = false ;notifyListeners();
  }

}
