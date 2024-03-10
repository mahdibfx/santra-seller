// To parse this JSON data, do
//
//     final customerReviewsModel = customerReviewsModelFromJson(jsonString);

import 'dart:convert';

CustomerReviewsModel customerReviewsModelFromJson(String str) =>
    CustomerReviewsModel.fromJson(json.decode(str));

String customerReviewsModelToJson(CustomerReviewsModel data) =>
    json.encode(data.toJson());

class CustomerReviewsModel {
  bool? status;
  List<Datum>? data;

  CustomerReviewsModel({
    this.status,
    this.data,
  });

  factory CustomerReviewsModel.fromJson(Map<String, dynamic> json) =>
      CustomerReviewsModel(
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
  String? totalReviews;
  String? averageStars;
  List<String>? stars;
  List<int>? starsPercent;
  List<CustomerFeedback>? customerFeedback;

  Datum({
    this.totalReviews,
    this.averageStars,
    this.stars,
    this.starsPercent,
    this.customerFeedback,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        totalReviews: json["total_reviews"],
        averageStars: json["average_stars"],
        stars: json["stars"] == null
            ? []
            : List<String>.from(json["stars"]!.map((x) => x)),
        starsPercent: json["stars_percent"] == null
            ? []
            : List<int>.from(json["stars_percent"]!.map((x) => x))
                .reversed
                .toList(),
        customerFeedback: json["customer_feedback"] == null
            ? []
            : List<CustomerFeedback>.from(json["customer_feedback"]!
                .map((x) => CustomerFeedback.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_reviews": totalReviews,
        "average_stars": averageStars,
        "stars": stars == null ? [] : List<dynamic>.from(stars!.map((x) => x)),
        "stars_percent": starsPercent == null
            ? []
            : List<dynamic>.from(starsPercent!.map((x) => x)),
        "customer_feedback": customerFeedback == null
            ? []
            : List<dynamic>.from(customerFeedback!.map((x) => x.toJson())),
      };
}

class CustomerFeedback {
  String? orderNumber;
  String? feedbackStars;
  String? feedbackMessage;

  CustomerFeedback({
    this.orderNumber,
    this.feedbackStars,
    this.feedbackMessage,
  });

  factory CustomerFeedback.fromJson(Map<String, dynamic> json) =>
      CustomerFeedback(
        orderNumber: json["order_number"],
        feedbackStars: json["feedback_stars"],
        feedbackMessage: json["feedback_message"],
      );

  Map<String, dynamic> toJson() => {
        "order_number": orderNumber,
        "feedback_stars": feedbackStars,
        "feedback_message": feedbackMessage,
      };
}
