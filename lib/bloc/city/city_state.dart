import 'package:app_customer/repositories/city/city.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class CityState extends Equatable {
  CityState([List props = const []]) : super(props);
}

class InitialCityState extends CityState {
  @override
  String toString() => 'InitialCityState';
}

class LoadingCityState extends CityState {
  @override
  String toString() => 'LoadingCityState';
}

class LoadedCityState extends CityState {
  final List<City> cities;
  final List<City> oldCities;
  LoadedCityState({
    @required this.cities,
    this.oldCities,
  }) : super([
    cities,
    oldCities,
  ]);

  @override
  String toString() => '''LoadedCityState {
      cities: '[${cities.length}]' - $cities, 
      oldCities: '[${oldCities.length}]' - $oldCities, 
    }''';

  factory LoadedCityState.empty() {
    return LoadedCityState(
      cities: [],
      oldCities: [],
    );
  }
}

class FailureCityState extends CityState {
  final String error;
  FailureCityState({@required this.error}) : super([error]);

  @override
  String toString() => 'FailureCityState {error: $error}';
}
