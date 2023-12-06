import 'config/env.dart';

class ApiData {
  static const mainurl = Secret.api_key_url;
  static const logoutApi = "${mainurl}logout_seller";
  static const deleteAccountApi = "${mainurl}delete_seller";
  static const updatePasswordApi = "${mainurl}update_account_password";
  static const updateaAccountInfoApi = "${mainurl}update_account";
  static const updateaEmail = "${mainurl}update_account_email";
  static const sellerAllProducts = "${mainurl}products_new_seller";
  static const getOtp = "${mainurl}request_tmp_seller";
  static const customerListApi = "${mainurl}view_seller_customer";
  static const deleteCustomerApi = "${mainurl}delete_seller_customer";
  static const customerReviewsApi = "${mainurl}customer_reviews";
  static const addCustomer = "${mainurl}add_seller_customer";
  static const updateCustomer = "${mainurl}update_seller_customer";
  static const aboutUsApi = "${mainurl}new_about";
  static const contactUsApi = "${mainurl}contact_us";
  static const productStatusApi = "${mainurl}products_enable_seller";
  static const deliveryCharges = "${mainurl}delivery_charges";
  static const orderSubmitCash = "${mainurl}order_submit_new";
  static const generateLink = "${mainurl}generate_link";
  static const registerSellerApi = "${mainurl}signup_seller";
  static const resetPasswordApi = "${mainurl}reset_password";
  static const verifyResetPassword = "${mainurl}verify_reset";
  static const orderFilterApi = "${mainurl}order_filter";
  static const termsAPi = "${mainurl}terms_seller";
  static const getCities = "${mainurl}get_cities";
  static const privacyApi = "${mainurl}new_privacy";
  static const cartApi = "${mainurl}cart_options";
  static const promoDiscountApi = "${mainurl}discount";
  static const forceUpdateApi = "${mainurl}force_update";
  static const languageSelection = "${mainurl}seller_language";
  static const contract = "${mainurl}seller_contract";
  static const splashNew = "${mainurl}new_seller_splash";

  static const header = {Secret.api_key: Secret.client_secret};
}
