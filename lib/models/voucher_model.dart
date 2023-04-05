class VoucherModel {
  VoucherModel(
      {this.msg,
      this.offerTitle,
      this.disType,
      this.capAmount,
      this.discountApplied,
      this.msgToShow});

  String? msg;
  String? offerTitle;
  String? disType;
  String? capAmount;
  String? discountApplied;
  String? msgToShow;

  factory VoucherModel.fromJson(Map<String, dynamic> json) => VoucherModel(
        msg: json["message"],
        offerTitle: json["promotion_name"],
        disType: json["discount_type"],
        capAmount: json["cap_amount"],
        discountApplied: json["discount_applied"],
        msgToShow: json["msg_to_show"],
      );

  Map<String, dynamic> toJson() => {
        "message": msg,
        "promotion_name": offerTitle,
        "discount_type": disType,
        "cap_amount": capAmount,
        "discount_applied": discountApplied,
        "msg_to_show": msgToShow
      };
}
