// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
    NotificationModel({
        required this.status,
        required this.data,
    });

    bool status;
    List<NotificationData> data;

    factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        status: json["status"],
        data: List<NotificationData>.from(json["data"].map((x) => NotificationData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class NotificationData {
    NotificationData({
        required this.newNotifications,
        required this.oldNotifications,
    });

    List<dynamic> newNotifications;
    List<OldNotification> oldNotifications;

    factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
        newNotifications: List<dynamic>.from(json["new_notifications"].map((x) => x)),
        oldNotifications: List<OldNotification>.from(json["old_notifications"].map((x) => OldNotification.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "new_notifications": List<dynamic>.from(newNotifications.map((x) => x)),
        "old_notifications": List<dynamic>.from(oldNotifications.map((x) => x.toJson())),
    };
}

class OldNotification {
    OldNotification({
        required this.notifiactionDetail,
        required this.notificationStatus,
        required this.notificationTime,
    });

    String notifiactionDetail;
    NotificationStatus notificationStatus;
    DateTime notificationTime;

    factory OldNotification.fromJson(Map<String, dynamic> json) => OldNotification(
        notifiactionDetail: json["notifiaction_detail"],
        notificationStatus: notificationStatusValues.map[json["notification_status"]]!,
        notificationTime: DateTime.parse(json["notification_time"]),
    );

    Map<String, dynamic> toJson() => {
        "notifiaction_detail": notifiactionDetail,
        "notification_status": notificationStatusValues.reverse[notificationStatus],
        "notification_time": notificationTime.toIso8601String(),
    };
}

enum NotificationStatus { VIEWED }

final notificationStatusValues = EnumValues({
    "viewed": NotificationStatus.VIEWED
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
