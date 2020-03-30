import 'dart:async';
import 'package:app_customer/repositories/contact_place/contact_place.dart';
import 'package:app_customer/repositories/storage/token_storage.dart';
import 'package:app_customer/utils/http_client.dart';
import 'contact_place_api_client.dart';

class ContactPlaceRepository {
  final ContactPlaceApiClient contactPlaceApiClient = ContactPlaceApiClient(httpClient: httpClient);
  final tokenStorage = TokenStorage();

  Future<Map> getContactPlace(params) async {
    Map response = await contactPlaceApiClient.getContactPlace(params);
    return response;
  }

  Future createContactPlace(ContactPlace contactPlace) async {
    return contactPlaceApiClient.createContactPlace(contactPlace);
  }

  Future updateContactPlace(ContactPlace contactPlace) async {
    return contactPlaceApiClient.updateContactPlace(contactPlace);
  }
}
