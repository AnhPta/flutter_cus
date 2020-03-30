import 'package:equatable/equatable.dart';

class Token extends Equatable {
  final String tokenType;
  final int expiresIn;
  final String accessToken;
  final String refreshToken;

  Token({this.tokenType, this.expiresIn, this.accessToken, this.refreshToken})
      : super([tokenType, expiresIn, accessToken, refreshToken]);

  static Token fromJson(dynamic json) {
    return Token(
        tokenType: json['token_type'],
        expiresIn: json['expires_in'],
        accessToken: json['access_token'],
        refreshToken: json['refresh_token']);
  }

  bool isValid() {
    return tokenType != null && accessToken != null;
  }

  @override
  String toString() => '$tokenType $accessToken';
}
