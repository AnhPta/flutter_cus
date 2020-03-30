import 'dart:async';
import 'dart:io';
import 'package:app_customer/repositories/wallet/wallet.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:app_customer/repositories/user/token.dart';
import 'package:app_customer/repositories/storage/token_storage.dart';

class WalletApiClient {
  final Dio httpClient;

  WalletApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<Wallet>> getWallet() async {
    final url = '/id/profile/wallets/get/balance';
    TokenStorage tokenStorage = TokenStorage();
    Token token = await tokenStorage.getToken();
    final response = await this.httpClient.get(url,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: token.toString()}),
        queryParameters: {'type': 1});
    List<Wallet> data = [];
    for (final item in response.data['data']) {
      data.add(Wallet.fromJson(item));
    }
    return data;
  }
}
