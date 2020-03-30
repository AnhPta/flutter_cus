import 'dart:async';
import 'package:app_customer/repositories/city/city.dart';
import 'package:app_customer/repositories/storage/token_storage.dart';
import 'package:app_customer/utils/http_client.dart';
import 'city_api_client.dart';

class CityRepository {
  final CityApiClient cityApiClient = CityApiClient(httpClient: httpClient);
  final tokenStorage = TokenStorage();

  Future<List<City>> getCities() async {
    List<City> cities = await cityApiClient.getCities();
    return cities;
  }
}
