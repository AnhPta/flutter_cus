import 'dart:async';
import 'package:app_customer/repositories/source/source.dart';
import 'package:app_customer/repositories/storage/token_storage.dart';
import 'package:app_customer/repositories/source/source_api_client.dart';
import 'package:app_customer/utils/http_client.dart';

class SourceRepository {
  final SourceApiClient sourceApiClient =
  SourceApiClient(httpClient: httpClient);
  final tokenStorage = TokenStorage();

  Future<List<Source>> getSources() async {
    List<Source> sources =
    await sourceApiClient.getSources();
    return sources;
  }
}
