import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerCamera extends StatefulWidget {
  const BarcodeScannerCamera({super.key});

  @override
  State<BarcodeScannerCamera> createState() => _BarcodeScannerCameraState();
}

class _BarcodeScannerCameraState extends State<BarcodeScannerCamera> {
  late MobileScannerController _mobileScannerController;

  @override
  void initState() {
    super.initState();
    _mobileScannerController = MobileScannerController(returnImage: true);
  }

  @override
  void dispose() {
    _mobileScannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 358.w,
      height: 233.h,
      decoration: const BoxDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: MobileScanner(
          controller: _mobileScannerController,
          errorBuilder: (context, error, child) {
            debugPrint('Camera error: ${error.errorDetails?.message}');
            return const Center(
              child: Text('An error occurred. Please try again.'),
            );
          },
          onDetect: (barcode) {
            // Handle barcode detection
          },
          fit: BoxFit.cover,
        ),
      ),
    );
  }


}