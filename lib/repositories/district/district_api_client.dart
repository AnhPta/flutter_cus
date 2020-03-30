import 'dart:async';
import 'dart:io';
import 'package:app_customer/repositories/district/district.dart';
import 'package:app_customer/utils/storage_helper.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:app_customer/repositories/user/token.dart';

class DistrictApiClient {
  final Dio httpClient;

  DistrictApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<District>> getDistricts(code) async {
    final url = '/erp/v1/districts';
    Token token = await StorageHelper.getCurrentToken();

    final response = await this.httpClient.get(
      url,
      queryParameters: {'city_code': code, 'limit': -1},
      options: Options(
        headers: {HttpHeaders.authorizationHeader: token.toString()}),
    );
    List<District> data = [];
    for (final item in response.data['data']) {
      data.add(District.fromJson(item));
    }
    return data;
  }
}
