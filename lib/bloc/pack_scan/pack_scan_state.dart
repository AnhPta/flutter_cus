import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:app_customer/repositories/pack_scan/pack_scan.dart';

@immutable
abstract class PackScanState extends Equatable {
  PackScanState([List props = const []]) : super(props);
}

class InitialPackScanState extends PackScanState {
  @override
  String toString() => 'InitialPackScanState';
}

class LoadedPackScanState extends PackScanState {
  final List<PackScan> packScans;
  final String currentCode;

  LoadedPackScanState([this.packScans = const [], this.currentCode = ''])
      : super([packScans, currentCode]);

  @override
  String toString() =>
      'LoadedPackScanState { packScans: $packScans, currentCode: $currentCode }';
}

class NotLoadedPackScanState extends PackScanState {
  @override
  String toString() => 'NotLoadedPackScanState';
}

class NotifyPackScanState extends PackScanState {
  final int type;
  final String message;

  NotifyPackScanState({this.type, this.message}) : super([type, message]);

  @override
  String toString() => 'NotifyPackScanState { type: $type, message: $message }';
}
