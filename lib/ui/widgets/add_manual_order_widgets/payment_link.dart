import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:santra_seller/controllers/more_screen_controller.dart/my_customer/my_customer_controller.dart';

import '../../../utils/routes/app_routes.dart';
import '../../../utils/uidata.dart';
import '../../../utils/uidata/textStyles.dart';
import '../../screens/more_setting/my_customer/my_customer_screen.dart';
import '../../screens/more_setting/my_customer/view_customer_details.dart';
import '../buttons/material_buttons/primaryButtonWithIcon.dart';
import '../textfields/common_textfield.dart';

class PaymentLinkBottomSheet extends StatelessWidget {
  final cartdController = Get.find<MyCustomerController>();
  PaymentLinkBottomSheet({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
            height: 230,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
      
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                     Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Create a payment link:", style: UIDataTextStyles.textMedium),
              
                    SizedBox(
                          width:32,
                          height: 32,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                      
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(5),
                            primary: UIDataColors.lightGrayColor
                          ),
                        onPressed: (() => Get.back()),
                          child: SvgPicture.asset(
                             width: 20,
                              height: 20,
                                 color: UIDataColors.blackColor,
                                    UIDATAIcons.close,
                                    
                              ),
                      ).paddingOnly(top: 5),
                    ),
                  ],
                ).paddingOnly(top: 10, left: 10, right: 10),
           Divider(
                    height: 1,
                    color: Colors.green.withOpacity(0.2),
                  ).paddingOnly(top: 5),







                             Divider(
                    height: 1,
                    color: Colors.green.withOpacity(0.2),
                  ).paddingOnly(top: 5),


                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Send this link to your customer so they can checkout. You will be notified by santra when it pays."),

                      CommonTextField(
                        controller: cartdController.link,
                        labelText: "Link",
                        isTextHidden: false,
                        fillcolor: UIDataColors.whiteColor,
                        keyboardType: TextInputType.text,
                        initVal: cartdController.link.text,
                      ),

                    ],
                  ),


                  Row(
                    children: [
 Padding(
                   padding: const EdgeInsets.only(left: 10, top: 20),
                   child: PrimaryButtonWithIcon(
                        btntxt: "Copy Link",
                        iconImage: UIDATAIcons.cardOpen,
                        onPressed: () {
                          Get.back();
                            
                   
                          
                        
                        },
                      ),
                 ),

                 Padding(
                   padding: const EdgeInsets.only(left: 10),
                   child: PrimaryButtonWithIcon(
                        btntxt: "Share",
                        backEndColor: UIDataColors.whiteColor,
                        buttontxtColor: UIDataColors.primaryColor,
                        iconImageColor: UIDataColors.primaryColor,
                        iconImage: UIDATAIcons.userIcon,
                        onPressed: () {
                              Get.back();
                                  
                        },
                      ),
                 )


                    ],
                  ).paddingAll(20)

                 

                

                 
              ],
            ),
          );
  }
}
