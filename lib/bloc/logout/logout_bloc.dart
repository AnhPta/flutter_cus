import 'dart:async';
import 'package:app_customer/bloc/navigation/bloc.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import 'package:app_customer/repositories/user/user_repository.dart';
import 'package:app_customer/bloc/authentication/bloc.dart';
import 'package:dio/dio.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;
  final NavigationBloc navigationBloc;

  LogoutBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
    @required this.navigationBloc,
  })  : assert(userRepository != null),
        assert(navigationBloc != null),
        assert(authenticationBloc != null);

  @override
  LogoutState get initialState => InitialLogoutState();

  @override
  Stream<LogoutState> mapEventToState(
    LogoutEvent event,
  ) async* {
    if (event is ProcessLogoutEvent) {
      yield LoadingLogoutState();
      try {
        await userRepository.logout();
        authenticationBloc.dispatch(LoggedOutAuthenticationEvent());
        navigationBloc.dispatch(ChangeIndexPageEvent(index: 0));
        yield InitialLogoutState();
      } on DioError catch (e) {
        print(e.toString());
      } catch (error) {
        yield FailureLogoutState(error: error.toString());
      }
    }
  }
}
