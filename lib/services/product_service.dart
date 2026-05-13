import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tugas_pbm_2026/models/product_model.dart';
import 'package:tugas_pbm_2026/core/constants/app_constants.dart';

class ProductService {

  Future<List<Product>> getProducts() async {

    final prefs =
        await SharedPreferences.getInstance();

    final token =
        prefs.getString(AppConstants.tokenKey);

    final url = Uri.https(
      AppConstants.baseUrl,
      AppConstants.productsEndpoint,
    );

    try {

      final response = await http
          .get(
            url,

            headers: {
              'Authorization':
                  'Bearer $token',

              'Accept':
                  'application/json',
            },
          )
          .timeout(
            const Duration(seconds: 10),
          );

      if (response.statusCode == 200) {

        final responseData =
            jsonDecode(response.body);

        final List<dynamic> productsData =
            responseData['data']['products'];

        return productsData
            .map(
              (json) =>
                  Product.fromJson(json),
            )
            .toList();
      }

      return [];

    } catch (e) {
      print('Get Products Error: $e');
      return [];
    }
  }

  Future<bool> saveProduct(
    Product product,
  ) async {

    final prefs =
        await SharedPreferences.getInstance();

    final token =
        prefs.getString(AppConstants.tokenKey);

    final url = Uri.https(
      AppConstants.baseUrl,
      AppConstants.productsEndpoint,
    );

    try {

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

            body: jsonEncode(
              product.toJson(),
            ),
          )
          .timeout(
            const Duration(seconds: 10),
          );

      return response.statusCode == 200 ||
          response.statusCode == 201;

    } catch (e) {
      print('Save Product Error: $e');
      return false;
    }
  }

  Future<bool> deleteProduct(int id) async {

    final prefs =
        await SharedPreferences.getInstance();

    final token =
        prefs.getString(AppConstants.tokenKey);

    final url = Uri.https(
      AppConstants.baseUrl,
      '${AppConstants.productsEndpoint}/$id',
    );

    try {

      final response = await http
          .delete(
            url,

            headers: {
              'Authorization':
                  'Bearer $token',

              'Accept':
                  'application/json',
            },
          )
          .timeout(
            const Duration(seconds: 10),
          );

      return response.statusCode == 200 ||
          response.statusCode == 204;

    } catch (e) {
      print('Delete Product Error: $e');
      return false;
    }
  }
}