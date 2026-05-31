// lib/api/vendor_api.dart

import 'package:dio/dio.dart';
import '../models/vendor_model.dart';
import '../models/product_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Asegúrate de tener este paquete o cambia el acceso a tu .env

class VendorApi {
  // Asegúrate de instanciar Dio o inyectarlo si usas un cliente global
  static final Dio _dio = Dio();

  // Reemplaza con la URL base real de tu API
  static final String _baseUrl =
      dotenv.env['API_URL'] ?? 'http://localhost:8000/api';

  /// Obtiene la lista de vendedores únicos a partir del endpoint de productos
  static Future<List<Vendor>> fetchVendors() async {
    try {
      final response = await _dio.get('$_baseUrl/productos');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> productsData = response.data['data'];

        final Map<String, dynamic> vendorJsons = {};
        final Map<String, Set<String>> vendorCategoriesMap = {};

        for (var productJson in productsData) {
          final vendorJson = productJson['vendedor'];
          if (vendorJson != null) {
            final String vendorId = vendorJson['id'].toString();

            // Guardamos el JSON del vendedor si es la primera vez que lo vemos
            vendorJsons.putIfAbsent(vendorId, () => vendorJson);

            // Extraemos las categorías de este producto específico
            final List? productCats = productJson['categorias'] as List?;
            if (productCats != null) {
              vendorCategoriesMap.putIfAbsent(vendorId, () => <String>{});
              for (var cat in productCats) {
                if (cat['nombre'] != null) {
                  vendorCategoriesMap[vendorId]!.add(cat['nombre'].toString());
                }
              }
            }
          }
        }

        // Construimos la lista final de Vendor inyectando las categorías recolectadas
        return vendorJsons.entries.map((entry) {
          final id = entry.key;
          final json = entry.value;
          return Vendor(
            id: id,
            name: json['nombre'] ?? 'Vendedor sin nombre',
            url:
                json['url'] ??
                "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
            rating: 4.5,
            description: json['carrera'] ?? 'Sin descripción disponible',
            categories: vendorCategoriesMap[id]?.toList() ?? [],
          );
        }).toList();
      } else {
        throw Exception('Error al obtener los productos');
      }
    } catch (e) {
      print('Error en fetchVendors: $e');
      return []; // Retornamos lista vacía en caso de error
    }
  }

  static Future<VendorDetail?> fetchVendorById(String id) async {
    try {
      // 1. Obtener TODOS los productos y filtrar por vendedor
      final productsResponse = await _dio.get('$_baseUrl/productos');
      List<dynamic> vendorProductsJson = [];

      if (productsResponse.statusCode == 200 &&
          productsResponse.data['success'] == true) {
        final List<dynamic> allProducts = productsResponse.data['data'];
        vendorProductsJson = allProducts
            .where((p) => p['id_vendedor'].toString() == id)
            .toList();
      }

      // Si no hay productos de este vendedor, no podemos extraer su información
      // (siguiendo la lógica de tu TS)
      if (vendorProductsJson.isEmpty) return null;

      // Extraemos la info del vendedor del primer producto
      final firstProduct = vendorProductsJson.first;
      final vendorJson = firstProduct['vendedor'];
      if (vendorJson == null) return null;

      // 2. Extraer categorías únicas de sus productos
      final Set<String> categoriasUnicas = {};
      for (var p in vendorProductsJson) {
        if (p['categorias'] != null) {
          for (var c in p['categorias']) {
            categoriasUnicas.add(c['nombre']);
          }
        }
      }

      // 3. Obtener reseñas del vendedor
      List<Review> reviews = [];
      try {
        final reviewsResponse = await _dio.get(
          '$_baseUrl/reviews/vendedores/$id',
        );
        // Suponiendo que la respuesta sigue el formato { success: true, data: [...] }
        if (reviewsResponse.statusCode == 200) {
          // Si tu API retorna un objeto con 'data', usa reviewsResponse.data['data']
          // Si retorna la lista directamente, usa reviewsResponse.data
          final List<dynamic> reviewsData =
              reviewsResponse.data['data'] ?? reviewsResponse.data;

          reviews = reviewsData.map((r) {
            final cliente = r['cliente'];
            final bool anonimo = r['anonimo'] == true || r['anonimo'] == 1;

            return Review(
              id: r['id'].toString(),
              userName: anonimo ? "Anónimo" : (cliente?['nombre'] ?? "Usuario"),
              userAvatar:
                  "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
              calificacion: (r['calificacion'] ?? 5).toDouble(),
              comentario: r['comentario'] ?? "",
              date: r['created_at'] ?? "",
            );
          }).toList();
        }
      } catch (e) {
        print("Aviso: No se pudieron obtener las reseñas del vendedor: $e");
        // Dejamos reviews como arreglo vacío
      }

      // 4. Calcular el promedio de calificación
      double rating = 5.0;
      if (reviews.isNotEmpty) {
        double sum = reviews.fold(0, (prev, curr) => prev + curr.calificacion);
        // Redondeamos y dejamos un decimal como máximo si lo deseas
        rating = sum / reviews.length;
      }

      // 5. Mapear los productos
      // Asumimos que tienes un factory constructor `Product.fromJson` en tu modelo Product
      List<Product> products = vendorProductsJson
          .map((p) => Product.fromJson(p))
          .toList();

      // 6. Retornar el objeto completo
      return VendorDetail(
        id: id,
        name: vendorJson['nombre'] ?? "Vendedor",
        url:
            vendorJson['url'] ??
            "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
        rating: rating,
        description: vendorJson['carrera'] ?? "",
        categories: categoriasUnicas.toList(),
        products: products,
        reviews: reviews,
      );
    } catch (e) {
      print("Error en fetchVendorById: $e");
      return null;
    }
  }
}
