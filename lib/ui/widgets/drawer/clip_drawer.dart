
import '../../../utils/uidata/textStyles.dart';
import '/utils/uidata.dart';
import 'package:flutter/material.dart';

class ClipDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final homecont = Get.find<HomeController>();
    return ClipPath(
      clipper: OvalRightBorderClipper(),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Drawer(
        child: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 40),
          decoration: BoxDecoration(
            color: UIDataColors.white,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.power_settings_new,
                        color: UIDataColors.grey800,
                      ),
                      onPressed: () async{
                        // await homecont.signOut();
                      },
                    ),
                  ),
                  Container(
                    height: 90,
                    width: 90,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 2, color: Colors.orange),
                      // image: const DecorationImage(
                      //     image: CachedNetworkImageProvider(
                      //         'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTD8u1Nmrk78DSX0v2i_wTgS6tW5yvHSD7o6g&usqp=CAU')),
                    ),

                  ),
                  SizedBox(height: 5.0),
                  Text(
                    "Hello",
                    style: UIDataTextStyles.drawertext,
                  ),
                  Text(
                    "Berkay Mohamed",
                    style: UIDataTextStyles.drawertext,
                  ),
                  SpacingHeight.heightlistspacingdrawer,
                  itemList(
                      Icon(Icons.perm_identity, color: UIDataColors.grey800),
                      "My Account"),
                  Divider(),
                  SpacingHeight.heightlistspacing15,
                  itemList(
                      Icon(Icons.notifications_outlined,
                          color: UIDataColors.grey800),
                      "Notification"),
                  Divider(),
                  SpacingHeight.heightlistspacing15,
                  itemList(
                      Icon(Icons.settings_outlined,
                          color: UIDataColors.grey800),
                      "Settings"),
                  Divider(),
                  SpacingHeight.heightlistspacing15,
                  itemList(
                      Icon(Icons.stacked_line_chart,
                          color: UIDataColors.grey800),
                      "Statistics"),
                  Divider(),
                  SpacingHeight.heightlistspacing15,
                  itemList(Icon(Icons.star_border, color: UIDataColors.grey800),
                      "Subscriptions"),
                  Divider(),
                  SpacingHeight.heightlistspacing15,
                  itemList(
                      Icon(Icons.bookmark_border, color: UIDataColors.grey800),
                      "Saved"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget itemList(Widget icon, String title) {
    return Row(
      children: [
        icon,
        SpacingWidth.widthlistspacing,
        Text(title, style: UIDataTextStyles.drawertext),
      ],
    );
  }
}

class OvalRightBorderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width - 50, 0);
    path.quadraticBezierTo(
        size.width, size.height / 4, size.width, size.height / 2);
    path.quadraticBezierTo(size.width, size.height - (size.height / 4),
        size.width - 40, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
