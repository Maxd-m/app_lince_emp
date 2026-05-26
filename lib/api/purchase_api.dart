// lib/api/purchase_api.dart

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart' hide Response;
import '../controllers/auth_controller.dart';
import '../models/purchase_model.dart';

class PurchaseApi {
  static final Dio _dio =
      Dio(
          BaseOptions(
            baseUrl: dotenv.env['API_URL'] ?? 'http://localhost:8000/api',
            connectTimeout: const Duration(seconds: 8),
            receiveTimeout: const Duration(seconds: 5),
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              final authController = Get.find<AuthController>();
              final token = authController.token.value;
              if (token != null) {
                options.headers['Authorization'] = 'Bearer $token';
              }
              return handler.next(options);
            },
          ),
        );

  static Future<List<Purchase>> fetchPurchases() async {
    try {
      final response = await _dio.get('/mis-compras');
      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Purchase.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print("Error al obtener compras: $e");
      return [];
    }
  }
}
