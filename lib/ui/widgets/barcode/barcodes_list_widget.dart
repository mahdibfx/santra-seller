import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/provider/barcode/barcode_provider.dart';
import 'package:santra_seller/ui/widgets/barcode/added_barcode_widget.dart';

class BarcodesListWidget extends StatelessWidget {
  const BarcodesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BarcodeProvider>(builder: (context, provider, child) {
      if (provider.barcodes.isNotEmpty) {
        return ListView.builder(
          itemBuilder: (context, index) => AddedBarcodeWidget(barcode: provider.barcodes[index],),
          itemCount: provider.barcodes.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        );
      }
      return const SizedBox();
    });
  }
}
