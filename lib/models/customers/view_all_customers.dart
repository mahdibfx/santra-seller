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
  List<CustomerDatum>? data;

  factory ViewAllCustomers.fromJson(Map<String, dynamic> json) =>
      ViewAllCustomers(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<CustomerDatum>.from(
                json["data"]!.map((x) => CustomerDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class CustomerDatum {
  CustomerDatum({
    this.customers,
    this.cities,
  });

  List<Customer>? customers;
  List<String>? cities;

  factory CustomerDatum.fromJson(Map<String, dynamic> json) => CustomerDatum(
        customers: json["customers"] == null
            ? []
            : List<Customer>.from(
                json["customers"]!.map((x) => Customer.fromJson(x))),
        cities: json["cities"] == null
            ? []
            : List<String>.from(json["cities"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "customers": customers == null
            ? []
            : List<dynamic>.from(customers!.map((x) => x.toJson())),
        "cities":
            cities == null ? [] : List<dynamic>.from(cities!.map((x) => x)),
      };
}

class Customer {
  Customer({
    this.id,
    this.customerName,
    this.customerMobile,
    this.customerEmail,
    this.customerCity,
    this.customerArea,
    this.buildingNumber,
    this.buildingType,
    this.addressLink,
  });

  String? id;
  String? customerName;
  String? customerMobile;
  String? customerEmail;
  String? customerCity;
  String? customerArea;
  String? buildingNumber;
  String? buildingType;
  String? addressLink;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        customerName: json["customer_name"],
        customerMobile: json["customer_mobile"],
        customerEmail: json["customer_email"],
        customerCity: json["customer_city"],
        customerArea: json["customer_area"],
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
        "customer_area": customerArea,
        "building_number": buildingNumber,
        "building_type": buildingType,
        "address_link": addressLink,
      };
}
