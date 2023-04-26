// ignore_for_file: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:santra_seller/provider/more_settings_provider/about_us_provider.dart';
import 'package:santra_seller/ui/widgets/buttons/icon_setting_button.dart';
import '../../../utils/uidata/textStyles.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/uidata.dart';
import '../add_manual_order/add_manual_order.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AboutUsProvider>(context, listen: false).aboutUsOnInit();
    });
  }

  Widget bodyData() {
    return Consumer<AboutUsProvider>(
      builder: (con, _, child) {
        return _.isLoading
            ? const SizedBox(
                child: Center(
                child: CircularProgressIndicator(),
              ))
            : SafeArea(
                child: SingleChildScrollView(
                    child: _.hasAboutUsError
                        ? const Text(
                            "Something Went Wrong, Please Try Again In a While")
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HeadingWithIcon(
                                  icon: UIDATAIcons.santraVectorIcon,
                                  btntxt: "About Us"),
                              Text(
                                _.aboutUsText ?? "No Data To Show",
                                style: UIDataTextStyles.title,
                                textAlign: TextAlign.justify,
                              ),
                              SpacingHeight.heightlistspacing50
                            ],
                          ).marginOnly(left: 20, right: 20)),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      bodyData: bodyData(),
      backgroundcolor: UIDataColors.whiteColor,
      backGroundImage: UIDataImage.backgroundImage,
      showDrawer: false,
      showFAB: true,
      centerDocked: true,
      showAppBar: true,
      scaffoldKey: _key,
      showBottomNav: true,
      appbarcolor: UIDataColors.whiteColor,
      appTitle: 'About Us',
      backarrow: UIDataColors.blackColor,
      qrCallback: () {
        Get.offAll(() => const AddManulOrder());
      },
      floatingIcon: Icons.add,
      elevation: 0.0,
    );
  }
}
