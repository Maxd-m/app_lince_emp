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

  /// Obtiene los métodos de pago disponibles
  static Future<List<dynamic>> fetchPaymentMethods() async {
    try {
      final response = await _dio.get('/metodos-pago');
      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data'];
      }
      return [];
    } catch (e) {
      print("Error al obtener métodos de pago: $e");
      return [];
    }
  }

  /// Realiza el pago de una venta
  static Future<bool> payPurchase(String id, int paymentMethodId) async {
    try {
      final response = await _dio.post(
        '/ventas/$id/pagar',
        data: {'id_metodo_de_pago': paymentMethodId},
      );
      return response.statusCode == 200 && response.data['success'] == true;
    } catch (e) {
      print("Error al pagar compra: $e");
      return false;
    }
  }

  /// Crea una nueva venta (checkout del carrito)
  static Future<bool> createPurchase({
    required String lugar,
    required String tipo,
    required List<Map<String, dynamic>> productos,
    int? id_metodo_de_pago,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'lugar': lugar,
        'tipo': tipo,
        'productos': productos,
      };
      if (id_metodo_de_pago != null)
        data['id_metodo_de_pago'] = id_metodo_de_pago;

      final response = await _dio.post('/ventas', data: data);
      return response.statusCode == 201 && response.data['success'] == true;
    } catch (e) {
      print("Error al crear venta: $e");
      return false;
    }
  }
}
