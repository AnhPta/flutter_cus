import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationState {}

class UninitializedAuthentication extends AuthenticationState {
  @override
  String toString() {
    return 'UninitializedAuthentication';
  }
}

class AuthenticatedAuthentication extends AuthenticationState {
  @override
  String toString() {
    return 'AuthenticatedAuthentication';
  }
}

class UnauthenticatedAuthentication extends AuthenticationState {
  @override
  String toString() {
    return 'UnauthenticatedAuthentication';
  }
}

class LoadingAuthentication extends AuthenticationState {
  @override
  String toString() {
    return 'LoadingAuthentication';
  }
}
