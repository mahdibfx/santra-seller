import 'package:santra_seller/controllers/add_manual_order_controller.dart/add_manual_order_controller.dart';
import 'package:santra_seller/ui/widgets/buttons/icon_setting_button.dart';
import 'package:santra_seller/ui/widgets/textfields/common_textfield.dart';
import 'package:santra_seller/utils/uidata/textStyles.dart';
import '../../../utils/routes/app_routes.dart';
import '../../widgets/cards/product_edit_card.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/uidata.dart';

class ProductSettingScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  ProductSettingScreen({super.key});

  Widget bodyData(context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<AddManualOrderController>(
      builder: (manualOrderController) {
        return SafeArea(
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadingWithIcon(
                  icon: UIDATAIcons.dashboardIcon, btntxt: "Products"),
              CommonTextField(
                isTextHidden: false,
                prefixIcon: UIDATAIcons.searchIcon,
                fillcolor: Colors.white,
                labelText: "Search For a Product",
              ),
              SpacingHeight.heightlistspacing10,
              manualOrderController.isLoading
                  ? const SizedBox(
                      child: Center(
                      child: CircularProgressIndicator(),
                    ))
                  : manualOrderController.hasError
                      ? const Center(child: Text("No Products To Show"))
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Category Name",
                              style: UIDataTextStyles.h1,
                            ).paddingOnly(left: 10),
                            SpacingHeight.heightlistspacing10,
                            ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:
                                    manualOrderController.allProducts?.length,
                                itemBuilder: (context, index) {
                                  return ProductEditCard(
                                    manualOrderController:
                                        manualOrderController,
                                    index: index,
                                    title: manualOrderController
                                        .allProducts![index].productStatus
                                        .toString(),
                                    outOfStock: false,
                                    onChanged: (value) {},
                                  );
                                }),
                          ],
                        ),
            ],
          ).paddingOnly(left: 15, right: 15)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      bodyData: bodyData(context),
      backgroundcolor: UIDataColors.whiteColor,
      showDrawer: false,
      showFAB: true,
      centerDocked: true,
      showAppBar: true,
      // appBarAction: [IconButton(icon:Icon(Icons.sports_basketball) ,
      // onPressed: (){
      //   Get.toNamed(Routes.cartroute);
      // },)],
      showBottomNav: true,
      appbarcolor: UIDataColors.whiteColor,
      appbarSvg: true,
      backarrow: UIDataColors.primaryColor,
      qrCallback: () {
        Get.offAllNamed(Routes.addManualOrder);
      },
      floatingIcon: Icons.add,
      elevation: 0.0,
    );
  }
}
