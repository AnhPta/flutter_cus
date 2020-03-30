import 'dart:async';
import 'package:app_customer/bloc/authentication/bloc.dart';
import 'package:app_customer/repositories/district/district_repository.dart';
import 'package:app_customer/utils/support_function.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import 'package:dio/dio.dart';


class DistrictBloc extends Bloc<DistrictEvent, DistrictState> {
  final DistrictRepository districtRepository;
  final AuthenticationBloc authenticationBloc;

  @override
  DistrictState get initialState => InitialDistrictState();
  DistrictBloc({
    @required this.districtRepository,
    @required this.authenticationBloc,
  })  : assert(districtRepository != null),
      assert(authenticationBloc != null);

  @override
  Stream<DistrictState> mapEventToState(
    DistrictEvent event,
    ) async* {
    if (event is FetchDistrictEvent) {
      yield* _mapFetchDistrictEventToState(event);
    }
    if (event is SearchDistrictEvent) {
      yield* _mapSearchDistrictEventToState(event);
    }
  }

  Stream<DistrictState> _mapSearchDistrictEventToState(SearchDistrictEvent event) async* {
    List districts = (currentState as LoadedDistrictState).oldDistricts;
    if (event.q == '') {
      districts = (currentState as LoadedDistrictState).oldDistricts;
    } else {
      districts = districts.where((item) {
        var name = SupportFunction.removeSignVietnamese(item.name).toLowerCase();
        var query = SupportFunction.removeSignVietnamese(event.q).toLowerCase();
        return name.indexOf(query) != -1;
      }).toList();
    }
    yield LoadedDistrictState(
      districts: districts,
      oldDistricts: (currentState as LoadedDistrictState).oldDistricts
    );
  }

  Stream<DistrictState> _mapFetchDistrictEventToState(FetchDistrictEvent event) async* {
    try {
      yield LoadingDistrictState();
      final districts = await districtRepository.getDistricts(event.selectedCityCode);
      yield LoadedDistrictState(districts: districts, oldDistricts: districts);
    } on DioError catch (e) {
      yield* handlerDioError(e);
    } catch (error) {
      yield FailureDistrictState(error: error.toString());
    }
  }

  Stream<DistrictState> handlerDioError (e) async* {
    Map response = {};
    Map errors = {};
    String errorMessage = "Không xác định";
    if (e.response == null) {
      yield FailureDistrictState(error: 'Lỗi kết nối mạng hoặc hệ thống gặp sự cố');
    }
    if (e.response != null) {
      switch (e.response.statusCode) {
        case 401:
          yield FailureDistrictState(error: 'Phiên làm việc của bạn đã hết hạn');
          authenticationBloc.dispatch(LoggedOutAuthenticationEvent());
          break;
        case 404:
          yield FailureDistrictState(
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
          yield FailureDistrictState(error: errorMessage);
          break;
        case 500:
          yield FailureDistrictState(
            error: 'Server gặp sự cố, vui lòng thử lại sau');
          break;
        default:
          yield FailureDistrictState(error: e.toString());
          break;
      }
    }
  }
}
