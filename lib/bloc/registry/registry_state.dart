import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';


@immutable
abstract class RegistryState extends Equatable {
  RegistryState([List props = const []]) : super([props]);
}

class InitialRegistryState extends RegistryState {
  @override
  String toString() {
    return 'InitialRegistryState';
  }
}

class LoadingRegistryState extends RegistryState {
  @override
  String toString() {
    return 'LoadingRegistryState';
  }
}

class SuccessRegistryState extends RegistryState {
  @override
  String toString() {
    return 'SuccessRegistryState';
  }
}

class FailureRegistryState extends RegistryState {
  final String error;
  FailureRegistryState({@required this.error}) : super([error]);

  @override
  String toString() {
    return 'FailureRegistryState {error: $error}';
  }
}
