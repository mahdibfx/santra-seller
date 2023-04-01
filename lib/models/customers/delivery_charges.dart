class DeliveryChargesModel {
  bool? status;
  List<DeliveryData>? data;

  DeliveryChargesModel({this.status, this.data});

  DeliveryChargesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <DeliveryData>[];
      json['data'].forEach((v) {
        data!.add(new DeliveryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DeliveryData {
  String? deliveryCharges;

  DeliveryData({this.deliveryCharges});

  DeliveryData.fromJson(Map<String, dynamic> json) {
    deliveryCharges = json['delivery_charges'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['delivery_charges'] = this.deliveryCharges;
    return data;
  }
}