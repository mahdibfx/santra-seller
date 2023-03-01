import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/uidata.dart';
import '../buttons/icon_button.dart';

class MyCustomerCard extends StatelessWidget {
  final String name;
  final String number;
  final dynamic onTap;

  const MyCustomerCard({super.key, required this.name, required this.number, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 80,
            color: UIDataColors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Name:  '),
                            Text(name),
                          ],
                        ),
                        SpacingHeight.heightlistspacing10,
                        Row(
                          children: [
                            Text('Phone:  '),
                            Text(number),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    ReusableIconButton(
                      icon: Icon(Icons.edit),
                      onPressed: onTap,
                    )
                  ],
                ).marginAll(15)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
