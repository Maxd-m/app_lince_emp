// lib/models/vendor_model.dart
import 'product_model.dart';

class Vendor {
  final String id;
  final String name;
  final String url;
  final double rating;
  final String description;
  final List<String> categories;

  Vendor({
    required this.id,
    required this.name,
    required this.url,
    required this.rating,
    required this.description,
    required this.categories,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    // Intentar parsear categorías si vienen en el JSON (como objetos con nombre o strings)
    var categoriesJson = json['categorias'] as List?;
    List<String> parsedCategories =
        categoriesJson
            ?.map((cat) {
              if (cat is Map) return cat['nombre']?.toString() ?? '';
              return cat.toString();
            })
            .where((name) => name.isNotEmpty)
            .toList() ??
        [];

    return Vendor(
      id: json['id']?.toString() ?? '',
      name: json['nombre'] ?? 'Vendedor sin nombre',
      url:
          json['url'] ??
          "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
      rating: 4.5, // Valor por defecto ya que no viene en tu JSON actual
      description:
          json['carrera'] ??
          'Sin descripción disponible', // Usamos la carrera como descripción
      categories: parsedCategories,
    );
  }
}

/// Clase extendida que incluye los detalles completos del vendedor
class VendorDetail extends Vendor {
  final List<Product> products;
  final List<Review> reviews;

  VendorDetail({
    required super.id,
    required super.name,
    required super.url,
    required super.rating,
    required super.description,
    required super.categories,
    required this.products,
    required this.reviews,
  });
}
