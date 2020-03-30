import 'dart:async';
import 'package:app_customer/bloc/authentication/bloc.dart';
import 'package:app_customer/repositories/city/city_repository.dart';
import 'package:app_customer/utils/support_function.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import 'package:dio/dio.dart';

class CityBloc extends Bloc<CityEvent, CityState> {
  final CityRepository cityRepository;
  final AuthenticationBloc authenticationBloc;

  @override
  CityState get initialState => InitialCityState();
  CityBloc({
    @required this.cityRepository,
    @required this.authenticationBloc,
  }) : assert(cityRepository != null),
      assert(authenticationBloc != null);

  @override
  Stream<CityState> mapEventToState(
    CityEvent event,
    ) async* {
    if (event is FetchCityEvent) {
      yield* _mapFetchCityEventToState();
    }
    if (event is SearchCityEvent) {
      yield* _mapSearchCityEventToState(event);
    }
  }

  Stream<CityState> _mapSearchCityEventToState(SearchCityEvent event) async* {
    List cities = (currentState as LoadedCityState).oldCities;
    if (event.q == '') {
      cities = (currentState as LoadedCityState).oldCities;
    } else {
      cities = cities.where((item) {
      var name = SupportFunction.removeSignVietnamese(item.name).toLowerCase();
      var query = SupportFunction.removeSignVietnamese(event.q).toLowerCase();
      return name.indexOf(query) != -1;
      }).toList();
    }
    yield LoadedCityState(
      cities: cities,
      oldCities: (currentState as LoadedCityState).oldCities
    );
  }

  Stream<CityState> _mapFetchCityEventToState() async* {
    try {
      if (currentState is LoadedCityState && (currentState as LoadedCityState).cities.length > 0) {
//        yield LoadedCityState(
//          cities: (currentState as LoadedCityState).cities,
//          oldCities: (currentState as LoadedCityState).oldCities
//        );
//        return;
      }
      yield LoadingCityState();
      final cities = await cityRepository.getCities();
      yield LoadedCityState(cities: cities, oldCities: cities);
    } on DioError catch (e) {
      yield* handlerDioError(e);
    } catch (error) {
      yield FailureCityState(error: error.toString());
    }
  }

  Stream<CityState> handlerDioError (e) async* {
    Map response = {};
    Map errors = {};
    String errorMessage = "Không xác định";
    if (e.response == null) {
      yield FailureCityState(error: 'Lỗi kết nối mạng hoặc hệ thống gặp sự cố');
    }
    if (e.response != null) {
      switch (e.response.statusCode) {
        case 401:
          yield FailureCityState(error: 'Phiên làm việc của bạn đã hết hạn');
          authenticationBloc.dispatch(LoggedOutAuthenticationEvent());
          break;
        case 404:
          yield FailureCityState(
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
          yield FailureCityState(error: errorMessage);
          break;
        case 500:
          yield FailureCityState(
            error: 'Server gặp sự cố, vui lòng thử lại sau');
          break;
        default:
          yield FailureCityState(error: e.toString());
          break;
      }
    }
  }
}
