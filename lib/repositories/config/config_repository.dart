import 'dart:async';
import 'package:app_customer/repositories/storage/token_storage.dart';
import 'package:app_customer/utils/http_client.dart';
import 'config_api_client.dart';

class ConfigRepository {
  final ConfigApiClient configApiClient = ConfigApiClient(httpClient: httpClient);
  final tokenStorage = TokenStorage();

  Future getConfig() async {
    return configApiClient.getConfig();
  }
}
