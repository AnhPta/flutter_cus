import 'package:app_customer/repositories/user/token.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  Future<void> storeToken(Token token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token_type', token.tokenType);
    prefs.setString('access_token', token.accessToken);
    prefs.setString('refresh_token', token.refreshToken);
    prefs.setInt('expires_in', token.expiresIn);
  }

  Future<Token> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String tokenType = (prefs.getString('token_type') ?? null);
    final String accessToken = (prefs.getString('access_token') ?? null);
    final String refreshToken = (prefs.getString('refresh_token') ?? null);
    final int expiresIn = (prefs.getInt('expires_in') ?? null);

    return Token(
        tokenType: tokenType,
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresIn: expiresIn);
  }

  Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token_type');
    prefs.remove('access_token');
    prefs.remove('refresh_token');
    prefs.remove('expires_in');
  }
}
