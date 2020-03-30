import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class LoginEvent extends Equatable {
  LoginEvent([List props = const []]) : super(props);
}

class ProcessLoginEvent extends LoginEvent {
  final String username;
  final String password;

  ProcessLoginEvent({
    @required this.username,
    @required this.password,
  }) : super([username, password]);

  @override
  String toString() {
    return '''ProcessLoginEvent {
      username: $username,
      password: $password
    }''';
  }
}
