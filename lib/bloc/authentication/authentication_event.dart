import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:app_customer/repositories/user/token.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  AuthenticationEvent([List props = const []]) : super(props);
}

class StartAuthenticationEvent extends AuthenticationEvent {
  @override
  String toString() {
    return 'StartAuthenticationEvent';
  }
}

class LoggedAuthenticationEvent extends AuthenticationEvent {
  final Token token;
  LoggedAuthenticationEvent({@required this.token}) : super([token]);

  @override
  String toString() {
    return 'LoggedAuthenticationEvent {token: $token}';
  }
}

class LoggedOutAuthenticationEvent extends AuthenticationEvent {
  @override
  String toString() {
    return 'LoggedOutAuthenticationEvent';
  }
}
