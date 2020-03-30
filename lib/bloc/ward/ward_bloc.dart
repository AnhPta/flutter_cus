import 'dart:async';
import 'package:app_customer/bloc/authentication/bloc.dart';
import 'package:app_customer/repositories/ward/ward_repository.dart';
import 'package:app_customer/utils/support_function.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import 'package:dio/dio.dart';


class WardBloc extends Bloc<WardEvent, WardState> {
  final WardRepository wardRepository;
  final AuthenticationBloc authenticationBloc;

  @override
  WardState get initialState => InitialWardState();
  WardBloc({
    @required this.wardRepository,
    @required this.authenticationBloc,
  })  : assert(wardRepository != null),
      assert(authenticationBloc != null);

  @override
  Stream<WardState> mapEventToState(
    WardEvent event,
    ) async* {
    if (event is FetchWardEvent) {
      yield* _mapFetchWardEventToState(event);
    }
    if (event is SearchWardEvent) {
      yield* _mapSearchWardEventToState(event);
    }
  }

  Stream<WardState> _mapSearchWardEventToState(SearchWardEvent event) async* {
    List wards = (currentState as LoadedWardState).oldWards;
    if (event.q == '') {
      wards = (currentState as LoadedWardState).oldWards;
    } else {
      wards = wards.where((item) {
        var name = SupportFunction.removeSignVietnamese(item.name).toLowerCase();
        var query = SupportFunction.removeSignVietnamese(event.q).toLowerCase();
        return name.indexOf(query) != -1;
      }).toList();
    }
    yield LoadedWardState(
      wards: wards,
      oldWards: (currentState as LoadedWardState).oldWards
    );
  }

  Stream<WardState> _mapFetchWardEventToState(FetchWardEvent event) async* {
//    yield LoadingWardState();
    try {
      if (currentState is LoadedWardState && (currentState as LoadedWardState).wards.length > 0) {
        yield LoadedWardState(wards: (currentState as LoadedWardState).wards);
//        return;
      }
      final wards = await wardRepository.getWards(event.selectedDistrictCode);
      yield LoadedWardState(wards: wards, oldWards: wards);
    } on DioError catch (e) {
      yield* handlerDioError(e);
    } catch (error) {
      yield FailureWardState(error: error.toString());
    }
  }

  Stream<WardState> handlerDioError (e) async* {
    Map response = {};
    Map errors = {};
    String errorMessage = "Không xác định";
    if (e.response == null) {
      yield FailureWardState(error: 'Lỗi kết nối mạng hoặc hệ thống gặp sự cố');
    }
    if (e.response != null) {
      switch (e.response.statusCode) {
        case 401:
          yield FailureWardState(error: 'Phiên làm việc của bạn đã hết hạn');
          authenticationBloc.dispatch(LoggedOutAuthenticationEvent());
          break;
        case 404:
          yield FailureWardState(
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
          yield FailureWardState(error: errorMessage);
          break;
        case 500:
          yield FailureWardState(
            error: 'Server gặp sự cố, vui lòng thử lại sau');
          break;
        default:
          yield FailureWardState(error: e.toString());
          break;
      }
    }
  }
}
