import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ReviewApi {
  static final Dio _dio = Dio();
  static final String _baseUrl =
      dotenv.env['API_URL'] ?? 'http://localhost:8000/api';

  static Options _options(String token) =>
      Options(headers: {'Authorization': 'Bearer $token'});

  /// Obtiene las compras del usuario para saber qué puede reseñar
  static Future<List<dynamic>> fetchMyPurchases(String token) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/mis-compras',
        options: _options(token),
      );
      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data'] ?? [];
      }
      return [];
    } catch (e) {
      print("Error en fetchMyPurchases: $e");
      return [];
    }
  }

  /// Obtiene las reseñas que el usuario ha hecho a productos
  static Future<List<dynamic>> fetchMyProductReviews(String token) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/mis-reviews/productos',
        options: _options(token),
      );
      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data'] ?? [];
      }
      return [];
    } catch (e) {
      print("Error en fetchMyProductReviews: $e");
      return [];
    }
  }

  /// Obtiene las reseñas que el usuario ha hecho a vendedores
  static Future<List<dynamic>> fetchMyVendorReviews(String token) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/mis-reviews/vendedores',
        options: _options(token),
      );
      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data'] ?? [];
      }
      return [];
    } catch (e) {
      print("Error en fetchMyVendorReviews: $e");
      return [];
    }
  }

  /// Crea una reseña de producto
  static Future<bool> createProductReview({
    required String token,
    required int productId,
    required double rating,
    required String comment,
    required bool anonymous,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/reviews/productos',
        options: _options(token),
        data: {
          "id_producto": productId,
          "calificacion": rating,
          "comentario": comment,
          "anonimo": anonymous,
        },
      );
      return response.statusCode == 201 ||
          (response.data != null && response.data['success'] == true);
    } catch (e) {
      print("Error en createProductReview: $e");
      return false;
    }
  }

  /// Crea una reseña de vendedor
  static Future<bool> createVendorReview({
    required String token,
    required int vendorId,
    required double rating,
    required String comment,
    required bool anonymous,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/reviews/vendedores',
        options: _options(token),
        data: {
          "id_vendedor": vendorId,
          "calificacion": rating,
          "comentario": comment,
          "anonimo": anonymous,
        },
      );
      return response.statusCode == 201 ||
          (response.data != null && response.data['success'] == true);
    } catch (e) {
      print("Error en createVendorReview: $e");
      return false;
    }
  }
}
