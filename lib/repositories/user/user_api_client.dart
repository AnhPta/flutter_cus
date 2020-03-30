import 'dart:async';
import 'dart:io';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:dio/dio.dart';
import 'package:app_customer/repositories/user/token.dart';
import 'package:app_customer/repositories/user/user.dart';
import 'package:app_customer/repositories/storage/token_storage.dart';

class UserApiClient {
  final Dio httpClient;

  UserApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<Token> registry(String name, String phone, String password, String passwordConfirm) async {
    final url = '/registry';
    final response = await this
        .httpClient
        .post(url, data: {"name": name,  "phone": phone, "password": password,  "passwordConfirm": passwordConfirm});
    return Token.fromJson(response.data);
  }

  Future<Token> login(String username, String password) async {
    final url = '/login';
    final response = await this
        .httpClient
        .post(url, data: {"username": username, "password": password});
    return Token.fromJson(response.data);
  }

  Future<void> logout() async {
    TokenStorage tokenStorage = TokenStorage();
    Token token = await tokenStorage.getToken();
    final url = '/logout';
    await this.httpClient.post(url,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: token.toString()}));
  }

  Future<User> getProfile() async {
    final url = '/id/profile';
    TokenStorage tokenStorage = TokenStorage();
    Token token = await tokenStorage.getToken();
    final response = await this.httpClient.get(url,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: token.toString()}));
    return User.fromJson(response.data['data']);
  }
  Future changePass(String oldPass, String newPass, String confirmPass) async {
    final url = '/id/change-password';
    TokenStorage tokenStorage = TokenStorage();
    Token token = await tokenStorage.getToken();
    final response = await this
      .httpClient
      .post(url, data: {"old_password": oldPass, "password": newPass, "password_confirmation": confirmPass},
      options: Options(
        headers: {HttpHeaders.authorizationHeader: token.toString()})
    );
    return response.data;
  }
  Future changeAvatar(File file) async {
    final url = '/id/upload/avatar';
    TokenStorage tokenStorage = TokenStorage();
    Token token = await tokenStorage.getToken();
    FormData formData = new FormData.from({
      "file": new UploadFileInfo(file, basename(file.path))
    });
    print(UploadFileInfo(file, basename(file.path)));
    final response = await this
      .httpClient
      .post(url, data: formData,
      options: Options(
        headers: {HttpHeaders.authorizationHeader: token.toString(), 'Content-Type': 'multipart/form-data'})
    );
    return response.data['data'];
  }
  Future updateProfile(User user) async {
    final url = '/id/profile';
    TokenStorage tokenStorage = TokenStorage();
    Token token = await tokenStorage.getToken();

    final response = await this
      .httpClient
      .put(url, data: user.toJson(),
      options: Options(
        headers: {HttpHeaders.authorizationHeader: token.toString()})
    );
    return response.data['data'];
  }
  Future changeProfile(String name, String phone, String birthday, String email, String address) async {
    final url = '/id/profile';
    TokenStorage tokenStorage = TokenStorage();
    Token token = await tokenStorage.getToken();

    final response = await this
      .httpClient
      .put(url, data: {"name": name, "phone": phone, "birthday": birthday, "email": email, "address": address},
      options: Options(
        headers: {HttpHeaders.authorizationHeader: token.toString()})
    );
    return response.data['data'];
  }
}
