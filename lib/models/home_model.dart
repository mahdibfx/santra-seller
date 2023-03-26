// To parse this JSON data, do
//
//     final homeModel = homeModelFromJson(jsonString);

import 'dart:convert';

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
        data: List<HomeData>.from(json["data"].map((x) => HomeData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class HomeData {
    HomeData({
        required this.totalNotifications,
        required this.ordersMonthly,
        required this.profitMonthly,
        required this.santraOrders,
        required this.manualOrders,
        required this.pendingOrders,
    });

    String totalNotifications;
    int ordersMonthly;
    int profitMonthly;
    List<SantraOrder> santraOrders;
    List<ManualOrder> manualOrders;
    List<PendingOrder> pendingOrders;

    factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
        totalNotifications: json["total_notifications"],
        ordersMonthly: json["orders_monthly"],
        profitMonthly: json["profit_monthly"],
        santraOrders: List<SantraOrder>.from(json["santra_orders"].map((x) => SantraOrder.fromJson(x))),
        manualOrders: List<ManualOrder>.from(json["manual_orders"].map((x) => ManualOrder.fromJson(x))),
        pendingOrders: List<PendingOrder>.from(json["pending_orders"].map((x) => PendingOrder.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "total_notifications": totalNotifications,
        "santra_orders": List<dynamic>.from(santraOrders.map((x) => x.toJson())),
        "manual_orders": List<dynamic>.from(manualOrders.map((x) => x.toJson())),
        "pending_orders": List<dynamic>.from(pendingOrders.map((x) => x.toJson())),
    };
}

class ManualOrder {
    ManualOrder({
        required this.orderCount,
        required this.manualOrders,
    });

    int orderCount;
    List<Order> manualOrders;

    factory ManualOrder.fromJson(Map<String, dynamic> json) => ManualOrder(
        orderCount: json["order_count"],
        manualOrders: List<Order>.from(json["manual_orders"].map((x) => Order.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "order_count": orderCount,
        "manual_orders": List<dynamic>.from(manualOrders.map((x) => x.toJson())),
    };
}

class Order {
    Order({
        required this.orderNumber,
        required this.orderStatus,
        required this.customerName,
        required this.totalOrderAmount,
        required this.orderDateStamp,
        required this.paymentMethod,
        required this.advanceTime,
        required this.orderRemarks,
        required this.orderItems,
    });

    String orderNumber;
    String orderStatus;
    String customerName;
    String totalOrderAmount;
    DateTime orderDateStamp;
    String paymentMethod;
    String advanceTime;
    String orderRemarks;
    List<OrderItem> orderItems;

    factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderNumber: json["order_number"],
        orderStatus: json["order_status"],
        customerName: json["customer_name"],
        totalOrderAmount: json["total_order_amount"],
        orderDateStamp: DateTime.parse(json["order_date_stamp"]),
        paymentMethod: json["payment_method"],
        advanceTime: json["advance_time"],
        orderRemarks: json["order_remarks"],
        orderItems: List<OrderItem>.from(json["order_items"].map((x) => OrderItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "order_number": orderNumber,
        "order_status": orderStatus,
        "customer_name": customerName,
        "total_order_amount": totalOrderAmount,
        "order_date_stamp": orderDateStamp.toIso8601String(),
        "payment_method": paymentMethod,
        "advance_time": advanceTime,
        "order_remarks": orderRemarks,
        "order_items": List<dynamic>.from(orderItems.map((x) => x.toJson())),
    };
}

class OrderItem {
    OrderItem({
        required this.productName,
        required this.productTotal,
        required this.productImage,
        required this.productQuantity,
    });

    String productName;
    String productTotal;
    String productImage;
    String productQuantity;

    factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        productName: json["product_name"],
        productTotal: json["product_total"],
        productImage: json["product_image"],
        productQuantity: json["product_quantity"],
    );

    Map<String, dynamic> toJson() => {
        "product_name": productName,
        "product_total": productTotal,
        "product_image": productImage,
        "product_quantity": productQuantity,
    };
}





class PendingOrder {
    PendingOrder({
        required this.orderCount,
        required this.pendingOrders,
    });

    int orderCount;
    List<Order> pendingOrders;

    factory PendingOrder.fromJson(Map<String, dynamic> json) => PendingOrder(
        orderCount: json["order_count"],
        pendingOrders: List<Order>.from(json["pending_orders"].map((x) => Order.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "order_count": orderCount,
        "pending_orders": List<dynamic>.from(pendingOrders.map((x) => x.toJson())),
    };
}

class SantraOrder {
    SantraOrder({
        required this.orderCount,
        required this.santraOrders,
    });

    int orderCount;
    List<Order> santraOrders;

    factory SantraOrder.fromJson(Map<String, dynamic> json) => SantraOrder(
        orderCount: json["order_count"],
        santraOrders: List<Order>.from(json["santra_orders"].map((x) => Order.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "order_count": orderCount,
        "santra_orders": List<dynamic>.from(santraOrders.map((x) => x.toJson())),
    };
}


