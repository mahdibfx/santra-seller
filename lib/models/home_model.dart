// To parse this JSON data, do
//
//     final homeModel = homeModelFromJson(jsonString);

import 'dart:convert';
import 'dart:developer';

HomeModel homeModelFromJson(String str) => HomeModel.fromJson(json.decode(str));

String homeModelToJson(HomeModel data) => json.encode(data.toJson());

class HomeModel {
  HomeModel({
    required this.status,
    required this.data,
  });

  bool status;
  List<HomeData> data;

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
        status: json["status"],
        data:
            List<HomeData>.from(json["data"].map((x) => HomeData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class HomeData {
  HomeData({
    required this.totalNotifications,
    required this.showContract,
    required this.titleMessage,
    required this.ordersMonthly,
    required this.profitMonthly,
     this.santraOrders,
     this.manualOrders,
     this.pendingOrders,this.allOrders,
    this.multiBranch,
  });

  String totalNotifications;
  String showContract;
  String titleMessage;
  num ordersMonthly;
  num profitMonthly;
  List<SantraOrder>? santraOrders;
  List<ManualOrder>? manualOrders;
  List<AllOrders>? allOrders;

  List<PendingOrder>? pendingOrders;
  List<MultiBranchData>? multiBranch;

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
        totalNotifications: json["total_notifications"],
        showContract: json["show_contract"],
        titleMessage: json["title_message"],
        ordersMonthly: json["orders_monthly"],
        profitMonthly: json["profit_monthly"],
        allOrders:List<AllOrders>.from(
            json["all_orders"].map((x) => AllOrders.fromJson(x))) ,
        santraOrders: List<SantraOrder>.from(
            json["santra_orders"].map((x) => SantraOrder.fromJson(x))),
        manualOrders: List<ManualOrder>.from(
            json["manual_orders"].map((x) => ManualOrder.fromJson(x))),
        pendingOrders: List<PendingOrder>.from(
            json["pending_orders"].map((x) => PendingOrder.fromJson(x))),
        multiBranch: List<MultiBranchData>.from(
            json["multi_branches"].map((x) => MultiBranchData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_notifications": totalNotifications,
        "show_contract": showContract,
        "title_message": titleMessage,
        "santra_orders":
            List<dynamic>.from(santraOrders!.map((x) => x.toJson())),
        "manual_orders":
            List<dynamic>.from(manualOrders!.map((x) => x.toJson())),
        "pending_orders":
            List<dynamic>.from(pendingOrders!.map((x) => x.toJson())),
      };
}

class ManualOrder {
  ManualOrder({
    required this.orderCount,
 
  });

  num orderCount;

  factory ManualOrder.fromJson(Map<String, dynamic> json) => ManualOrder(
         orderCount:  int.tryParse(json["order_count"].toString()) ?? 0,
       
      );

  Map<String, dynamic> toJson() => {
        "order_count": orderCount,
    
      };
}

class Order {
  Order(
      {required this.orderNumber,
      required this.customerPhone,
      required this.orderStatus,
      required this.customerName,
      required this.areaCustomer,
      required this.totalOrderAmount,
      this.cashCharges,
      this.deliveryCharges,
      this.orderDiscount,
      required this.orderDateStamp,
      required this.paymentMethod,
      required this.advanceTime,
      required this.orderRemarks,
      required this.orderType,
      required this.orderItems,
      required this.paymentLink,
      required this.colorCode,
      this.pdfLink,
      this.requestImage});

  String orderNumber;
  String orderStatus;
  String customerName;
  String areaCustomer;
  String totalOrderAmount;
  String? cashCharges;
  String? deliveryCharges;
  String? orderDiscount;
  DateTime orderDateStamp;
  String paymentMethod;
  String customerPhone;
  String advanceTime;
  String orderRemarks;
  String orderType;
  String paymentLink;
  String colorCode;
  String? requestImage;
  String? pdfLink;
  List<OrderItem> orderItems;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderNumber: json["order_number"],
        orderStatus: json["order_status"],
        customerName: json["customer_name"],
        areaCustomer: json["area_customer"],
        totalOrderAmount: json["total_order_amount"],
        cashCharges: json["cash_charges"],
        deliveryCharges: json["delivery_charges"],
        orderDiscount: json["order_discount"],
        orderDateStamp: DateTime.parse(json["order_date_stamp"]),
        paymentMethod: json["payment_method"],
        advanceTime: json["advance_time"],
        orderRemarks: json["order_remarks"],
        orderType: json["order_type"],
        customerPhone: json['customer_phone'],
        paymentLink: json["payment_link"],
        colorCode: json["color_code"],
        requestImage: json["request_image"],
        pdfLink: json["request_pdf"],
        orderItems: List<OrderItem>.from(
            json["order_items"].map((x) => OrderItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "order_number": orderNumber,
        "order_status": orderStatus,
        "customer_name": customerName,
        "total_order_amount": totalOrderAmount,
        "order_date_stamp": orderDateStamp.toIso8601String(),
        "payment_method": paymentMethod,
        "order_type": orderType,
        'customer_phone': customerPhone,
        "advance_time": advanceTime,
        "order_remarks": orderRemarks,
        "order_items": List<dynamic>.from(orderItems.map((x) => x.toJson())),
      };
}

class OrderItem {
  OrderItem({
    required this.productName,
    required this.productNameArabic,
    required this.productTotal,
    required this.productImage,
    required this.productQuantity,
    required this.itemImages,
    required this.itemRemarks,
    required this.itemPdf
  });

  String productName;
  String productNameArabic;
  String productTotal;
  String productImage;
  String productQuantity;
  String itemRemarks;
  String itemPdf; 
  List<String> itemImages;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    
    log(json.toString());
    return OrderItem(
        productName: json["product_name"],
        productNameArabic: json["product_name_ar"],
        productTotal: json["product_total"],

        productImage: json["product_image"] ?? '',
        productQuantity: json["product_quantity"], itemImages: [json['item_image_1'] ??'',json['item_image_2'] ?? ''], itemRemarks: json['item_remarks'] ?? 'no_remarks', itemPdf: json['item_pdf'] ?? '',
      );}

  Map<String, dynamic> toJson() => {
        "product_name": productName,
        "product_total": productTotal,
        "product_image": productImage,
        "product_quantity": productQuantity,
        'item_image_1':itemImages.first,
        'item_image_2':itemImages[1],
        'item_remarks':itemRemarks,
        'item_pdf':itemPdf
      };
}

class PendingOrder {
  PendingOrder({
    required this.orderCount,

  });

  num orderCount;

  factory PendingOrder.fromJson(Map<String, dynamic> json) => PendingOrder(
        orderCount:  int.tryParse(json["order_count"].toString()) ?? 0,
       
      );

  Map<String, dynamic> toJson() => {
        "order_count": orderCount,

      };
}
class AllOrders {
  AllOrders({
    required this.orderCount,

  });

  num orderCount;

  factory AllOrders.fromJson(Map<String, dynamic> json) => AllOrders(
        orderCount:  int.tryParse(json["order_count"].toString()) ?? 0,
       
      );

  Map<String, dynamic> toJson() => {
        "order_count": orderCount,

      };
}
class SantraOrder {
  SantraOrder({
    required this.orderCount,
  });

  num orderCount;

  factory SantraOrder.fromJson(Map<String, dynamic> json) => SantraOrder(
        orderCount:  int.tryParse(json["order_count"].toString()) ?? 0,
    
      );

  Map<String, dynamic> toJson() => {
        "order_count": orderCount,
    
      };
}

class MultiBranchData {
  MultiBranchData(
      {required this.sellerCode,
      required this.sellerTitle,
      required this.sellerTitleAr});

  String sellerCode;
  String sellerTitle;
  String sellerTitleAr;

  factory MultiBranchData.fromJson(Map<String, dynamic> json) =>
      MultiBranchData(
        sellerCode: json["seller_code"],
        sellerTitle: json["seller_title"],
        sellerTitleAr: json["seller_title_ar"],
      );
}
