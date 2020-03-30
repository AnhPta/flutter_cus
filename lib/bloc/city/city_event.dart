import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CityEvent extends Equatable {
  CityEvent([List props = const []]) : super(props);
}

class FetchCityEvent extends CityEvent {
  @override
  String toString() {
    return 'FetchCityEvent';
  }
}

class SearchCityEvent extends CityEvent {
  final String q;

  SearchCityEvent({
    this.q,
  }) :
      super([
      q,
    ]);

  @override
  String toString() {
    return 'SearchCityEvent';
  }
}
