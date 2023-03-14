// flutter imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// package imports
import 'package:get/get.dart';

// lib imports
import '../../../utils/routes/app_routes.dart';
import '../../../utils/uidata.dart';
import '../../../utils/uidata/textStyles.dart';
import '../buttons/icon_button.dart';
import '../custom_float.dart';
import '../drawer/clip_drawer.dart';

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

  CommonScaffold({
    this.resizeToAvoid,
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
    this.appBarAction,
  });

  Widget myBottomBar() => BottomAppBar(
        shape: CircularNotchedRectangle(),
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
        child: Container(
          height: Get.height / 11 - 10,
          // decoration: ShapeDecoration(
          //   shape: RoundedRectangleBorder(
          //     borderRadius:
          //     BorderRadius.only(
          //       topLeft: Radius.circular(20.0),
          //       topRight: Radius.circular(20.0),
          //       bottomLeft: Radius.circular(20.0),
          //       bottomRight: Radius.circular(20.0),
          //     ),
          //   ),
          // ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ReusableIconButton(
                icon: Icon(
                  Icons.home,
                  color: Get.currentRoute == Routes.homeRoutes
                      ? UIDataColors.primaryColor
                      : Colors.grey,
                ),
                btntxt: Text(
                  "Home",
                  style: Get.currentRoute == Routes.homeRoutes
                      ? UIDataTextStyles.title
                      : UIDataTextStyles.subTitle,
                ),
                onPressed: () {
                  Get.offAllNamed(Routes.homeRoutes);
                  if (Get.currentRoute != Routes.homeRoutes) {
                    Get.toNamed(Routes.homeRoutes);
                  }
                },
              ),
              // ReusableIconButton(
              //   icon: Icon(
              //     Icons.cleaning_services,
              //     color: Get.currentRoute == Routes.createrequestroute
              //         ? UIDataColors.fbbtnColor
              //         : Colors.grey,
              //   ),
              //   btntxt: Text(
              //     "Services",
              //     style: Get.currentRoute == Routes.createrequestroute
              //         ? UIDataTextStyles.bottomcolor
              //         : UIDataTextStyles.btntext1,
              //   ),
              //   onPressed: () {
              //     // if (Get.currentRoute != Routes.createrequestroute) {
              //     //   Get.offAllNamed(Routes.createrequestroute);
              //     // }
              //   },
              // ),
              // ReusableHomeIconButton(
              //   icon: Icon(
              //     Icons.home,
              //     color: Get.currentRoute == Routes.homeRoutes
              //         ? UIDataColors.fbbtnColor
              //         : Colors.grey,
              //   ),
              //   btntxt: Text(
              //     "Home",
              //     style: Get.currentRoute == Routes.homeRoutes
              //         ? UIDataTextStyles.bottomcolor
              //         : UIDataTextStyles.btntext1,
              //   ),
              //   onPressed: () {
              //     Get.offAllNamed(Routes.homeRoutes);
              //     // if (Get.currentRoute != Routes.orderRoutes) {
              //     //   Get.toNamed(Routes.orderRoutes);
              //     // }
              //   },
              // ),

              // ReusableIconButton(
              //   icon: Icon(
              //     Icons.history,
              //     color: Get.currentRoute == Routes.historyrotues
              //         ? UIDataColors.fbbtnColor
              //         : Colors.grey,
              //   ),
              //   btntxt: Text(
              //     "History",
              //     style: Get.currentRoute == Routes.historyrotues
              //         ? UIDataTextStyles.bottomcolor
              //         : UIDataTextStyles.btntext1,
              //   ),
              //   onPressed: () {
              //     // if (Get.currentRoute != Routes.historyrotues) {
              //     //   Get.offAllNamed(Routes.historyrotues);
              //     // }
              //   },
              // ),
              ReusableIconButton(
                icon: Icon(
                  Icons.list,
                  color: Get.currentRoute == Routes.moreScreen
                      ? UIDataColors.primaryColor
                      : Colors.grey,
                ),
                btntxt: Text(
                  "More",
                  style: Get.currentRoute == Routes.moreScreen
                      ? UIDataTextStyles.title
                      : UIDataTextStyles.subTitle,
                ),
                onPressed: () {
                  if (Get.currentRoute != Routes.moreScreen) {
                    Get.offAllNamed(Routes.moreScreen);
                  }
                },
              ),
              // ReusableIconButton(
              //   icon: Icon(Icons.request_page_outlined, color:
              //   // Get.currentRoute
              //   //     == Routes.reportsRoutes
              //   //     ? UIDataColors.btnColor
              //   //     :
              //   Colors.grey,
              //   ),
              //   btntxt: Text("Reports" , style:
              //   // Get.currentRoute
              //   //     == Routes.reportsRoutes ? UIDataTextStyles.btntext :
              //   UIDataTextStyles.btntext1,),
              //   onPressed: () {
              //     // if (Get.currentRoute != Routes.reportsRoutes) {
              //     //   // Get.toNamed(Routes.orderRoutes);
              //     // }
              //   },),
              // ReusableIconButton(
              //   icon: Icon(Icons.settings, color:
              //   // Get.currentRoute
              //   //     == Routes.settingsRoutes
              //   //     ? UIDataColors.btnColor
              //   //     :
              //   Colors.grey,
              //   ),
              //   btntxt: Text("Settings" , style:
              //   // Get.currentRoute
              //   //     == Routes.settingsRoutes ? UIDataTextStyles.btntext :
              //   UIDataTextStyles.btntext1,),
              //   onPressed: () {
              //     // if (Get.currentRoute != Routes.settingsRoutes) {
              //     //   // Get.toNamed(Routes.settingsRoutes);
              //     // }
              //   },),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoid,
      key: scaffoldKey != null ? scaffoldKey : null,
      backgroundColor: backgroundcolor,
      appBar: showAppBar
          ? AppBar(
              iconTheme: IconThemeData(
                color: backarrow != null ? backarrow : Color(0xffF9F9F9),
              ),
              elevation: elevation,
              automaticallyImplyLeading: automaticallyImplyLeading,
              systemOverlayStyle: brightness,
              // leading: InkWell(child: Icon(Icons.keyboard_arrow_left),onTap:(){
              //   Get.back(result: true);
              // }),
              leading: leading,
              backgroundColor: appbarcolor,
              title: appbarImage == true
                  ? Image.asset(
                      UIDataImage.splash,
                      width: 100.0,
                      height: 50.0,
                    )
                  : appbarSvg == true
                      ? SvgPicture.asset(
                          UIDataImage.sellerLogoIconSVG,
                          height: 35,
                          width: 35,
                          fit: BoxFit.fitWidth,
                        )
                      : Text(
                          appTitle,
                          style: appbarstyle != null
                              ? appbarstyle
                              : UIDataTextStyles.h2,
                        ),
              actions: appBarAction,
              centerTitle: true,
            )
          : null,
      drawer: showDrawer ? ClipDrawer() : null,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      body: OrientationBuilder(builder: (context, orientation) {
        return Container(
          decoration: BoxDecoration(
            color:
                backgroundcolor != null ? backgroundcolor : Color(0xffffffff),
            // gradient: new LinearGradient(
            //   colors: [
            //     const Color(0xFFd7e1ec),
            //     const Color(0xFFffffff),
            //   ],
            //   begin: Alignment(1.0, 1.0),
            // ),
          ),
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //       colorFilter: new ColorFilter.mode(
          //           Colors.black.withOpacity(0.6), BlendMode.dstATop),
          //       image: backGroundImage != null
          //           ? AssetImage(backGroundImage!)
          //           : AssetImage(UIDataImage.splash),
          //       fit: BoxFit.cover),
          // ),
          width: (MediaQuery.of(context).size.width.ceil()).toDouble(),
          height: (MediaQuery.of(context).size.height.ceil()).toDouble(),
          child: bodyData,
        );
      }),
      floatingActionButton: showFAB
          ? Visibility(
              visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
              child: CustomFloat(
                builder: centerDocked
                    ? const Text(
                        "5",
                        style: TextStyle(color: Colors.white, fontSize: 10.0),
                      )
                    : null,
                icon: floatingIcon,
                qrCallback: qrCallback,
              ),
            )
          : null,
      floatingActionButtonLocation: centerDocked
          ? FloatingActionButtonLocation.centerDocked
          : FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: showBottomNav ? myBottomBar() : null,
    );
  }
}
