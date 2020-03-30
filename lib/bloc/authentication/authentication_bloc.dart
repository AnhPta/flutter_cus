import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import 'package:app_customer/repositories/user/user_repository.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc({@required this.userRepository})
      : assert(userRepository != null);

  @override
  AuthenticationState get initialState => UninitializedAuthentication();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is StartAuthenticationEvent) {
      final bool hasToken = await userRepository.hasToken();

      if (hasToken) {
        yield AuthenticatedAuthentication();
      } else {
        yield UnauthenticatedAuthentication();
      }
    }

    if (event is LoggedAuthenticationEvent) {
      await userRepository.persistToken(event.token);
      yield AuthenticatedAuthentication();
    }

    if (event is LoggedOutAuthenticationEvent) {
      await userRepository.deleteToken();
      yield UnauthenticatedAuthentication();
    }
  }
}
