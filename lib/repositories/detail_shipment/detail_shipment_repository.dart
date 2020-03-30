import 'dart:async';
import 'package:app_customer/repositories/detail_shipment/detail_shipment_api_client.dart';
import 'package:app_customer/repositories/storage/token_storage.dart';
import 'package:app_customer/utils/http_client.dart';

class DetailShipmentRepository {
  final DetailShipmentApiClient detailShipmentApiClient = DetailShipmentApiClient(httpClient: httpClient);
  final tokenStorage = TokenStorage();

  Future getDetailShipment(code) async {
    return await detailShipmentApiClient.getDetailShipment(code);
  }
}
