import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import 'package:app_customer/repositories/user/user_repository.dart';
import 'package:app_customer/bloc/authentication/bloc.dart';
import 'package:dio/dio.dart';

class RegistryBloc extends Bloc<RegistryEvent, RegistryState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  RegistryBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
  })  : assert(userRepository != null),
        assert(authenticationBloc != null);

  @override
  RegistryState get initialState => InitialRegistryState();

  @override
  Stream<RegistryState> mapEventToState(
    RegistryEvent event,
  ) async* {
    if (event is ProcessRegistryEvent) {
      yield* _mapProcessRegistryEventToState(
          event.name, event.phone, event.password, event.passwordConfirm);
    }
  }

  Stream<RegistryState> _mapProcessRegistryEventToState(String phone,
      String name, String password, String passwordConfirm) async* {
    yield LoadingRegistryState();
    try {
      final token = await userRepository.registry(
        phone: phone,
        name: name,
        password: password,
        passwordConfirm: passwordConfirm,
      );
      authenticationBloc.dispatch(LoggedAuthenticationEvent(token: token));
      yield SuccessRegistryState();
    } on DioError catch (e) {
      yield* handlerDioError(e);
    } catch (error) {
      yield FailureRegistryState(error: error.toString());
    }
  }

  Stream<RegistryState> handlerDioError(e) async* {
    try {
      Map response = {};
      Map errors = {};
      String errorMessage = "Không xác định";
      if (e.response == null) {
        yield FailureRegistryState(
            error: 'Lỗi kết nối mạng hoặc hệ thống gặp sự cố');
      }
      if (e.response != null) {
        switch (e.response.statusCode) {
          case 401:
            yield FailureRegistryState(
                error: '401: Có lỗi xảy ra');
            break;
          case 404:
            yield FailureRegistryState(
              error: 'Tính năng đang hoàn thiện, vui lòng chờ phiên bản sau');
            break;
          case 422:
            response = e.response.data;
            if (response.containsKey('data') &&
                response['data'] is Map &&
                response['data'].containsKey('errors')) {
              errors = response['data']['errors'];
              errorMessage = errors.values.first[0];
            } else {
              errorMessage = response['message'];
            }
            yield FailureRegistryState(error: errorMessage);
            break;
          case 500:
            yield FailureRegistryState(
              error: 'Server gặp sự cố, vui lòng thử lại sau');
            break;
          default:
            yield FailureRegistryState(error: e.toString());
            break;
        }
      }
    } catch (error) {
      yield FailureRegistryState(error: error.toString());
      return;
    }
  }
}
