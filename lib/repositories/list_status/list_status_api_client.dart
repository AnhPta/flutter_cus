import 'dart:async';
import 'dart:io';
import 'package:app_customer/repositories/list_status/list_status.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:app_customer/repositories/user/token.dart';
import 'package:app_customer/repositories/storage/token_storage.dart';

class ListStatusApiClient {
  final Dio httpClient;

  ListStatusApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<ListStatus>> getListStatus() async {
    final url = '/erp/v1/shipments/status/get';
    TokenStorage tokenStorage = TokenStorage();
    Token token = await tokenStorage.getToken();
    final response = await this.httpClient.get(url,
      options: Options(
        headers: {HttpHeaders.authorizationHeader: token.toString()}),
    );
    List<ListStatus> data = [];
    for (final item in response.data['data']) {
      data.add(ListStatus.fromJson(item));
    }
    return data;
  }
}
