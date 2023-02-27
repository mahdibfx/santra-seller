// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
    LoginModel({
        required this.status,
        required this.data,
    });

    bool status;
    List<LoginData> data;

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        status: json["status"],
        data: List<LoginData>.from(json["data"].map((x) => LoginData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class LoginData {
    LoginData({
        required this.message,
        required this.userId,
        required this.firstName,
        required this.lastName,
        required this.userEmail,
        required this.phoneNumber,
        required this.userGender,
        required this.dateOfBirth,
        required this.userStatus,
        required this.userCountry,
        required this.sellerCode,
        required this.sellerLogo,
    });

    String message;
    String userId;
    String firstName;
    String lastName;
    String userEmail;
    String phoneNumber;
    String userGender;
    DateTime dateOfBirth;
    String userStatus;
    String userCountry;
    String sellerCode;
    String sellerLogo;

    factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
        message: json["message"],
        userId: json["user_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        userEmail: json["user_email"],
        phoneNumber: json["phone_number"],
        userGender: json["user_gender"],
        dateOfBirth: DateTime.parse(json["date_of_birth"]),
        userStatus: json["user_status"],
        userCountry: json["user_country"],
        sellerCode: json["seller_code"],
        sellerLogo: json["seller_logo"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "user_id": userId,
        "first_name": firstName,
        "last_name": lastName,
        "user_email": userEmail,
        "phone_number": phoneNumber,
        "user_gender": userGender,
        "date_of_birth": "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
        "user_status": userStatus,
        "user_country": userCountry,
        "seller_code": sellerCode,
        "seller_logo": sellerLogo,
    };
}
