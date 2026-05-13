import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tugas_pbm_2026/models/product_model.dart';
import 'package:tugas_pbm_2026/core/constants/app_constants.dart';

class SubmitService {

  Future<bool> submitTask(
    Product product,
    String githubUrl,
  ) async {

    final prefs =
        await SharedPreferences.getInstance();

    final token =
        prefs.getString(AppConstants.tokenKey);

    final url = Uri.https(
      AppConstants.baseUrl,
      AppConstants.submitEndpoint,
    );

    try {

      final body = product.toJson();

      body['github_url'] = githubUrl;

      final response = await http
          .post(
            url,

            headers: {
              'Authorization':
                  'Bearer $token',

              'Content-Type':
                  'application/json',

              'Accept':
                  'application/json',
            },

            body: jsonEncode(body),
          )
          .timeout(
            const Duration(seconds: 10),
          );

      return response.statusCode == 200 ||
          response.statusCode == 201;

    } catch (e) {
      print('Submit Task Error: $e');
      return false;
    }
  }
}