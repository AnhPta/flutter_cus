import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class LogoutState extends Equatable {
  LogoutState([List props = const []]) : super(props);
}

class InitialLogoutState extends LogoutState {
  @override
  String toString() {
    return 'InitialLogoutState';
  }
}

class LoadingLogoutState extends LogoutState {
  @override
  String toString() {
    return 'LoadingLogoutState';
  }
}

class FailureLogoutState extends LogoutState {
  final String error;
  FailureLogoutState({@required this.error}) : super([error]);

  @override
  String toString() {
    return 'FailureLogoutState {error: $error}';
  }
}
