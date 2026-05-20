// lib/models/vendor_model.dart
import 'product_model.dart';

class Vendor {
  final String id;
  final String name;
  final String image;
  final double rating;
  final String description;
  final List<String> categories;

  Vendor({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.description,
    required this.categories,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id: json['id']?.toString() ?? '',
      name: json['nombre'] ?? 'Vendedor sin nombre',
      image:
          "https://bunchobagels.com/wp-content/uploads/2024/09/placeholder.jpg", // Default placeholder
      rating: 4.5, // Valor por defecto ya que no viene en tu JSON actual
      description:
          json['carrera'] ??
          'Sin descripción disponible', // Usamos la carrera como descripción
      categories: [],
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
    required super.image,
    required super.rating,
    required super.description,
    required super.categories,
    required this.products,
    required this.reviews,
  });
}
