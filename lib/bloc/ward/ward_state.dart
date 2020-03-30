import 'package:app_customer/repositories/ward/ward.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class WardState extends Equatable {
  WardState([List props = const []]) : super(props);
}

class InitialWardState extends WardState {
  @override
  String toString() => 'InitialWardState';
}

class LoadingWardState extends WardState {
  @override
  String toString() => 'LoadingWardState';
}

class LoadedWardState extends WardState {
  final List<Ward> wards;
  final List<Ward> oldWards;
  LoadedWardState({
    @required this.wards,
    this.oldWards
  }) : super([
    wards,
    oldWards
  ]);

  @override
  String toString() => '''LoadedWardState {
      wards: $wards, 
    }''';

  factory LoadedWardState.empty() {
    return LoadedWardState(
      wards: [],
    );
  }
}

class FailureWardState extends WardState {
  final String error;
  FailureWardState({@required this.error}) : super([error]);

  @override
  String toString() => 'FailureWardState {error: $error}';
}
