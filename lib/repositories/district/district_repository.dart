import 'dart:async';
import 'package:app_customer/repositories/district/district.dart';
import 'package:app_customer/repositories/storage/token_storage.dart';
import 'package:app_customer/utils/http_client.dart';
import 'district_api_client.dart';

class DistrictRepository {
  final DistrictApiClient districtApiClient = DistrictApiClient(httpClient: httpClient);
  final tokenStorage = TokenStorage();

  Future<List<District>> getDistricts(code) async {
    List<District> districts = await districtApiClient.getDistricts(code);
    return districts;
  }
}
