import 'dart:async';
import 'dart:io';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:app_customer/repositories/user/token.dart';
import 'package:app_customer/repositories/storage/token_storage.dart';

class DetailShipmentApiClient {
  final Dio httpClient;

  DetailShipmentApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future getDetailShipment(code) async {
    final url = '/erp/v1/shipments/$code';
    TokenStorage tokenStorage = TokenStorage();
    Token token = await tokenStorage.getToken();
    final response = await this.httpClient.get(url,
      options: Options(
        headers: {HttpHeaders.authorizationHeader: token.toString()}),
      queryParameters: {'include': 'statuses,packages'},
    );
    return response;
  }
}
