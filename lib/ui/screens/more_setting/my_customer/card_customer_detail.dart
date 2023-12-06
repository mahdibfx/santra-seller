import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:santra_seller/utils/uidata.dart';
import '../../../../models/customers/view_all_customers.dart';
import '../../../../utils/uidata/textStyles.dart';

class CardCustomerDetail extends StatelessWidget {
  final Customer? customerDetail;

  const CardCustomerDetail({
    Key? key,
    this.customerDetail,
  }) : super(key: key);

  Widget iconText(double width, String svg, String tilte) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                svg,
                height: 12,
                color: UIDataColors.primaryColor,
              ),
              SizedBox(
                width: width,
              ),
              Expanded(child: Text(tilte)),
            ],
          ),
        ),
        Divider(
          height: 1,
          color: Colors.green.withOpacity(0.2),
        ).paddingOnly(top: 8)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0.1,
              blurRadius: 4,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        padding: const EdgeInsets.all(8.0),
        // height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(customerDetail?.customerName ?? "",
                    style: UIDataTextStyles.dateStyle)
                .paddingAll(10),
            Container(
              padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
              child: Column(
                children: [
                  iconText(size.width * 0.05, UIDATAIcons.callIcon,
                      customerDetail?.customerMobile ?? ""),
                  iconText(size.width * 0.05, UIDATAIcons.locationPin,
                      customerDetail?.customerCity ?? ""),
                  iconText(size.width * 0.05, UIDATAIcons.building,
                      customerDetail?.customerArea ?? ""),
                  // iconText(size.width * 0.05, UIDATAIcons.homeIcon,
                  //     customerDetail?.buildingNumber ?? ""),
                  iconText(size.width * 0.05, UIDATAIcons.homeIcon,
                      customerDetail?.addressLink ?? ""),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
