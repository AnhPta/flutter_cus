import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DistrictEvent extends Equatable {
  DistrictEvent([List props = const []]) : super(props);
}

class FetchDistrictEvent extends DistrictEvent {
  final String selectedCityCode;

  FetchDistrictEvent({
    this.selectedCityCode,
  }) : super([
    selectedCityCode,
  ]);

  @override
  String toString() {
    return 'FetchDistrictEvent: { selectedCityCode: $selectedCityCode }';
  }
}

class SearchDistrictEvent extends DistrictEvent {
  final String q;

  SearchDistrictEvent({
    this.q,
  }) :
      super([
      q,
    ]);

  @override
  String toString() {
    return 'SearchDistrictEvent';
  }
}
