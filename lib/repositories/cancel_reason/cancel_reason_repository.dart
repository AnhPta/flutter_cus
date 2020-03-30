import 'dart:async';
import 'package:app_customer/repositories/cancel_reason/cancel_reason_api_client.dart';
import 'package:app_customer/repositories/storage/token_storage.dart';
import 'package:app_customer/utils/http_client.dart';

class CancelReasonRepository {
  final CancelReasonApiClient cancelReasonApiClient = CancelReasonApiClient(httpClient: httpClient);
  final tokenStorage = TokenStorage();

  Future getReason() async {
    return cancelReasonApiClient.getReason();
  }
}
