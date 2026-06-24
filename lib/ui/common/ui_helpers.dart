import 'package:flutter/widgets.dart';

// Vertical spacers
const Widget verticalSpaceTiny = SizedBox(height: 4);
const Widget verticalSpaceSmall = SizedBox(height: 8);
const Widget verticalSpaceMedium = SizedBox(height: 12);
const Widget verticalSpaceRegular = SizedBox(height: 16);
const Widget verticalSpaceLarge = SizedBox(height: 22);
const Widget verticalSpaceXLarge = SizedBox(height: 28);

// Horizontal spacers
const Widget horizontalSpaceTiny = SizedBox(width: 4);
const Widget horizontalSpaceSmall = SizedBox(width: 8);
const Widget horizontalSpaceMedium = SizedBox(width: 12);
const Widget horizontalSpaceRegular = SizedBox(width: 16);

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;
double screenWidthFraction(BuildContext context, {double fraction = 1}) =>
    screenWidth(context) * fraction;
double screenHeightFraction(BuildContext context, {double fraction = 1}) =>
    screenHeight(context) * fraction;
