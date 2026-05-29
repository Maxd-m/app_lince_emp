// lib/api/venta_api.dart

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart' hide Response;
import '../controllers/auth_controller.dart';

class VentaApi {
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

  static Future<List<dynamic>> fetchVentas() async {
    try {
      final response = await _dio.get('/mis-ventas');
      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data'];
      }
      return [];
    } catch (e) {
      print("Error al obtener ventas: $e");
      return [];
    }
  }

  static Future<bool> completarVenta(int id) async {
    try {
      final response = await _dio.put('/ventas/$id/completar');
      return response.statusCode == 200 && response.data['success'] == true;
    } on DioException catch (e) {
      // Esto te permitirá ver el mensaje exacto que envía el backend en el body
      print("Error 403 - Detalles del backend: ${e.response?.data}");
      print("Mensaje de error: ${e.message}");
      return false;
    } catch (e) {
      print("Error inesperado: $e");
      return false;
    }
  }
}
