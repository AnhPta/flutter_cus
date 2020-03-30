import 'dart:async';
import 'package:app_customer/repositories/shipment/shipment.dart';
import 'package:app_customer/repositories/storage/token_storage.dart';
import 'package:app_customer/utils/http_client.dart';
import 'shipment_api_client.dart';
import 'package:app_customer/repositories/shipment/rate.dart';
import 'package:app_customer/repositories/shipment/shipment_api_client.dart';

class ShipmentRepository {
  final ShipmentApiClient shipmentApiClient = ShipmentApiClient(
    httpClient: httpClient);
  final tokenStorage = TokenStorage();

  Future<Map> getShipment(params) async {
    Map shipments = await shipmentApiClient.getShipment(params);
    return shipments;
  }

  Future<List<Rate>> getRate(rate) async {
    return shipmentApiClient.getRate(rate);
  }

  Future applyPromotion(data) async {
    return shipmentApiClient.applyPromotion(data);
  }

  Future createShipment(Shipment shipment) async {
    return shipmentApiClient.createShipment(shipment);
  }

  Future updateShipment(Shipment shipment) async {
    return shipmentApiClient.updateShipment(shipment);
  }

  Future getSurcharge(cod, amount) async {
    return shipmentApiClient.getSurcharge(cod, amount);
  }

  Future getConfig() async {
    return shipmentApiClient.getConfig();
  }

  Future deleteShipment(code) async {
    return await shipmentApiClient.deleteShipment(code);
  }

  Future sendRequestCancelShipment(code, reasonTxt, codeReason) async {
    return await shipmentApiClient.sendRequestCancelShipment(code, reasonTxt, codeReason);
  }

  Future sendShipment(code) async {
    return await shipmentApiClient.sendShipment(code);
  }
}
