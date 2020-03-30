import 'dart:async';
import 'package:app_customer/repositories/list_status/list_status.dart';
import 'package:app_customer/repositories/list_status/list_status_api_client.dart';
import 'package:app_customer/repositories/storage/token_storage.dart';
import 'package:app_customer/utils/http_client.dart';
import 'list_status_api_client.dart';

class ListStatusRepository {
  final ListStatusApiClient listStatusApiClient = ListStatusApiClient(httpClient: httpClient);
  final tokenStorage = TokenStorage();

  Future<List<ListStatus>> getListStatus() async {
    List<ListStatus> listStatus = await listStatusApiClient.getListStatus();
    return listStatus;
  }
}
