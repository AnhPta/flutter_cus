import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class LoginState extends Equatable {
  LoginState([List props = const []]) : super([props]);
}

class InitialLoginState extends LoginState {
  @override
  String toString() {
    return 'InitialLoginState';
  }
}

class LoadingLoginState extends LoginState {
  @override
  String toString() {
    return 'LoadingLoginState';
  }
}

class SuccessLoginState extends LoginState {
  @override
  String toString() {
    return 'SuccessLoginState';
  }
}

class FailureLoginState extends LoginState {
  final String error;
  FailureLoginState({@required this.error}) : super([error]);

  @override
  String toString() {
    return 'FailureLoginState {error: $error}';
  }
}
