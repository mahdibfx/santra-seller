import 'package:flutter/material.dart';

class CommonDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              "Murtaxa Khalil",
            ),
            accountEmail: Text(
              "murxie@sofodynamix.com",
            ),
            // currentAccountPicture: new CircleAvatar(
            //   backgroundImage: new AssetImage(UIData.pkImage),
            // ),
          ),
          Divider(),
          new ListTile(
            title: Text(
              "Logout",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
            ),
            leading: Icon(
              Icons.logout,
              color: Colors.brown,
            ),
            onTap: () {},
          ),
          Divider(),
          // MyAboutTile(),
        ],
      ),
    );
  }
}
