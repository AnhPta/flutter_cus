import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:app_customer/repositories/pack_scan/pack_scan.dart';

@immutable
abstract class PackScanEvent extends Equatable {
  PackScanEvent([List props = const []]) : super(props);
}

class LoadPackScan extends PackScanEvent {
  @override
  String toString() => 'LoadPackScan';
}

class AddPackScan extends PackScanEvent {
  final String code;

  AddPackScan({@required this.code}) : super([code]);

  @override
  String toString() => 'AddPackScan { code: $code }';
}

class UpdatePackScan extends PackScanEvent {
  final PackScan packScan;

  UpdatePackScan(this.packScan) : super([packScan]);

  @override
  String toString() => 'UpdatePackScan { packScan: $packScan }';
}

class DeletePackScan extends PackScanEvent {
  final PackScan packScan;

  DeletePackScan(this.packScan) : super([packScan]);

  @override
  String toString() => 'DeletePackScan { packScan: $packScan }';
}
