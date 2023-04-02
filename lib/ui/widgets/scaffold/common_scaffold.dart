// flutter imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// package imports
import 'package:get/get.dart';
import 'package:santra_seller/controllers/auth_controller/login_controller.dart';
import 'package:santra_seller/controllers/home_controller/home_controller.dart';

// lib imports
import '../../../controllers/cart_controller/cart_controller.dart';
import '../../../utils/routes/app_routes.dart';
import '../../../utils/uidata.dart';
import '../../../utils/uidata/textStyles.dart';
import '../buttons/icon_button.dart';
import '../custom_float.dart';
import '../dialogs/custom_dialogs.dart';
import '../drawer/clip_drawer.dart';
// LoginController loginController = Get.put(LoginController());
// HomeController homeController = Get.put(HomeController());
// CartController cartController = Get.put(CartController());

class CommonScaffold extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();
  final resizeToAvoid;
  final appTitle;
  final automaticallyImplyLeading;
  final brightness;
  final leading;
  final tabar;
  final appbarcolor;
  final bool appbarImage;
  final bool appbarSvg;
  final extendBodyBehindAppBar;
  final TextStyle? appbarstyle;
  final Color? backarrow;
  final Widget? bodyData;
  final showFAB;
  final showDrawer;
  final showClipdrawer;
  final showAppBar;
  final String? backGroundImage;
  final Color? backgroundcolor;
  final actionFirstIcon;
  final actionSecondIcon;
  final scaffoldKey;
  final showBottomNav;
  final floatingIcon;
  final centerDocked;
  final elevation;
  final enableHeader;
  final String headerTitle;
  final String headerSubTitle;
  final headerName;
  final topButton;
  final qrCallback;
  final String headerImage;
  final actionFirstIconCallBack;
  final actionSecondIconCallBack;
  final appBarSearch;
  final appBarSearchShow;
  final appBarAction;
  bool? showActions;
  final bool isBackArrowShow;

  CommonScaffold(
      {this.resizeToAvoid,
      this.backgroundcolor,
      this.appTitle,
      this.leading,
      this.automaticallyImplyLeading = true,
      this.brightness,
      this.appbarstyle,
      this.appbarImage = false,
      this.appbarSvg = false,
      this.tabar = false,
      this.appbarcolor,
      this.extendBodyBehindAppBar = false,
      this.backarrow,
      this.bodyData,
      this.showFAB = false,
      this.showDrawer = false,
      this.showClipdrawer = false,
      this.showAppBar = false,
      this.backGroundImage,
      this.actionFirstIcon = false,
      this.actionSecondIcon = false,
      this.scaffoldKey,
      this.showBottomNav = false,
      this.centerDocked = false,
      this.floatingIcon,
      this.elevation = 4.0,
      this.enableHeader = false,
      this.headerName = false,
      this.headerTitle = '',
      this.headerSubTitle = '',
      this.topButton = 'menu',
      this.qrCallback,
      this.headerImage = '',
      this.actionFirstIconCallBack,
      this.actionSecondIconCallBack,
      this.appBarSearch,
      this.appBarSearchShow = false,
      this.isBackArrowShow = true,
      this.appBarAction,
      this.showActions = true});

  Widget myBottomBar() => BottomAppBar(
        shape: const CircularNotchedRectangle(),
        // color: UIDataColors.blue,//shape of notch
        notchMargin: 5, //
        // shape:
        // AutomaticNotchedShape(RoundedRectangleBorder(
        //     borderRadius:
        //     BorderRadius.only(
        //       topLeft: Radius.circular(30.0),
        //       topRight: Radius.circular(30.0),
        //       // bottomLeft: Radius.circular(20.0),
        //       // bottomRight: Radius.circular(20.0),
        //     ),
        // )),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: Get.height / 11,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ReusableIconButton(
                icon: UIDATAIcons.homeIcon,
                iconClr: UIDataColors.primaryColor,
                btntxt: Text(
                  "Home",
                  style: Get.currentRoute == Routes.homeRoutes
                      ? UIDataTextStyles.title.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: UIDataColors.primaryColor)
                      : UIDataTextStyles.subTitle.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                ),
                onPressed: () {
                  Get.offAllNamed(Routes.homeRoutes);
                  if (Get.currentRoute != Routes.homeRoutes) {
                    Get.toNamed(Routes.homeRoutes);
                  }
                },
              ),
              const Center(
                child: Text(
                  'Add Order',
                  style: UIDataTextStyles.h2,
                  textAlign: TextAlign.center,
                ),
              ).marginOnly(top: 20),
              ReusableIconButton(
                iconClr: UIDataColors.primaryColor,
                icon: UIDATAIcons.more2,
                btntxt: Text(
                  "More",
                  style: Get.currentRoute == Routes.moreScreen
                      ? UIDataTextStyles.title.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: UIDataColors.primaryColor)
                      : UIDataTextStyles.subTitle.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                ),
                onPressed: () {
                  if (Get.currentRoute != Routes.moreScreen) {
                    Get.offAllNamed(Routes.moreScreen);
                  }
                },
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.find<LoginController>();
    final HomeController homeController = Get.find<HomeController>();

    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoid,
      key: scaffoldKey != null ? scaffoldKey : null,
      backgroundColor: backgroundcolor,
      appBar: showAppBar
          ? AppBar(
              iconTheme: IconThemeData(
                color: backarrow ?? const Color(0xffF9F9F9),
              ),
              elevation: elevation,
              //automaticallyImplyLeading: automaticallyImplyLeading,
              systemOverlayStyle: brightness,

              leading: isBackArrowShow
                  ? Container(
                      width: 200,
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            children: [
                              SvgPicture.asset(UIDATAIcons.back),
                              SpacingWidth.widthlistspacing5,
                              const Text(
                                "Back",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              //leading,
              backgroundColor: appbarcolor,
              title: SvgPicture.asset(
                UIDataImage.sellerLogoIconSVG,
                height: 35,
                width: 35,
                // fit: BoxFit.fitWidth,
              ),
              actions: showActions == true
                  ? [
                      CartIconWithBadge(
                        onTap: () {
                          Get.toNamed(Routes.cartroute);
                        },
                        showBadge: true,
                      ),
                      SpacingWidth.widthlistspacing15,
                      NotificationIconWithBadge(),
                      const SizedBox(
                        width: 25,
                      )
                    ]
                  : null,

              centerTitle: true,
            )
          : null,
      drawer: showDrawer ? ClipDrawer() : null,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      body: OrientationBuilder(builder: (context, orientation) {
        return Container(
          decoration: backGroundImage == null
              ? BoxDecoration(
                  color: backgroundcolor != null
                      ? backgroundcolor
                      : const Color(0xffffffff),

                  // gradient: new LinearGradient(
                  //   colors: [
                  //     const Color(0xFFd7e1ec),
                  //     const Color(0xFFffffff),
                  //   ],
                  //   begin: Alignment(1.0, 1.0),
                  // ),
                )
              : BoxDecoration(
                  color: backgroundcolor != null
                      ? backgroundcolor
                      : const Color(0xffffffff),
                  image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.1), BlendMode.dstATop),
                      image: backGroundImage != null
                          ? AssetImage(backGroundImage!)
                          : const AssetImage(UIDataImage.splash),
                      fit: BoxFit.cover),
                ),
          width: (MediaQuery.of(context).size.width.ceil()).toDouble(),
          height: (MediaQuery.of(context).size.height.ceil()).toDouble(),
          child: bodyData,
        );
      }),
      floatingActionButton: showFAB
          ? CustomFloat(
              builder: centerDocked
                  ? const Text(
                      "5",
                      style: TextStyle(color: Colors.red, fontSize: 10.0),
                    )
                  : null,
              icon: floatingIcon,
              // ignore: unrelated_type_equality_checks
              qrCallback: homeController.sellerStatusNew != "done"
                  ? () {
                      customOntapDialog(
                          'Alert', 'Your status is not approved.', 'ok', () {
                        print(homeController.sellerStatusNew);
                        Get.back();
                      });
                    }
                  : qrCallback,
            )
          : null,
      floatingActionButtonLocation: centerDocked
          ? FloatingActionButtonLocation.centerDocked
          : FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: showBottomNav ? myBottomBar() : null,
    );
  }
}

class CartIconWithBadge extends StatelessWidget {
  String? icon;

  bool? showBadge;
  var onTap;
  CartIconWithBadge({Key? key, this.icon, this.showBadge, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    return GestureDetector(
      onTap: onTap!,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            UIDATAIcons.cartHallowIcon,
            height: 30,
            color: Colors.black,
          ),
          if (cartController.itemCount != 0)
            Positioned(
                right: -7,
                bottom: 25,
                child: Container(
                  height: 20,
                  // width: 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: const Color(0xffC32C4C),
                      borderRadius: BorderRadius.circular(50)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 2),
                    child: Text(
                      cartController.itemCount.toString(),
                      style: UIDataTextStyles.caption,
                    ),
                  ),
                ))
        ],
      ),
    );
  }
}

class NotificationIconWithBadge extends StatelessWidget {
  String? icon;
  String? value;
  bool? showBadge;
  NotificationIconWithBadge({Key? key, this.icon, this.value, this.showBadge})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        SvgPicture.asset(
          UIDATAIcons.bell,
          height: 30,
          color: Colors.black,
        ),
        if (homeController.homeData!.totalNotifications != "0")
          Positioned(
              right: -7,
              bottom: 25,
              child: Container(
                height: 20,
                // width: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: const Color(0xffC32C4C),
                    borderRadius: BorderRadius.circular(50)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2),
                  child: Text(
                    homeController.homeData == null
                        ? '0'
                        : homeController.homeData!.totalNotifications
                            .toString(),
                    style: UIDataTextStyles.caption,
                  ),
                ),
              ))
      ],
    );
  }
}
