import 'dart:async';
import 'dart:io';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:app_customer/repositories/source/source.dart';
import 'package:app_customer/utils/storage_helper.dart';
import 'package:app_customer/repositories/user/token.dart';

class SourceApiClient {
  final Dio httpClient;

  SourceApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<Source>> getSources() async {
    final url = '/erp/v1/exploit/sources';
    Token token = await StorageHelper.getCurrentToken();
    final response = await this.httpClient.get(url,
      queryParameters: {'limit': -1},
      options: Options(
        headers: {HttpHeaders.authorizationHeader: token.toString()}));
    List<Source> data = [];
    for (final source in response.data['data']) {
      data.add(Source.fromJson(source));
    }
    return data;
  }
}
