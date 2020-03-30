import 'dart:async';
import 'dart:io';
import 'package:app_customer/repositories/contact_place/contact_place.dart';
import 'package:app_customer/repositories/pagination/pagination.dart';
import 'package:app_customer/utils/storage_helper.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:app_customer/repositories/user/token.dart';

class ContactPlaceApiClient {
  final Dio httpClient;

  ContactPlaceApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<Map> getContactPlace(params) async {
    final url = '/erp/v1/contact-places';
    Token token = await StorageHelper.getCurrentToken();

    Map<String, dynamic> currentParams = {
      'sort': 'is_main:desc'
    };

    Map<String, dynamic> queryParams = {}..addAll(params)..addAll(currentParams);

    final response = await this.httpClient.get(
      url,
      queryParameters: queryParams,
      options: Options(
        headers: {HttpHeaders.authorizationHeader: token.toString()}));
    List<ContactPlace> data = [];
    for (final item in response.data['data']) {
      data.add(ContactPlace.fromJson(item));
    }
    Map result = Map();
    result['data'] = data;
    result['pagination'] = Pagination.fromJson(response.data['meta']['pagination']);
    return result;
  }

  Future createContactPlace(ContactPlace contactPlace) async {
    final url = '/erp/v1/contact-places';
    Token token = await StorageHelper.getCurrentToken();

    final response = await this
      .httpClient
      .post(
      url,
      data: contactPlace.toJson(),
      options: Options(
        headers: {HttpHeaders.authorizationHeader: token.toString()},
      ),
    );
    return response.data['data'];
  }
  Future updateContactPlace(ContactPlace contactPlace) async {
    final url = '/erp/v1/contact-places/${contactPlace.id}';
    Token token = await StorageHelper.getCurrentToken();

    final response = await this
      .httpClient
      .put(
      url,
      data: contactPlace.toJson(),
      options: Options(
        headers: {HttpHeaders.authorizationHeader: token.toString()},
      ),
    );
    return response.data['data'];
  }
}
