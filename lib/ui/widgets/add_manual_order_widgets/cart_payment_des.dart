 
 import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santra_seller/ui/widgets/add_manual_order_widgets/price_on_selection.dart';
import '../../../controllers/cart_controller/cart_controller.dart';
import '../../../models/seller_all_products_model.dart';
import '../../../utils/routes/app_routes.dart';
import '../../../utils/uidata.dart';
import '../../../utils/uidata/textStyles.dart';
import '../buttons/material_buttons/primaryButtonWithIcon.dart';

class CartPayemntDescriptionCard extends StatelessWidget {

  CartPayemntDescriptionCard(
      {Key? key, })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
 
 
 
 
 return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                              
                          decoration: BoxDecoration(
                            color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 0.1,
                                  blurRadius: 4,
                                  offset: Offset(0, 0), // changes position of shadow
                              ),
                          ],
                      ),
                        
                        padding: const EdgeInsets.all(8.0),
                        height: 300,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Order Details",  style: UIDataTextStyles.textMedium).paddingAll(10),
                            Container(
                              padding: EdgeInsets.only(top:0.0, left: 10, right: 10),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(top:5.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text("Subtotal"),
                                        Spacer(),
                                        Text("120 AED"),
                                      ],
                                    ),
                                  ),
                                  Divider(height: 1,color: Colors.green.withOpacity(0.2),).paddingOnly(top: 5),
                                  Container(
                                     padding: EdgeInsets.only(top:10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text("Delivery Charge"),
                                        Spacer(),
                                        Text("120 AED"),
                                      ],
                                    ),
                                  ),
                                  Divider(height: 1,color: Colors.green.withOpacity(0.2),).paddingOnly(top: 5),
                                  Container(
                                     padding: EdgeInsets.only(top:10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text("Total", style: UIDataTextStyles.textMediumColoredBlue),
                                        Spacer(),
                                        Text("150 AED", style: UIDataTextStyles.textMediumColoredBlue),
                                      ],
                                    ),
                                  ),

                                  Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: PrimaryButtonWithIcon(
                                                              onPressed: () {
                                                               
                                                               
                                                              },
                                                              btntxt: "Delivary Time",
                                                              
                                                            ),
                                      ),
                                      Container(width: 20),
                                      Expanded(
                                        child: PrimaryButtonWithIcon(
                                                              onPressed: () {
                                                               
                                                            
                                                              },
                                                              btntxt: "Add Order",
                                                              buttontxtColor: UIDataColors.primaryColor,
                                                              backEndColor: Colors.white,
                                                             
                                                            ),
                                      )
                                    ],

                                  ).paddingOnly(top: 20),

                                  PrimaryButtonWithIcon(
                                                            onPressed: () {
                                                             
                                                           
                                                            },
                                                            btntxt: "Add Customer Details",
                                                           
                                                          ).paddingOnly(top: 20, ),

                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );}}