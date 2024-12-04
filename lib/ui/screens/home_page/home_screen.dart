// ignore_for_file: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:santra_seller/provider/home_provider.dart';
import 'package:santra_seller/ui/screens/home_page/widgets/body_data.dart';
import '../../../utils/app_translation/app_translation.dart';
import '../../widgets/scaffold/common_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/uidata.dart';
import '../add_manual_order/add_manual_order.dart';

final tr = Get.put(AppTranslations());

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  var notify = true;





  hitAllApis() async {
    await Future.microtask(() => context.read<HomeProvider>().onInit());
  }

  @override
  void initState() {
    hitAllApis();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, _, child) {
      return CommonScaffold(
        bodyData: bodyData(context,notify),
        backgroundcolor: UIDataColors.whiteColor,
        backGroundImage: UIDataImage.backgroundImage,
        isBackArrowShow: false,
        showDrawer: false,
        isAddManual: _.isLoading,
        isMore: _.isLoading,
        showFAB: true,
        centerDocked: true,
        showAppBar: true,
        scaffoldKey: _key,
        showBottomNav: true,
        appbarcolor: UIDataColors.whiteColor,
        appbarSvg: true,
        backarrow: UIDataColors.blackColor,
        isHome: true,
        qrCallback: () {
          Get.offAll(() => const AddManulOrder());
        },
        floatingIcon: Icons.add,
        elevation: 0.0,
      );
    });
  }
}
