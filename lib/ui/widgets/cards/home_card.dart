import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../utils/uidata.dart';
import '../../../utils/uidata/textStyles.dart';

class HomeCardWidget extends StatelessWidget {
  final String heading;
  final String count;
  final String imageAsset;
  final String? santraNewCount;
  final bool isSantraCard;
  final void Function() onTap;
  const HomeCardWidget(
      {super.key,
      required this.heading,
      required this.count,
      required this.onTap,
      required this.imageAsset,
       this.santraNewCount,
       this.isSantraCard = false,
      });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
             clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
          children: [
           
            Container(
              height: size.height * 0.25,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  color: Colors.white,
                  border: Border.all(color:  isSantraCard ==  true && santraNewCount.toString() != '0' ? Color(0xffC32C4C) : Color(0xff0098B1))),
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: size.height * 0.15,
                      child: SvgPicture.asset(
                        imageAsset,
                        fit: BoxFit.fill,
                      ),
                    ).marginOnly(left: 0, right: 0, top: 0),
                    // const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          heading,
                          style: UIDataTextStyles.h2.copyWith(
                              color: UIDataColors.primaryColor, fontSize: 13),
                        ),
                        // const Spacer(),
                        Text(
                          count,
                          style: UIDataTextStyles.counth1.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ).marginOnly(left: 10, right: 10, bottom: 0),
                  ],
                ),
              ),
            ),
            isSantraCard ==  true && santraNewCount.toString() != '0' ?
              Positioned(
                right: 15,
                    top: -10,
               child: Container(
                                      height: 24,
                                      width: 24,
                                      decoration: BoxDecoration(
                                        color: Color(0xffC32C4C),
                                        borderRadius: BorderRadius.all(Radius.circular(100))
                                      ),
                                      child: Center(child: Text(santraNewCount.toString(), style: UIDataTextStyles.countTitle.copyWith(fontSize: 12,color: Colors.white),),),
                                    ),
             ) :SizedBox(),
          ],
        ),
      ),
    );
  }
}
