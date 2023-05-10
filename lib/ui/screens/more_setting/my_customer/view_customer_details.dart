import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:santra_seller/ui/widgets/scaffold/common_scaffold.dart';
import 'package:santra_seller/utils/app_translation/app_translation.dart';
import 'package:santra_seller/utils/uidata.dart';
import '../../../../models/customers/view_all_customers.dart';
import '../../../../provider/more_settings_provider/my_customer_provider.dart';
import '../../../../utils/uidata/textStyles.dart';
import '../../../widgets/add_manual_order_widgets/payment_link.dart';
import '../../../widgets/buttons/icon_setting_button.dart';
import '../../../widgets/buttons/material_buttons/primaryButtonWithIcon.dart';
import '../../add_manual_order/add_manual_order.dart';
import 'card_customer_detail.dart';

class ViewCustomerDetails extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final Customer? customerDetail;

  ViewCustomerDetails({super.key, this.customerDetail});

  void popupPaymentlink(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            // <-- SEE HERE
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
        ),
        builder: (context) {
          return PaymentLinkBottomSheet();
        });
  }

  Widget bodyData(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<MyCustomerProvider>(builder: (context, _, child) {
      return
          // _.isViewCustomerLoading
          //     ? const SizedBox(
          //         child: Center(
          //         child: CircularProgressIndicator(),
          //       ))
          //     :
          ModalProgressHUD(
        inAsyncCall: _.isSubmitOrder,
        progressIndicator: const CircularProgressIndicator(),
        child: Consumer<AppTranslations>(builder: (context, tr, child) {
            return SafeArea(
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeadingWithIcon(
                      icon: UIDATAIcons.userIcon,
                      iconColor: UIDataColors.primaryColor,
                      btntxt: tr.translateData("cart_customer_information")),
                  SpacingHeight.heightlistspacing10,
                  CardCustomerDetail(customerDetail: customerDetail),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                       Text(tr.translateData("cart_payment_method"),
                              style: UIDataTextStyles.dialogMsg)
                          .paddingOnly(top: 40, bottom: 10),
                      SizedBox(
                        height: 35,
                        child: CheckboxListTile(
                          checkboxShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          contentPadding: EdgeInsets.zero,
                          title:  Text(tr.translateData("online_payment"),
                              style: UIDataTextStyles.h3),
                          controlAffinity: ListTileControlAffinity.leading,
                          side: const BorderSide(
                            width: 0.8,
                          ),
                          activeColor: UIDataColors.primaryColor,
                          checkColor: UIDataColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          value: _.onlinePayment,
                          onChanged: (value) {
                            _.paymentMethodOnline();
                          },
                        ),
                      ),

                      SizedBox(
                        height: 35,
                        child: CheckboxListTile(
                          checkboxShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          contentPadding: EdgeInsets.zero,
                          title:  Text(tr.translateData("pay_on_receipt"),
                              style: UIDataTextStyles.h3),
                          controlAffinity: ListTileControlAffinity.leading,
                          side: const BorderSide(
                            width: 0.8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          activeColor: UIDataColors.primaryColor,
                          checkColor: UIDataColors.primaryColor,
                          value: _.receiptPaymentMethord,
                          onChanged: (value) {
                            _.paymentMethodReceipt();
                          },
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: PrimaryButtonWithIcon(
                          btntxt: tr.translateData("submit_order"),
                          backEndColor: UIDataColors.whiteColor,
                          buttontxtColor: UIDataColors.primaryColor,
                          iconImageColor: UIDataColors.primaryColor,
                          iconImage: UIDATAIcons.sendIcon,
                          onPressed: () {
                            if (customerDetail != null) {
                              _
                                  .customerInfoSubmitedRequest(
                                      customerDetail!, context)
                                  .then((value) {
                                if (value) {
                                  popupPaymentlink(context);
                                }
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SpacingHeight.heightlistspacing50
                ],
              ).paddingSymmetric(horizontal: 15)),
            );
          }
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      bodyData: bodyData(context),
      backgroundcolor: UIDataColors.whiteColor,
      backGroundImage: UIDataImage.backgroundImage,
      showDrawer: false,
      showFAB: true,
      centerDocked: true,
      showAppBar: true,
      showActions: false,
      scaffoldKey: _key,
      showBottomNav: true,
      appbarcolor: UIDataColors.whiteColor,
      appTitle: 'Customer Detail',
      backarrow: UIDataColors.blackColor,
      qrCallback: () {
        Get.offAll(() => const AddManulOrder());
      },
      floatingIcon: Icons.add,
      elevation: 1.0,
    );
  }
}
