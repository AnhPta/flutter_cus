import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DetailShipmentEvent extends Equatable {
  DetailShipmentEvent([List props = const []]) : super(props);
}

class FetchDetailShipmentEvent extends DetailShipmentEvent {
  final String codeShipment;
  FetchDetailShipmentEvent({this.codeShipment})
    : super([codeShipment]);
  @override
  String toString() {
    return 'FetchDetailShipmentEvent';
  }
}

class SetLoadedDetailShipmentEvent extends DetailShipmentEvent {
  @override
  String toString() {
    return 'SetLoadedDetailShipmentEvent';
  }
}