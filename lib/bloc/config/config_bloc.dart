import 'dart:async';
import 'package:app_customer/repositories/config/config_repository.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import 'package:dio/dio.dart';
import 'package:app_customer/bloc/authentication/bloc.dart';

class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
  final ConfigRepository configRepository;
  final AuthenticationBloc authenticationBloc;

  @override
  ConfigState get initialState => InitialConfigState();
  ConfigBloc({
    @required this.configRepository,
    @required this.authenticationBloc,
  })  : assert(configRepository != null),
        assert(authenticationBloc != null);

  @override
  Stream<ConfigState> mapEventToState(
      ConfigEvent event,
      ) async* {
    if (event is FetchConfigEvent) {
      yield* _mapFetchConfigEventToState();
    }
  }

  Stream<ConfigState> _mapFetchConfigEventToState() async* {
    try {
      final response = await configRepository.getConfig();
      yield LoadedConfigState(config: response[0]['convert_weight']);
    } on DioError catch (e) {
      yield* processDioError(e);
    } catch (error) {
      yield FailureConfigState(error: error.toString());
    }
  }

  Stream<ConfigState> processDioError (e) async* {
    Map response = {};
    Map errors = {};
    String errorMessage = "Không xác định";
    if (e.response == null) {
      yield FailureConfigState(error: 'Lỗi kết nối mạng hoặc hệ thống gặp sự cố');
    }
    if (e.response != null) {
      switch (e.response.statusCode) {
        case 401:
          yield FailureConfigState(error: 'Phiên làm việc của bạn đã hết hạn');
          authenticationBloc.dispatch(LoggedOutAuthenticationEvent());
          break;
        case 403:
          yield FailureConfigState(error: 'Bạn không có quyền thực hiện chức năng này');
          break;
        case 404:
          yield FailureConfigState(
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
          yield FailureConfigState(error: errorMessage);
          break;
        case 500:
          yield FailureConfigState(
            error: 'Server gặp sự cố, vui lòng thử lại sau');
          break;
        default:
          yield FailureConfigState(error: e.toString());
          break;
      }
    }
  }
}
