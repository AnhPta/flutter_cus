import 'dart:async';
import 'package:app_customer/repositories/storage/token_storage.dart';
import 'package:app_customer/repositories/user/token.dart';

class StorageHelper {
  static Future<Token> getCurrentToken () async {
    TokenStorage tokenStorage = TokenStorage();
    Token token = await tokenStorage.getToken();
    return token;
  }
}
