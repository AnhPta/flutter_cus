import 'package:app_customer/repositories/district/district.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class DistrictState extends Equatable {
  DistrictState([List props = const []]) : super(props);
}

class InitialDistrictState extends DistrictState {
  @override
  String toString() => 'InitialDistrictState';
}

class LoadingDistrictState extends DistrictState {
  @override
  String toString() => 'LoadingDistrictState';
}

class LoadedDistrictState extends DistrictState {
  final List<District> districts;
  final List<District> oldDistricts;

  LoadedDistrictState({
    @required this.districts,
    this.oldDistricts,
  }) : super([
    districts,
    oldDistricts
  ]);

  @override
  String toString() => '''LoadedDistrictState {
      districts: $districts, 
    }''';
}

class FailureDistrictState extends DistrictState {
  final String error;
  FailureDistrictState({@required this.error}) : super([error]);

  @override
  String toString() => 'FailureDistrictState {error: $error}';
}
