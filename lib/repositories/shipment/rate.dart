import 'package:equatable/equatable.dart';

class Rate extends Equatable {
  final double convertWeight;
  final String deliveryAt;
  final double fee;
  final int id;
  final String pickupAt;
  final int serviceId;
  final String serviceName;
  final int servicePriority;
  final double weight;

  Rate({
    this.convertWeight,
    this.deliveryAt,
    this.fee,
    this.id,
    this.pickupAt,
    this.serviceId,
    this.serviceName,
    this.servicePriority,
    this.weight,

  }) : super([
    convertWeight, deliveryAt, fee, id, pickupAt, serviceId, serviceName, servicePriority, weight
  ]);

  Rate copyWith({
    double convertWeight,
    String deliveryAt,
    double fee,
    int id,
    String pickupAt,
    int serviceId,
    String serviceName,
    int servicePriority,
    double weight,
  })
  {
    return Rate(
      convertWeight: convertWeight ?? this.convertWeight,
      deliveryAt: deliveryAt ?? this.deliveryAt,
      fee: fee ?? this.fee,
      id: id ?? this.id,
      pickupAt: pickupAt ?? this.pickupAt,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      servicePriority: servicePriority ?? this.servicePriority,
      weight: weight ?? this.weight,
    );
  }
  static Rate fromJson(dynamic json) {
    return Rate(
      convertWeight: json['convert_weight'],
      deliveryAt: json['delivery_at'],
      fee: json['fee'],
      id: json['id'],
      pickupAt: json['pickup_at'],
      serviceId: json['service_id'],
      serviceName: json['service_name'],
      servicePriority: json['service_priority'],
      weight: json['weight']
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'convertWeight': this.convertWeight,
      'deliveryAt': this.deliveryAt,
      'fee': this.fee,
      'id': this.id,
      'pickupAt': this.pickupAt,
      'serviceId': this.serviceId,
      'serviceName': this.serviceName,
      'servicePriority': this.servicePriority,
      'weight': this.weight,
    };
  }
  @override
  String toString() => '$id|$serviceName|$fee';

  factory Rate.empty() {
    return Rate(
      convertWeight: 0,
      deliveryAt: '',
      fee: 0,
      id: 0,
      pickupAt: '',
      serviceId: 0,
      serviceName: '',
      servicePriority: 0,
      weight: 0,
    );
  }
}
