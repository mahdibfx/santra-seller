// To parse this JSON data, do
//
//     final selllerAllProductsModel = selllerAllProductsModelFromJson(jsonString);

import 'dart:convert';

SelllerAllProductsModel selllerAllProductsModelFromJson(String str) =>
    SelllerAllProductsModel.fromJson(json.decode(str));

String selllerAllProductsModelToJson(SelllerAllProductsModel data) =>
    json.encode(data.toJson());

class SelllerAllProductsModel {
  SelllerAllProductsModel({
    this.status,
    this.data,
  });

  bool? status;
  List<SellerProductData>? data;

  factory SelllerAllProductsModel.fromJson(Map<String, dynamic> json) =>
      SelllerAllProductsModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<SellerProductData>.from(json["data"]!.map((x) => SellerProductData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class SellerProductData {
  SellerProductData({
    this.products,
  });

  List<Product>? products;

  factory SellerProductData.fromJson(Map<String, dynamic> json) => SellerProductData(
        products: json["products"] == null
            ? []
            : List<Product>.from(
                json["products"]!.map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "products": products == null
            ? []
            : List<dynamic>.from(products!.map((x) => x.toJson())),
      };
}

class Product {
  Product({
    this.productCode,
    this.productName,
    this.productPrice,
    this.productType,
    this.categoryCode,
    this.categoryName,
    this.productImages,
    this.productStatus,
    this.modifiers,
  });

  String? productCode;
  String? productName;
  String? productPrice;
  String? productType;
  String? categoryCode;
  String? categoryName;
  String? productImages;
  String? productStatus;
  List<Modifier>? modifiers;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productCode: json["product_code"],
        productName: json["product_name"],
        productPrice: json["product_price"],
        productType: json["product_type"],
        categoryCode: json["category_code"],
        categoryName: json["category_name"],
        productImages: json["product_images"],
        productStatus: json["product_status"],
        modifiers: json["modifiers"] == null
            ? []
            : List<Modifier>.from(
                json["modifiers"]!.map((x) => Modifier.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "product_code": productCode,
        "product_name": productName,
        "product_price": productPrice,
        "product_type": productType,
        "category_code": categoryCode,
        "category_name": categoryName,
        "product_images": productImages,
        "product_status": productStatus,
        "modifiers": modifiers == null
            ? []
            : List<dynamic>.from(modifiers!.map((x) => x.toJson())),
      };
}

class Modifier {
  Modifier({
    this.groupCode,
    this.name,
    this.limitModifiers,
    this.numberModifiers,
    this.selectionType,
    this.modifierMessage,
    this.subModifiers,
  });

  String? groupCode;
  String? name;
  String? limitModifiers;
  String? numberModifiers;
  String? selectionType;
  String? modifierMessage;
  List<SubModifier>? subModifiers;

  factory Modifier.fromJson(Map<String, dynamic> json) => Modifier(
        groupCode: json["group_code"],
        name: json["name"],
        limitModifiers: json["limit_modifiers"],
        numberModifiers: json["number_modifiers"],
        selectionType: json["selection_type"],
        modifierMessage: json["modifier_message"],
        subModifiers: json["sub_modifiers"] == null
            ? []
            : List<SubModifier>.from(
                json["sub_modifiers"]!.map((x) => SubModifier.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "group_code": groupCode,
        "name": name,
        "limit_modifiers": limitModifiers,
        "number_modifiers": numberModifiers,
        "selection_type": selectionType,
        "modifier_message": modifierMessage,
        "sub_modifiers": subModifiers == null
            ? []
            : List<dynamic>.from(subModifiers!.map((x) => x.toJson())),
      };
}

class SubModifier {
  SubModifier({
    this.modifierCode,
    this.nameModifier,
    this.priceModifier,
    this.byDefault,
  });

  String? modifierCode;
  String? nameModifier;
  String? priceModifier;
  String? byDefault;

  factory SubModifier.fromJson(Map<String, dynamic> json) => SubModifier(
        modifierCode: json["modifier_code"],
        nameModifier: json["name_modifier"],
        priceModifier: json["price_modifier"],
        byDefault: json["by_default"],
      );

  Map<String, dynamic> toJson() => {
        "modifier_code": modifierCode,
        "name_modifier": nameModifier,
        "price_modifier": priceModifier,
        "by_default": byDefault,
      };
}
