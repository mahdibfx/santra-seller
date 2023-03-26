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
  List<Datum>? data;

  factory SelllerAllProductsModel.fromJson(Map<String, dynamic> json) =>
      SelllerAllProductsModel(
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
  Datum({
    this.products,
  });

  List<Product>? products;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
    this.modifiers,
  });

  String? productCode;
  String? productName;
  String? productPrice;
  String? productType;
  String? categoryCode;
  String? categoryName;
  String? productImages;
  List<dynamic>? modifiers;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productCode: json["product_code"],
        productName: json["product_name"],
        productPrice: json["product_price"],
        productType: json["product_type"],
        categoryCode: json["category_code"],
        categoryName: json["category_name"],
        productImages: json["product_images"],
        modifiers: json["modifiers"] == null
            ? []
            : List<dynamic>.from(json["modifiers"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "product_code": productCode,
        "product_name": productName,
        "product_price": productPrice,
        "product_type": productType,
        "category_code": categoryCode,
        "category_name": categoryName,
        "product_images": productImages,
        "modifiers": modifiers == null
            ? []
            : List<dynamic>.from(modifiers!.map((x) => x)),
      };
}
