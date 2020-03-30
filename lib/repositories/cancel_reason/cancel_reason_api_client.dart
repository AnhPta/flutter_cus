import 'dart:async';
import 'dart:io';
import 'package:app_customer/repositories/cancel_reason/cancel_reason.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:app_customer/repositories/user/token.dart';
import 'package:app_customer/repositories/storage/token_storage.dart';

class CancelReasonApiClient {
  final Dio httpClient;

  CancelReasonApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<Reason>> getReason() async {
    final url = '/erp/v1/shipments/cancel-reason/get';
    TokenStorage tokenStorage = TokenStorage();
    Token token = await tokenStorage.getToken();
    final response = await this.httpClient.get(
      url,
      options: Options(
        headers: {HttpHeaders.authorizationHeader: token.toString()}),
    );
    List<Reason> data = [];
    for (final item in response.data['data']) {
      data.add(Reason.fromJson(item));
    }
    return data;
  }
}
