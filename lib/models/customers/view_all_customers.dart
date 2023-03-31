// To parse this JSON data, do
//
//     final viewAllCustomers = viewAllCustomersFromJson(jsonString);

import 'dart:convert';

ViewAllCustomers viewAllCustomersFromJson(String str) =>
    ViewAllCustomers.fromJson(json.decode(str));

String viewAllCustomersToJson(ViewAllCustomers data) =>
    json.encode(data.toJson());

class ViewAllCustomers {
  ViewAllCustomers({
    this.status,
    this.data,
  });

  bool? status;
  List<Datum>? data;

  factory ViewAllCustomers.fromJson(Map<String, dynamic> json) =>
      ViewAllCustomers(
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
    this.id,
    this.customerName,
    this.customerMobile,
    this.customerEmail,
    this.customerCity,
    this.buildingNumber,
    this.buildingType,
    this.addressLink,
  });

  String? id;
  String? customerName;
  String? customerMobile;
  String? customerEmail;
  String? customerCity;
  String? buildingNumber;
  String? buildingType;
  String? addressLink;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        customerName: json["customer_name"],
        customerMobile: json["customer_mobile"],
        customerEmail: json["customer_email"],
        customerCity: json["customer_city"],
        buildingNumber: json["building_number"],
        buildingType: json["building_type"],
        addressLink: json["address_link"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_name": customerName,
        "customer_mobile": customerMobile,
        "customer_email": customerEmail,
        "customer_city": customerCity,
        "building_number": buildingNumber,
        "building_type": buildingType,
        "address_link": addressLink,
      };
}
