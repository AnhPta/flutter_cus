import 'dart:async';
import 'package:app_customer/repositories/ward/ward.dart';
import 'package:app_customer/repositories/storage/token_storage.dart';
import 'package:app_customer/utils/http_client.dart';
import 'ward_api_client.dart';

class WardRepository {
  final WardApiClient wardApiClient = WardApiClient(httpClient: httpClient);
  final tokenStorage = TokenStorage();

  Future<List<Ward>> getWards(code) async {
    List<Ward> wards = await wardApiClient.getWards(code);
    return wards;
  }
}
