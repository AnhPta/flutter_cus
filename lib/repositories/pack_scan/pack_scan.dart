import 'package:equatable/equatable.dart';

class PackScan extends Equatable {
  final String code;
  final String shipmentCode;
  final String status;
  final int scan;

  PackScan({this.code, this.shipmentCode, this.status, this.scan})
      : super([code, shipmentCode, status, scan]);

  @override
  String toString() =>
      'PackScan { code: $code, shipmentCode: $shipmentCode, status: $status, scan: $scan }';

  PackScan copyWith(
      {String code, String shipmentCode, String status, int scan}) {
    return PackScan(
      code: code ?? this.code,
      shipmentCode: shipmentCode ?? this.shipmentCode,
      status: status ?? this.status,
      scan: scan ?? this.scan,
    );
  }

  static PackScan fromJson(dynamic json) {
    return PackScan(
      code: json['code'],
      shipmentCode: json['shipment_code'],
      status: json['status'],
      scan: json['scan'],
    );
  }
}
