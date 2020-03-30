import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CancelReasonEvent extends Equatable {
  CancelReasonEvent([List props = const []]) : super(props);
}

class FetchCancelReasonEvent extends CancelReasonEvent {
  @override
  String toString() {
    return 'FetchCancelReasonEvent';
  }
}

class SetLoadedReasonEvent extends CancelReasonEvent {
  @override
  String toString() {
    return 'SetLoadedShipmentEvent';
  }
}