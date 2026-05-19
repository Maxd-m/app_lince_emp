// lib/api/product_api.dart

import '../models/product_model.dart';
import '../models/vendor_model.dart';

class ProductApi {
  // Base de datos simulada basada en tu wireframe
  static final List<Product> mockProducts = [
    Product(
      id: "1",
      name: "Mochila Urban Explorer",
      description:
          "Mochila resistente al agua ideal para estudiantes y viajeros. Cuenta con múltiples compartimentos, espacio para laptop de 15 pulgadas y diseño ergonómico para mayor comodidad durante todo el día.",
      price: 850.5,
      stock: 24,
      images: [
        "https://bunchobagels.com/wp-content/uploads/2024/09/placeholder.jpg",
        "https://bunchobagels.com/wp-content/uploads/2024/09/placeholder.jpg",
      ],
      vendor: Vendor(
        id: "v1",
        name: "Tech & Travel",
        image:
            "https://bunchobagels.com/wp-content/uploads/2024/09/placeholder.jpg",
        rating: 4.8,
        description:
            "Especialistas en accesorios para el día a día y viajes. Calidad garantizada.",
        categories: ["Viajes", "Accesorios", "Mochilas", "Impermeable"],
      ),
      reviews: [
        Review(
          id: "r1",
          userName: "Ana Gómez",
          userAvatar:
              "https://bunchobagels.com/wp-content/uploads/2024/09/placeholder.jpg",
          rating: 5,
          comment:
              "Excelente calidad. Los cierres se sienten muy resistentes y cabe todo lo de la universidad.",
          date: "2024-04-15",
        ),
      ],
    ),
    // Puedes agregar los productos 2 y 3 aquí de la misma forma...
  ];

  /// Simula el fetch de un producto por su ID
  /// Retorna un Future que resuelve con el Producto o null si no existe
  static Future<Product?> fetchProductById(String id) async {
    return Future.delayed(const Duration(milliseconds: 800), () {
      try {
        // Busca el primer producto que coincida, si no hay arroja un error que capturamos
        return mockProducts.firstWhere((p) => p.id == id);
      } catch (e) {
        return null;
      }
    });
  }
}
