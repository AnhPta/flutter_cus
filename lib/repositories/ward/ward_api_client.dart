import 'dart:async';
import 'dart:io';
import 'package:app_customer/repositories/ward/ward.dart';
import 'package:app_customer/utils/storage_helper.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:app_customer/repositories/user/token.dart';

class WardApiClient {
  final Dio httpClient;

  WardApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<Ward>> getWards(code) async {
    final url = '/erp/v1/wards';
    Token token = await StorageHelper.getCurrentToken();

    final response = await this.httpClient.get(
      url,
      queryParameters: {'district_code': code, 'limit': -1},
      options: Options(
        headers: {HttpHeaders.authorizationHeader: token.toString()}),
    );
    List<Ward> data = [];
    for (final item in response.data['data']) {
      data.add(Ward.fromJson(item));
    }
    return data;
  }
}
