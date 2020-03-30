import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import 'package:app_customer/repositories/user/user_repository.dart';
import 'package:app_customer/bloc/authentication/bloc.dart';
import 'package:dio/dio.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
  })  : assert(userRepository != null),
        assert(authenticationBloc != null);

  @override
  LoginState get initialState => InitialLoginState();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is ProcessLoginEvent) {
      yield* _mapProcessLoginEventToState(event.username, event.password);
    }
  }

  Stream<LoginState> _mapProcessLoginEventToState(
      String username, String password) async* {
    try {
      yield LoadingLoginState();
      final token = await userRepository.authenticate(
        username: username,
        password: password,
      );
      authenticationBloc.dispatch(LoggedAuthenticationEvent(token: token));
      yield SuccessLoginState();
    } on DioError catch (e) {
      yield* handlerDioError(e);
    } catch (error) {
      yield FailureLoginState(error: error.toString());
    }
  }

  Stream<LoginState> handlerDioError (e) async* {
    try {
      Map response = {};
      Map errors = {};
      String errorMessage = "Không xác định";
      if (e.response == null) {
        yield FailureLoginState(error: 'Lỗi kết nối mạng hoặc hệ thống gặp sự cố');
      }
      if (e.response != null) {
        switch (e.response.statusCode) {
          case 401:
            yield FailureLoginState(error: 'Thông tin đăng nhập không chính xác');
            break;
          case 422:
            response = e.response.data;
            if (response.containsKey('data') && response['data'] is Map && response['data'].containsKey('errors')) {
              errors = response['data']['errors'];
              errorMessage = errors.values.first[0];
            } else {
              errorMessage = response['message'];
            }
            yield FailureLoginState(error: errorMessage);
            break;
          default:
            yield FailureLoginState(error: e.toString());
            break;
        }
      }
    } catch (error) {
      yield FailureLoginState(error: error.toString());
      return;
    }
  }
}
