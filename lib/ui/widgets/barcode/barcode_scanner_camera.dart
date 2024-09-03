import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/provider/barcode/barcode_provider.dart';

class BarcodeScannerCamera extends StatefulWidget {
  const BarcodeScannerCamera({Key? key}) : super(key: key);

  @override
  State<BarcodeScannerCamera> createState() => _BarcodeScannerCameraState();
}

class _BarcodeScannerCameraState extends State<BarcodeScannerCamera> {
  late MobileScannerController _mobileScannerController;

  @override
  void initState() {
    super.initState();
    _mobileScannerController = MobileScannerController(returnImage: true,);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BarcodeProvider>().chekCameraPermissions();
    });
  }

  @override
  void dispose() {
    _mobileScannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BarcodeProvider>(
      builder: (context, barcodeProvider, child) {
        if (barcodeProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!barcodeProvider.isCameraPermissionsGranted) {
          return Center(
            child: ElevatedButton(
              onPressed: () => barcodeProvider.demandPermissions(),
              child: const Text('Request Camera Permission'),
            ),
          );
        }

        return Container(
          width: 358.w,
          height: 233.h,
          decoration: const BoxDecoration(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                if (barcodeProvider.isScanning)
                  MobileScanner(
                    controller: _mobileScannerController,
                    errorBuilder: (context, error, child) {
                      log(error.toString());
                      return const Center(
                        child: Text('An error occurred. Please try again.'),
                      );
                    },
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      final Uint8List? image = capture.image;
                      if (barcodes.isNotEmpty && image != null) {
                        barcodeProvider.addBarcodeWithImage(
                          barcodes.first.rawValue ?? '',
                          image,
                        );
                      }
                    },
                    fit: BoxFit.cover,
                  )
                else if (barcodeProvider.lastImage != null)
                  Image.memory(
                    barcodeProvider.lastImage!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
       
              ],
            ),
          ),
        );
      },
    );
  }
}