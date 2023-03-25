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
  List<SellerAllProductsDatum>? data;

  factory SelllerAllProductsModel.fromJson(Map<String, dynamic> json) =>
      SelllerAllProductsModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<SellerAllProductsDatum>.from(
                json["data"]!.map((x) => SellerAllProductsDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class SellerAllProductsDatum {
  SellerAllProductsDatum({
    this.products,
  });

  List<Product>? products;

  factory SellerAllProductsDatum.fromJson(Map<String, dynamic> json) =>
      SellerAllProductsDatum(
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
    this.category,
    this.categoryProducts,
  });

  String? category;
  List<CategoryProduct>? categoryProducts;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        category: json["category"],
        categoryProducts: json["category_products"] == null
            ? []
            : List<CategoryProduct>.from(json["category_products"]!
                .map((x) => CategoryProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "category_products": categoryProducts == null
            ? []
            : List<dynamic>.from(categoryProducts!.map((x) => x.toJson())),
      };
}

class CategoryProduct {
  CategoryProduct({
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

  factory CategoryProduct.fromJson(Map<String, dynamic> json) =>
      CategoryProduct(
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
