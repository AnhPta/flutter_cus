import 'dart:async';
import 'package:meta/meta.dart';
import 'package:app_customer/repositories/user/user_api_client.dart';
import 'package:app_customer/repositories/user/token.dart';
import 'package:app_customer/repositories/user/user.dart';
import 'package:app_customer/repositories/storage/token_storage.dart';
import 'package:app_customer/utils/http_client.dart';

class UserRepository {
  final UserApiClient userApiClient = UserApiClient(httpClient: httpClient);
  final tokenStorage = TokenStorage();

  Future<Token> authenticate({
    @required String username,
    @required String password,
  }) async {
    return userApiClient.login(username, password);
  }

  Future<Token> registry({
    @required String name,
    @required String phone,
    @required String password,
    @required String passwordConfirm,
  }) async {
    return userApiClient.registry(name, phone, password, passwordConfirm);
  }

  Future<void> logout() async {
    userApiClient.logout();
  }

  Future<void> deleteToken() async {
    await tokenStorage.removeToken();
  }

  Future<void> persistToken(Token token) async {
    tokenStorage.storeToken(token);
  }

  Future<bool> hasToken() async {
    Token token = await tokenStorage.getToken();
    return token.isValid();
  }

  Future<User> getProfile() async {
    User profile = await userApiClient.getProfile();
    return profile;
  }
  Future changePass(oldPass, newPass, confirmPass) async {
    Map response = await userApiClient.changePass(oldPass, newPass, confirmPass);
    return response;
  }
  Future changeAvatar(file) async {
    Map response = await userApiClient.changeAvatar(file);
    return response;
  }
  Future updateProfile(user) async {
    Map response = await userApiClient.updateProfile(user);
    return response;
  }
  Future changeProfile(name, phone, birthday, email, address) async {
    Map response = await userApiClient.changeProfile(name, phone, birthday, email, address);
    return response;
  }
}
