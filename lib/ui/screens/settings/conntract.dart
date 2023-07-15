import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';

import '../../../constants/app_constants.dart';
import '../../../utils/uidata.dart';
import '../../../utils/uidata/textStyles.dart';
import '../../widgets/buttons/material_buttons/raised_gradient_button.dart';


class BlurryDialog extends StatelessWidget {


  VoidCallback continueCallBack;

  BlurryDialog(this.continueCallBack);
  TextStyle textStyle = TextStyle (color: Colors.black);

var date = DateTime.now();

  @override
  Widget build(BuildContext context) {


    return Material(
       color: Colors.transparent, // <-- Add this, if needed
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child:  Center(
            child: Container(
              child: Container(
                
                width: MediaQuery.of(context).size.width - 50,
                height: MediaQuery.of(context).size.height -  (MediaQuery.of(context).size.height * 0.3),
                // padding: EdgeInsets.all(20),
               
                  decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.circular(20.0),
                    image: DecorationImage(
              scale: 10,
              image: AssetImage(
                UIDataImage.backgroundImage,),
              fit: BoxFit.fill,
                    ),
                    // shape: BoxShape.circle,
                  ),
                
                child: Stack(
                  alignment: Alignment.center,
                       clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -105,
                   
                
                      child: Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: Container(
                              width: 200,
                              height: 200,
                         
                              child: Image.asset(
                                UIDataImage.contractLogo,
                                height: 100,
                                width: 100,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:65.0, left: 20, right: 20, bottom: 10),
                      child: Column(
                      children: [
                        
                        Text(
                                                      "Important notice",
                                                      style: UIDataTextStyles.h1Heavy
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              color: UIDataColors
                                                                  .primaryColor
                                                                  ),
                                                    ),
    
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(
                                                        "Please be aware that we have made updates to the seller's contract. Take a moment to review the changes to stay informed and compliant.",
                                                        style: UIDataTextStyles.textMedium
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight.normal,
                                                                color: const Color.fromARGB(255, 0, 0, 0)
                                                                    ),
                                                      ),
                                                    ),
    
                                                    Expanded(child: Padding(
                                                      padding: const EdgeInsets.only(top:8.0, bottom: 8.0),
                                                      child: Container(
                                                         decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.circular(20),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors.black.withOpacity(0.2),
                                                                  spreadRadius: 0.2,
                                                                  blurRadius: 8,
                                                                  offset: const Offset(0, 0), // changes position of shadow
                                                                ),
                                                              ],
                                                            ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(15.0),
                                                          child: RawScrollbar(
                                                                  isAlwaysShown: true, //always show scrollbar
          thickness: 5, //width of scrollbar
          radius: Radius.circular(20), //corner radius of scrollbar
                                                            child: SingleChildScrollView(
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  'This Agreement is made on “${date.day}/${date.month}/${date.year}”',
                                                                  style: UIDataTextStyles.textMedium
                                                                  .copyWith(
                                                                      fontWeight:
                                                                          FontWeight.w100,
                                                                      color: const Color.fromARGB(255, 0, 0, 0)
                                                                          ),
                                                                ),
                                                                RichText(
                                                                  text: TextSpan(
                                                                    // Note: Styles for TextSpans must be explicitly defined.
                                                                    // Child text spans will inherit styles from parent
                                                                    
                                                                    style: const TextStyle(
                                                                    
                                                                      fontSize: 14.0,
                                                                      color: Colors.black,
                                                                    ),
                                                                    children: <TextSpan>[
                                                                      TextSpan(text: 'First party:', style: UIDataTextStyles.textMedium
                                                                                                                              .copyWith(
                                                                                                                                  fontWeight:
                                                                                                                                      FontWeight.bold,
                                                                                                                                  color: const Color.fromARGB(255, 0, 0, 0)
                                                                                                                                      )),
                                                                      TextSpan(text: ' SANTRA – FZCO'),
                                                                    ],
                                                                  ),
                                                                ),
                                                                RichText(
                                                                  text: TextSpan(
                                                                    // Note: Styles for TextSpans must be explicitly defined.
                                                                    // Child text spans will inherit styles from parent
                                                                    
                                                                    style: const TextStyle(
                                                                    
                                                                      fontSize: 14.0,
                                                                      color: Colors.black,
                                                                    ),
                                                                    children: <TextSpan>[
                                                                      TextSpan(text: 'Second party:', style: UIDataTextStyles.textMedium
                                                                                                                              .copyWith(
                                                                                                                                  fontWeight:
                                                                                                                                      FontWeight.bold,
                                                                                                                                  color: const Color.fromARGB(255, 0, 0, 0)
                                                                                                                                      )),
                                                                      TextSpan(text: ' ${AppConstants.homeModel.data.first.titleMessage}'),
                                                                    ],
                                                                  ),
                                                                ),
                                                          
                                                                 Padding(
                                                                   padding: const EdgeInsets.only(top:20.0, bottom: 10),
                                                                   child: Text(
                                                                    'The parties hereby acknowledge and agree to the following terms and conditions:',
                                                                    style: UIDataTextStyles.textMedium
                                                                    .copyWith(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: const Color.fromARGB(255, 0, 0, 0)
                                                                            ),
                                                                                                                             ),
                                                                 ),
    
                                                                  Padding(
                                                                   padding: const EdgeInsets.only(top:0.0, bottom: 0),
                                                                   child: Text(
                                                                    "⚈ The second party agrees to the terms and conditions mentioned in the application designated for Business owners. The subscription to the application is free of charge and the business owner possesses all rights through the application without accounting for the tax value.",
                                                                    style: UIDataTextStyles.textMedium
                                                                    .copyWith(
                                                                        fontWeight:
                                                                            FontWeight.w100,
                                                                        color: const Color.fromARGB(255, 0, 0, 0)
                                                                            ),
                                                                                                                             ),
                                                                 ),
    
                                                                                     Padding(
                                                                   padding: const EdgeInsets.only(top:10.0, bottom: 10),
                                                                   child: Text(
                                                                    "⚈ The first party undertakes to deliver the orders belonging to the second party, which are received through the application, safely.",
                                                                    style: UIDataTextStyles.textMedium
                                                                    .copyWith(
                                                                        fontWeight:
                                                                            FontWeight.w100,
                                                                        color: const Color.fromARGB(255, 0, 0, 0)
                                                                            ),
                                                                                                                             ),
                                                                 ),
    
                                                                                         Padding(
                                                                   padding: const EdgeInsets.only(top:10.0, bottom: 10),
                                                                   child: Text(
                                                                    "⚈ The first party agrees to deliver the orders and if the customer does not receive their order due to reasons caused by the second party or the customer, the first party is not responsible for any losses incurred in returning the order to the second party.",
                                                                    style: UIDataTextStyles.textMedium
                                                                    .copyWith(
                                                                        fontWeight:
                                                                            FontWeight.w100,
                                                                        color: const Color.fromARGB(255, 0, 0, 0)
                                                                            ),
                                                                                                                             ),
                                                                 ),
    
                                                                                       Padding(
                                                                   padding: const EdgeInsets.only(top:10.0, bottom: 10),
                                                                   child: Text(
                                                                    "⚈ The first party undertakes to pay the debts or amounts received once a month by means of a bank transfer using the banking information provided to us by the second party unless the parties come to a different agreement.",
                                                                    style: UIDataTextStyles.textMedium
                                                                    .copyWith(
                                                                        fontWeight:
                                                                            FontWeight.w100,
                                                                        color: const Color.fromARGB(255, 0, 0, 0)
                                                                            ),
                                                                                                                             ),
                                                                 ),
    
                                                                                            Padding(
                                                                   padding: const EdgeInsets.only(top:10.0, bottom: 10),
                                                                   child: Text(
                                                                    "⚈ The second party agrees to comply with all food safety.",
                                                                    style: UIDataTextStyles.textMedium
                                                                    .copyWith(
                                                                        fontWeight:
                                                                            FontWeight.w100,
                                                                        color: const Color.fromARGB(255, 0, 0, 0)
                                                                            ),
                                                                                                                             ),
                                                                 ),
    
                                                                                               Padding(
                                                                   padding: const EdgeInsets.only(top:10.0, bottom: 10),
                                                                   child: Text(
                                                                    "⚈ The second party agrees to abide by the standards and conditions for food product photography, such as professional photography or adding the application's specific colors as a background for the pictures."
    ,
                                                                    style: UIDataTextStyles.textMedium
                                                                    .copyWith(
                                                                        fontWeight:
                                                                            FontWeight.w100,
                                                                        color: const Color.fromARGB(255, 0, 0, 0)
                                                                            ),
                                                                                                                             ),
                                                                 ),
    
    
                                                                                                   Padding(
                                                                   padding: const EdgeInsets.only(top:10.0, bottom: 10),
                                                                   child: Text(
                                                                    "⚈ The contract is valid for 1 year from the start date and will be renewed Automatically and the second party have the freedom to break and cancel the subscription anytime."
    ,
                                                                    style: UIDataTextStyles.textMedium
                                                                    .copyWith(
                                                                        fontWeight:
                                                                            FontWeight.w100,
                                                                        color: const Color.fromARGB(255, 0, 0, 0)
                                                                            ),
                                                                                                                             ),
                                                                 ),
    
                                                                                                                     Padding(
                                                                   padding: const EdgeInsets.only(top:10.0, bottom: 10),
                                                                   child: Text(
                                                                     "⚈ The second party acknowledges, by signing this contract, their agreement to the terms and conditions of the Sellers/Traders Application."
    ,
                                                                    style: UIDataTextStyles.textMedium
                                                                    .copyWith(
                                                                        fontWeight:
                                                                            FontWeight.w100,
                                                                        color: const Color.fromARGB(255, 0, 0, 0)
                                                                            ),
                                                                                                                             ),
                                                                 ),
    
                                                                                                                       Padding(
                                                                   padding: const EdgeInsets.only(top:10.0, bottom: 10),
                                                                   child: Text(
                                                                     "⚈ The first party acknowledges the calculation of a commission from the second party on orders based on the percentages specified in the table below."
    ,
                                                                    style: UIDataTextStyles.textMedium
                                                                    .copyWith(
                                                                        fontWeight:
                                                                            FontWeight.w100,
                                                                        color: const Color.fromARGB(255, 0, 0, 0)
                                                                            ),
                                                                                                                             ),
                                                                 ),
    
    
                                                                                                                      Padding(
                                                                   padding: const EdgeInsets.only(top:10.0, bottom: 10),
                                                                   child: Text(
                                                                     "⚈ The first party acknowledges that no registration fees will be charged from the second party."
    ,
                                                                    style: UIDataTextStyles.textMedium
                                                                    .copyWith(
                                                                        fontWeight:
                                                                            FontWeight.w100,
                                                                        color: const Color.fromARGB(255, 0, 0, 0)
                                                                            ),
                                                                                                                             ),
                                                                 ),
    
                                                                                                                                                             Padding(
                                                                   padding: const EdgeInsets.only(top:10.0, bottom: 10),
                                                                   child: Text(
                                                                     "⚈ The first party acknowledges that the registration fees will be free"
    ,
                                                                    style: UIDataTextStyles.textMedium
                                                                    .copyWith(
                                                                        fontWeight:
                                                                            FontWeight.w100,
                                                                        color: const Color.fromARGB(255, 0, 0, 0)
                                                                            ),
                                                                                                                             ),
                                                                 ),

                                                                    //  Markdown(data: _markDownData),
                                                             
                                                              ],
                                                            ),
                                                                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    )),
    
    
                               
                        
                               RaisedGradientButton(
                                    gradient: const LinearGradient(
                                      colors: <Color>[
                                        UIDataColors.primaryColor,
                                        UIDataColors.primaryColor,
                                      ],
                                    ),
                                    btntxt: "OK",
                                    
                                    buttontxtColor: UIDataColors.whiteColor,
                                    onPressed: () {
                                     continueCallBack();
                                    },
                                  ).marginOnly(bottom: 10, top: 10),
                      ],
                                    ),
                    )],
                ),
              ),
            ),
          )),
    );
  }
}