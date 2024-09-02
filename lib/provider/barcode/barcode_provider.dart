import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class BarcodeProvider  extends ChangeNotifier{

  final List<String> _barcodes = ['495t859440550','0945645087458','4386984968398'];
  List<String> get barcodes => _barcodes;

  bool _isLoading = true ; 
  bool get isLoading => _isLoading;
  late bool _isCameraPermissionsGranted;
bool get isCameraPermissionsGranted => _isCameraPermissionsGranted;
 chekCameraPermissions() async {
  _isCameraPermissionsGranted = await Permission.camera.isGranted;
  _isLoading = false ;
  notifyListeners();
}

  demandPermissions() async {
    _isLoading = true ; 
    final requestCameraPermissions = await Permission.camera.request();
    if(requestCameraPermissions.isGranted){
      _isCameraPermissionsGranted  = true ;  
    }else{
      _isCameraPermissionsGranted  = false ;  

    }

      _isLoading = false ;
notifyListeners();
  }
  addBarcode(String barcode){
if(!_barcodes.contains(barcode)){
    _barcodes.add(barcode);

}
    
    notifyListeners();

  }


  deleteBarcode(String barcode){
    _barcodes.remove(barcode);
    notifyListeners();
  }


}