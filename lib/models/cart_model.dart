// To parse this JSON data, do
//
//     final cartModel = cartModelFromJson(jsonString);

import 'dart:convert';

CartModel cartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String cartModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
  final bool? status;
  final List<Datum>? data;

  CartModel({
    this.status,
    this.data,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  final int? deliveryChargesExpress;
  final int? taxFee;
  final int? cashCharges;
  final int? deliveryCharges;
  final int? deliveryChargesCap;
  final int? deliveryChargesReal;
  final List<dynamic>? vouchers;
  final List<CheckFlag>? checkFlags;
  final String? sellerCity;
  final List<String>? vipSlots;
  final int? deliveryChargesVip;

  Datum(
      {this.deliveryChargesExpress,
      this.taxFee,
      this.cashCharges,
      this.deliveryCharges,
      this.deliveryChargesCap,
      this.deliveryChargesReal,
      this.vouchers,
      this.checkFlags,
      this.sellerCity,
      this.vipSlots,
      this.deliveryChargesVip});

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        deliveryChargesExpress: json["delivery_charges_express"],
        taxFee: json["tax_fee"],
        cashCharges: json["cash_charges"],
        deliveryCharges: json["delivery_charges"],
        deliveryChargesCap: json["delivery_charges_cap"],
        deliveryChargesReal: json["delivery_charges_real"],
        vouchers: json["vouchers"] == null
            ? []
            : List<dynamic>.from(json["vouchers"]!.map((x) => x)),
        checkFlags: json["check_flags"] == null
            ? []
            : List<CheckFlag>.from(
                json["check_flags"]!.map((x) => CheckFlag.fromJson(x))),
        sellerCity: json["seller_city"],
        vipSlots: json["vip_slots"] == null
            ? []
            : List<String>.from(json["vip_slots"]!.map((x) => x)),
        deliveryChargesVip: json["delivery_charges_vip"],
      );

  Map<String, dynamic> toJson() => {
        "delivery_charges_express": deliveryChargesExpress,
        "tax_fee": taxFee,
        "cash_charges": cashCharges,
        "delivery_charges": deliveryCharges,
        "delivery_charges_cap": deliveryChargesCap,
        "delivery_charges_real": deliveryChargesReal,
        "vouchers":
            vouchers == null ? [] : List<dynamic>.from(vouchers!.map((x) => x)),
        "check_flags": checkFlags == null
            ? []
            : List<dynamic>.from(checkFlags!.map((x) => x.toJson())),
        "seller_city": sellerCity,
        "vip_slots":
            vipSlots == null ? [] : List<dynamic>.from(vipSlots!.map((x) => x)),
      };
}

class CheckFlag {
  final String? cashOnDelivery;
  final String? cardPayment;
  final String? pickupAllowed;
  final String? expressFlag;
  final String? vipFlag;
  final DateTime? vipStart;
  final DateTime? vipEnd;

  CheckFlag({
    this.cashOnDelivery,
    this.cardPayment,
    this.pickupAllowed,
    this.expressFlag,
    this.vipFlag,
    this.vipStart,
    this.vipEnd,
  });

  factory CheckFlag.fromJson(Map<String, dynamic> json) => CheckFlag(
        cashOnDelivery: json["cash_on_delivery"],
        cardPayment: json["card_payment"],
        pickupAllowed: json["pickup_allowed"],
        expressFlag: json["express_flag"],
        vipFlag: json["vip_flag"],
        vipStart: json["vip_start"] == null
            ? null
            : DateTime.parse(json["vip_start"]),
        vipEnd:
            json["vip_end"] == null ? null : DateTime.parse(json["vip_end"]),
      );

  Map<String, dynamic> toJson() => {
        "cash_on_delivery": cashOnDelivery,
        "card_payment": cardPayment,
        "pickup_allowed": pickupAllowed,
        "express_flag": expressFlag,
        "vip_flag": vipFlag,
        "vip_start":
            "${vipStart!.year.toString().padLeft(4, '0')}-${vipStart!.month.toString().padLeft(2, '0')}-${vipStart!.day.toString().padLeft(2, '0')}",
        "vip_end":
            "${vipEnd!.year.toString().padLeft(4, '0')}-${vipEnd!.month.toString().padLeft(2, '0')}-${vipEnd!.day.toString().padLeft(2, '0')}",
      };
}
