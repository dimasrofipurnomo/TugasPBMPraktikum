import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_pbm_2026/core/constants/app_constants.dart';

class AuthService {

  Future<String?> login(
    String username,
    String password,
  ) async {

    final url = Uri.https(
      AppConstants.baseUrl,
      AppConstants.loginEndpoint,
    );

    try {

      final response = await http
          .post(
            url,

            headers: {
              'Content-Type':
                  'application/json',

              'Accept':
                  'application/json',
            },

            body: jsonEncode({
              'username': username,
              'password': password,
            }),
          )
          .timeout(
            const Duration(seconds: 10),
          );

      print('--- Login Debug ---');
      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {

        final responseData =
            jsonDecode(response.body);

        String? token;

        if (responseData['data'] != null) {
          token =
              responseData['data']['token'];
        } else {
          token =
              responseData['token'];
        }

        if (token != null) {

          final prefs =
              await SharedPreferences
                  .getInstance();

          await prefs.setString(
            AppConstants.tokenKey,
            token,
          );

          String? fullName;

          if (responseData['data']['user']
              != null) {
            fullName =
                responseData['data']['user']
                    ['name'];
          }

          await prefs.setString(
            AppConstants.usernameKey,
            fullName ?? username,
          );

          return token;
        }
      }

      return null;

    } catch (e) {
      print('Login Error: $e');
      return null;
    }
  }

  Future<void> logout() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(
      AppConstants.tokenKey,
    );
  }

  Future<String?> getToken() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(
      AppConstants.tokenKey,
    );
  }
}