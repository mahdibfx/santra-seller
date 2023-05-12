// flutter imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// package imports
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/provider/splash_provider.dart';
import 'package:santra_seller/provider/home_provider.dart';
import 'package:santra_seller/provider/auth_providers/login_provider.dart';
import 'package:santra_seller/ui/screens/cart/cart_screen.dart';
import 'package:santra_seller/ui/screens/more_setting/more_screen.dart';
// lib imports
import '../../../utils/app_translation/app_translation.dart';
import '../../../utils/uidata.dart';
import '../../../utils/uidata/textStyles.dart';
import '../../screens/home_page/home_screen.dart';
import '../buttons/icon_button.dart';
import '../custom_float.dart';
import '../dialogs/custom_dialogs.dart';
import '../drawer/clip_drawer.dart';
import 'cart_icon_with_badge.dart';
import 'notification_icon_with_badge.dart';

var tr = Get.put(AppTranslations());
class CommonScaffold extends StatelessWidget {
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

  Widget myBottomBar(context) =>
      Provider.of<SplashProvider>(context, listen: false).sellerCode == null &&
              Provider.of<LoginProvider>(context, listen: false).sellerCode ==
                  null
          ? const SizedBox()
          : BottomAppBar(
              // elevation: 0,

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
                    
                      Consumer<SplashProvider>(
                          builder: (context, splashPro, child) {
                        return ReusableIconButton(
                          icon: UIDATAIcons.homeIcon,
                          iconClr: UIDataColors.primaryColor,
                          btntxt: Text(
                            tr.translateData("home_menu_button"),
                            style:
                                // Get.currentRoute == Routes.homeRoutes
                                //     ? UIDataTextStyles.title.copyWith(
                                //         fontSize: 14,
                                //         fontWeight: FontWeight.w800,
                                //         color: UIDataColors.primaryColor)
                                //     :
                                UIDataTextStyles.subTitle.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          onPressed: splashPro.isHome
                              ? null
                              : () {
                                  splashPro.onHomeScreen();
                                  // if (Get.currentRoute != Routes.homeRoutes) {
                                  Get.offAll(() => const HomeScreen());
                                  // }
                                },
                        );
                      
                    }),
                    Center(
                      child:Text(
                          showFAB
                              ? tr.translateData('home_addorder_button')
                              : '',
                          style: UIDataTextStyles.h2,
                          textAlign: TextAlign.center,
                       ),
                    ).marginOnly(top: 20),
                    GetBuilder<AppTranslations>(
      builder: (tr) {
                      return Consumer<SplashProvider>(
                          builder: (context, splashPro, child) {
                        return ReusableIconButton(
                          iconClr: UIDataColors.primaryColor,
                          icon: UIDATAIcons.more2,
                          btntxt: Text(
                            tr.translateData("home_more_button"),
                            style:
                                //  Get.currentRoute == Routes.moreScreen
                                //     ?
                                // UIDataTextStyles.title.copyWith(
                                //     fontSize: 14,
                                //     fontWeight: FontWeight.w800,
                                //     color: UIDataColors.primaryColor)
                                //:
                                UIDataTextStyles.subTitle.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          onPressed: splashPro.isMore
                              ? null
                              : () {
                                  splashPro.onMoreScreen();

                                  Get.offAll(() => MoreSettingScreen());
                                  // if (Get.currentRoute != Routes.moreScreen) {
                                  //   Get.offAllNamed(Routes.moreScreen);
                                  // }
                                },
                        );
                      });
                    }),
                  ],
                ),
              ),
            );
  final localization = AppTranslations();
  iconSet() {}
  @override
  Widget build(BuildContext context) {
    // final LoginController loginController = Get.find<LoginController>();
    // final HomeController homeController = Get.find<HomeController>();

    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoid,
      key: scaffoldKey ?? null,
      backgroundColor: backgroundcolor,
      appBar: showAppBar
          ? AppBar(
              iconTheme: IconThemeData(
                color: backarrow ?? const Color(0xffF9F9F9),
              ),
              elevation: elevation,
              // automaticallyImplyLeading: automaticallyImplyLeading,
              systemOverlayStyle: brightness,

              leading: isBackArrowShow
                  ? GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Consumer<SplashProvider>(
                            builder: (context, splashPro, child) {
                          return Row(
                            children: [
                              SpacingWidth.widthlistspacing5,
                              splashPro.language == 'en_us'
                                  ? SvgPicture.asset(UIDATAIcons.back)
                                  : SvgPicture.asset(
                                      UIDATAIcons.forwardArrow,
                                      color: UIDataColors.primaryColor,
                                    ),
                              SpacingWidth.widthlistspacing5,
                              const Text(
                                "",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          );
                        }),
                      ),
                    )
                  : const SizedBox(),
              //leading,
              backgroundColor: appbarcolor,
              title: Consumer<SplashProvider>(
                  builder: (context, splashPro, child) {
                return GestureDetector(
                  onTap: () {
                    if (Provider.of<SplashProvider>(context, listen: false)
                                .sellerCode ==
                            null &&
                        Provider.of<LoginProvider>(context, listen: false)
                                .sellerCode ==
                            null) {
                      null;
                    } else {
                      // if (Get.currentRoute == Routes.homeRoutes) {
                      // } else {
                      splashPro.onHomeScreen();
                      Get.offAll(() => const HomeScreen());
                      // }
                    }
                  },
                  child: SvgPicture.asset(
                    UIDataImage.sellerLogoIconSVG,
                    height: 35,
                    width: 35,
                    // fit: BoxFit.fitWidth,
                  ),
                );
              }),
              actions: showActions == true
                  ? Provider.of<SplashProvider>(context, listen: false)
                                  .sellerCode ==
                              null &&
                          Provider.of<LoginProvider>(context, listen: false)
                                  .sellerCode ==
                              null
                      ? []
                      : [
                          Consumer<SplashProvider>(
                              builder: (context, splashPro, child) {
                            return CartIconWithBadge(
                              onTap: () {
                                splashPro.homeAndMoreScreenOff();
                                Get.to(() => CartScreen());
                                //Get.toNamed(Routes.cartroute);
                              },
                              showBadge: true,
                            );
                          }),
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
      endDrawer: showDrawer ? ClipDrawer() : null,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      body: OrientationBuilder(builder: (context, orientation) {
        return Container(
          decoration: backGroundImage == null
              ? BoxDecoration(
                  color: backgroundcolor ?? const Color(0xffffffff),

                  // gradient: new LinearGradient(
                  //   colors: [
                  //     const Color(0xFFd7e1ec),
                  //     const Color(0xFFffffff),
                  //   ],
                  //   begin: Alignment(1.0, 1.0),
                  // ),
                )
              : BoxDecoration(
                  image: DecorationImage(
                      image: backGroundImage != null
                          ? AssetImage(UIDataImage.backgroundImage)
                          : AssetImage(UIDataImage.backgroundImage),
                      fit: BoxFit.cover),
                ),
          width: (MediaQuery.of(context).size.width.ceil()).toDouble(),
          height: (MediaQuery.of(context).size.height.ceil()).toDouble(),
          child: bodyData,
        );
      }),
      floatingActionButton: Provider.of<SplashProvider>(context, listen: false)
                      .sellerCode ==
                  null &&
              Provider.of<LoginProvider>(context, listen: false).sellerCode ==
                  null
          ? const SizedBox()
          : showFAB
              ? Visibility(
                  visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
                  child:
                      GetBuilder<AppTranslations>(
      builder: (tr) {
                    return Consumer<HomeProvider>(
                        builder: (context, homeProvider, child) {
                      return CustomFloat(
                        builder: centerDocked
                            ? const Text(
                                "5",
                                style: TextStyle(
                                    color: Colors.red, fontSize: 10.0),
                              )
                            : null,
                        icon: floatingIcon,
                        // ignore: unrelated_type_equality_checks
                        qrCallback: homeProvider.sellerStatusNew != "done"
                            ? () {
                                customOntapDialog(
                                    tr.translateData('alert'),
                                    tr.translateData('status_approved'),
                                    tr.translateData('okay'), () {
                                  print(homeProvider.sellerStatusNew);
                                  Get.back();
                                });
                              }
                            : qrCallback,
                      );
                    });
                  }),
                )
              : null,
      floatingActionButtonLocation: centerDocked
          ? FloatingActionButtonLocation.centerDocked
          : FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: showBottomNav ? myBottomBar(context) : null,
    );
  }
}
