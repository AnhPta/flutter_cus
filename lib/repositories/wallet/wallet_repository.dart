import 'dart:async';
import 'package:app_customer/repositories/storage/token_storage.dart';
import 'package:app_customer/repositories/wallet/wallet.dart';
import 'package:app_customer/utils/http_client.dart';
import 'wallet_api_client.dart';

class WalletRepository {
  final WalletApiClient walletApiClient = WalletApiClient(httpClient: httpClient);
  final tokenStorage = TokenStorage();

  Future<List<Wallet>> getWallet() async {
    List<Wallet> wallet = await walletApiClient.getWallet();
    return wallet;
  }
}
