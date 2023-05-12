import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/ui/screens/add_manual_order/add_manual_order.dart';
import 'package:santra_seller/ui/widgets/buttons/icon_setting_button.dart';
import 'package:santra_seller/ui/widgets/textfields/common_textfield.dart';
import 'package:santra_seller/utils/app_translation/app_translation.dart';
import '../../../provider/more_settings_provider/product_setting_provider.dart';
import '../../widgets/cards/product_edit_card.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/uidata.dart';

class ProductSettingScreen extends StatefulWidget {
  ProductSettingScreen({super.key});

  @override
  State<ProductSettingScreen> createState() => _ProductSettingScreenState();
}

class _ProductSettingScreenState extends State<ProductSettingScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  Widget bodyData(context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<AppTranslations>(
      builder: (tr) {
        return Consumer<ProductSettingsProvider>(
          builder: (context, pSettings, child) {
            return ModalProgressHUD(
              color: Colors.grey.withOpacity(1),
              inAsyncCall: pSettings.isChangeAvailibilityLoading ? true : false,
              progressIndicator: const CircularProgressIndicator(),
              child: SafeArea(
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeadingWithIcon(
                        icon: UIDATAIcons.dashboardIcon, btntxt: tr.translateData("products_title")),
                    CommonTextField(
                      isTextHidden: false,
                      prefixIcon: UIDATAIcons.searchIcon,
                      fillcolor: Colors.white,
                      labelText: tr.translateData("add_order_search"),
                      onChanged: (value) {
                        pSettings.filterList(value);
                      },
                    ),
                    SpacingHeight.heightlistspacing10,
                    pSettings.isViewAllProductsLoading
                        ? const SizedBox(
                            child: Center(
                            child: CircularProgressIndicator(),
                          ))
                        : pSettings.allProducts!.isEmpty
                            ?  Center(child: Text(tr.translateData("no_products")))
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // const Text(
                                  //   "Category Name",
                                  //   style: UIDataTextStyles.h1,
                                  // ).paddingOnly(left: 10),
                                  SpacingHeight.heightlistspacing10,
                                  ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: pSettings.allProducts?.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            ProductEditCard(
                                              productSettingsController: pSettings,
                                              index: index,
                                              title: pSettings
                                                  .allProducts![index].productStatus
                                                  .toString(),
                                            ),
                                            SpacingHeight.heightlistspacing20
                                          ],
                                        );
                                      }),
                                ],
                              ),
                    SpacingHeight.heightlistspacing50
                  ],
                ).paddingOnly(left: 15, right: 15)),
              ),
            );
          },
        );
      }
    );
  }

  hitAllApis() async {
    await Future.microtask(
        () => context.read<ProductSettingsProvider>().onInit());
  }

  @override
  void initState() {
    hitAllApis();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      bodyData: bodyData(context),
      backgroundcolor: UIDataColors.whiteColor,
      backGroundImage: UIDataImage.backgroundImage,
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
        Get.offAll(() => const AddManulOrder());
      },
      floatingIcon: Icons.add,
      elevation: 0.0,
    );
  }
}
