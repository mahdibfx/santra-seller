import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class BarcodeProvider extends ChangeNotifier {
  final List<String> _barcodes = [];
  List<String> get barcodes => _barcodes;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isCameraPermissionsGranted = false;
  bool get isCameraPermissionsGranted => _isCameraPermissionsGranted;

  bool _isScanning = true;
  bool get isScanning => _isScanning;

  Uint8List? _lastImage;
  Uint8List? get lastImage => _lastImage;

  String? _lastBarcode;
  String? get lastBarcode => _lastBarcode;

  void loadCurrentBarCodes() {
    final List<String> barcodesList = ["3957382578753", "399548757845","3957382578753", "399548757845","3957382578753", "399548757845","3957382578753", "399548757845"];
    _barcodes.addAll(barcodesList);
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
    if(_barcodes.isEmpty){
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

  // This is used to link the barcodes to order
  void linkBarcodesToOrder() {
    // Implement the logic to link barcodes to an order
  }
}