import 'dart:async';
import 'dart:io';
import 'package:app_customer/utils/storage_helper.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:app_customer/repositories/user/token.dart';

class ConfigApiClient {
  final Dio httpClient;

  ConfigApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future getConfig() async {
    final url = '/erp/v1/rates/get_config';
    Token token = await StorageHelper.getCurrentToken();

    final response = await this.httpClient.post(
      url,
      options: Options(
        headers: {HttpHeaders.authorizationHeader: token.toString()},
      ),
    );
    return response.data['data'];
  }
}
