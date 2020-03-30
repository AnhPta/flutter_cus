import 'package:app_customer/repositories/detail_shipment/detail_shipment.dart';
import 'package:app_customer/repositories/shipment/shipment.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class DetailShipmentState extends Equatable {
  DetailShipmentState([List props = const []]) : super(props);
}

class InitialDetailShipmentState extends DetailShipmentState {
  @override
  String toString() {
    return 'InitialDetailShipmentState';
  }
}

class LoadingDetailShipmentState extends DetailShipmentState {
  @override
  String toString() {
    return 'LoadingDetailShipmentState';
  }
}

class LoadedDetailShipmentState extends DetailShipmentState {
  final DetailShipment detailShipment;
  final Shipment shipment;
  final String codeShipmentSelected;

  LoadedDetailShipmentState({
  this.detailShipment,
  this.shipment,
  this.codeShipmentSelected,
  }) : super([
    detailShipment,
    shipment,
    codeShipmentSelected
  ]);

  @override
  String toString() => 'LoadedDetailShipmentState: $detailShipment';

  factory LoadedDetailShipmentState.empty() {
    return LoadedDetailShipmentState(
      detailShipment: DetailShipment.empty(),
      shipment: Shipment.empty(),
      codeShipmentSelected: '',
    );
  }

  LoadedDetailShipmentState copyWith({
    DetailShipment detailShipment,
    Shipment shipment,
    String codeShipmentSelected,
})

  {
    return LoadedDetailShipmentState(
      detailShipment: detailShipment,
      shipment: shipment,
      codeShipmentSelected: codeShipmentSelected,
    );
  }
}

class FailureDetailShipmentState extends DetailShipmentState {
  final String error;
  FailureDetailShipmentState({@required this.error}) : super([error]);

  @override
  String toString() {
    return 'FailureDetailShipmentState {error: $error}';
  }
}
