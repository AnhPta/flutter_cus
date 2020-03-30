import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WardEvent extends Equatable {
  WardEvent([List props = const []]) : super(props);
}

class FetchWardEvent extends WardEvent {
  final String selectedDistrictCode;

  FetchWardEvent({
    this.selectedDistrictCode,
  }) : super([
    selectedDistrictCode,
  ]);

  @override
  String toString() {
    return 'FetchWardEvent: { selectedDistrctCode: $selectedDistrictCode }';
  }
}

class SearchWardEvent extends WardEvent {
  final String q;

  SearchWardEvent({
    this.q,
  }) :
      super([
      q,
    ]);

  @override
  String toString() {
    return 'SearchWardEvent';
  }
}
