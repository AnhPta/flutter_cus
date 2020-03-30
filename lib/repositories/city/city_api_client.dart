import 'dart:async';
import 'dart:io';
import 'package:app_customer/repositories/city/city.dart';
import 'package:app_customer/utils/storage_helper.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:app_customer/repositories/user/token.dart';

class CityApiClient {
  final Dio httpClient;

  CityApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<City>> getCities() async {
    final url = '/erp/v1/cities';
    Token token = await StorageHelper.getCurrentToken();

    final response = await this.httpClient.get(
      url,
      queryParameters: {'limit': 63},
      options: Options(
        headers: {HttpHeaders.authorizationHeader: token.toString()})
    );
    List<City> data = [];
    for (final item in response.data['data']) {
      data.add(City.fromJson(item));
    }
    return data;
  }
}
