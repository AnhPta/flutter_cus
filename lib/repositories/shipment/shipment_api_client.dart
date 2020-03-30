import 'dart:async';
import 'dart:io';
import 'package:app_customer/repositories/pagination/pagination.dart';
import 'package:app_customer/repositories/shipment/shipment.dart';
import 'package:app_customer/utils/storage_helper.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:app_customer/repositories/user/token.dart';
import 'package:app_customer/repositories/shipment/rate.dart';
import 'package:app_customer/repositories/storage/token_storage.dart';

class ShipmentApiClient {
  final Dio httpClient;

  ShipmentApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<Rate>> getRate(rate) async {
    final url = '/erp/v1/rates/get-rate';
    TokenStorage tokenStorage = TokenStorage();
    Token token = await tokenStorage.getToken();
    final response = await this
      .httpClient
      .post(
      url,
      data: rate,
      options: Options(
        headers: {HttpHeaders.authorizationHeader: token.toString()})
    );
    List<Rate> data = [];
    for (final item in response.data['data']) {
      data.add(Rate.fromJson(item));
    }
    return data;
  }
  Future<Map> getShipment(params) async {
    final url = '/erp/v1/shipments';
    Token token = await StorageHelper.getCurrentToken();

    Map<String, dynamic> currentParams = {
//      "ignore_statuses[]": "draft"
      'include': 'packages'
    };

    Map<String, dynamic> queryParams = {}..addAll(params)..addAll(
      currentParams);

    final response = await this.httpClient.get(
      url,
      queryParameters: queryParams,
      options: Options(
        headers: {HttpHeaders.authorizationHeader: token.toString()}),
    );
    List<Shipment> data = [];
    for (final item in response.data['data']) {
      data.add(Shipment.fromJson(item));
    }
    Map result = Map();
    result['data'] = data;
    result['pagination'] =
      Pagination.fromJson(response.data['meta']['pagination']);
    return result;
  }

  Future applyPromotion(Map data) async {
    final url = '/erp/v1/promotions/apply';
    TokenStorage tokenStorage = TokenStorage();
    Token token = await tokenStorage.getToken();
    final response = await this
      .httpClient
      .post(
      url,
      data: data,
      options: Options(
        headers: {HttpHeaders.authorizationHeader: token.toString()})
    );
    return response;
  }

  Future createShipment(Shipment shipment) async {
    final url = '/erp/v1/shipments';
    Token token = await StorageHelper.getCurrentToken();

    final response = await this.httpClient.post(
      url,
      data: shipment.toJson(),
      options: Options(
        headers: {HttpHeaders.authorizationHeader: token.toString()},
      ),
    );
    return response.data['data'];
  }
  Future updateShipment(Shipment shipment) async {
    final url = '/erp/v1/shipments/${shipment.code}';
    Token token = await StorageHelper.getCurrentToken();

    final response = await this.httpClient.put(
      url,
      data: shipment.toJson(),
      options: Options(
        headers: {HttpHeaders.authorizationHeader: token.toString()},
      ),
    );
    return response.data['data'];
  }

  Future getSurcharge(cod, amount) async {
    final url = '/erp/v1/rates/surcharge';
    Token token = await StorageHelper.getCurrentToken();

    final response = await this.httpClient.post(
      url,
      data: {
        'cod': cod,
        'amount': amount
      },
      options: Options(
        headers: {HttpHeaders.authorizationHeader: token.toString()},
      ),
    );
    return response.data['data'];
  }

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

  Future deleteShipment(code) async {
    final url = '/erp/v1/shipments/$code';
    TokenStorage tokenStorage = TokenStorage();
    Token token = await tokenStorage.getToken();
    await this.httpClient.delete(url,
      options: Options(
        headers: {HttpHeaders.authorizationHeader: token.toString()}),
    );
  }

  Future sendRequestCancelShipment(code, reasonTxt, codeReason) async {
    final url = '/erp/v1/shipments/$code/cancel-ticket';
    TokenStorage tokenStorage = TokenStorage();
    Token token = await tokenStorage.getToken();
    await this.httpClient.delete(
      url,
      data: {
        'reason': codeReason,
        'other_reason': reasonTxt
      },
      options: Options(
        headers: {HttpHeaders.authorizationHeader: token.toString()}),
    );
  }

  Future sendShipment(code) async {
    final url = '/erp/v1/shipments/send/$code';
    TokenStorage tokenStorage = TokenStorage();
    Token token = await tokenStorage.getToken();
    final response = await this.httpClient.put(
      url,
      options: Options(
        headers: {HttpHeaders.authorizationHeader: token.toString()}),
    );
    return response.data['data'];
  }
}
