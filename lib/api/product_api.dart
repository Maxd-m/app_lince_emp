// lib/api/product_api.dart

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Asegúrate de tener este paquete o cambia el acceso a tu .env
import 'package:get_storage/get_storage.dart';
import '../models/product_model.dart';

class ProductApi {
  // Inicializamos Dio con la configuración base obtiniéndola de tu .env
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['API_URL'] ?? 'http://localhost:8000/api',
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  static Future<List<Product>> fetchAllProducts() async {
    try {
      print(
        "Iniciando petición a: ${_dio.options.baseUrl}/productos",
      ); // <-- DEBUG 1
      final response = await _dio.get('/productos');

      print(
        "Respuesta recibida con status: ${response.statusCode}",
      ); // <-- DEBUG 2

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> productosJson = response.data['data'];
        // Guardamos en caché los datos crudos
        GetStorage().write('cached_products', productosJson);
        return productosJson.map((json) => Product.fromJson(json)).toList();
      }
      return [];
    } catch (e, stackTrace) {
      // Fallback: Si no hay internet, intentamos cargar del caché
      final cachedData = GetStorage().read('cached_products');
      if (cachedData != null) {
        print("Cargando productos desde el caché local...");
        return (cachedData as List)
            .map((json) => Product.fromJson(json))
            .toList();
      }

      // <-- CAMBIO AQUÍ: Agrega stackTrace
      print("--- ERROR EN FETCH ALL PRODUCTS ---");
      print("Mensaje de error: $e");
      print(
        "Ruta del error (StackTrace):\n$stackTrace",
      ); // <-- Esto te dirá la línea exacta
      print("-----------------------------------");
      return [];
    }
  }

  /// Realiza el fetch de un producto por su ID
  static Future<Product?> fetchProductById(String id) async {
    try {
      // Intentamos obtener el detalle directamente si tu backend soporta /productos/{id}
      final response = await _dio.get('/productos/$id');

      if (response.statusCode == 200 && response.data['success'] == true) {
        return Product.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      print(
        "Error en fetchProductById: $e. Aplicando fallback de filtrado local...",
      );
      // Fallback: Si el endpoint por ID no existe aún, traemos todos y filtramos en memoria
      final todos = await fetchAllProducts();
      try {
        return todos.firstWhere((p) => p.id == id);
      } catch (_) {
        return null;
      }
    }
  }

  /// Obtiene los productos registrados por el vendedor autenticado
  static Future<List<Product>> fetchMyProducts(String token) async {
    try {
      final response = await _dio.get(
        '/mis-productos',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> productosJson = response.data['data'];
        return productosJson.map((json) => Product.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print("Error en fetchMyProducts: $e");
      return [];
    }
  }
}
