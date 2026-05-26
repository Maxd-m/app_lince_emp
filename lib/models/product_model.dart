// lib/models/product_model.dart

import 'vendor_model.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final List<String> images;
  final Vendor vendor;
  final List<Review> reviews;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.images,
    required this.vendor,
    required this.reviews,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Mapeo de la lista de imágenes del backend
    final listImagenes = json['imagenes'] as List? ?? [];
    List<String> parsedImages = listImagenes
        .map((img) => img['url_imagen'] as String)
        .toList();

    // Si el producto no tiene imágenes, agregamos un placeholder
    if (parsedImages.isEmpty) {
      parsedImages.add(
        "https://bunchobagels.com/wp-content/uploads/2024/09/placeholder.jpg",
      );
    }

    // Mapeo de reseñas
    final listReviews = json['reviews'] as List? ?? [];
    List<Review> parsedReviews = listReviews
        .map((rev) => Review.fromJson(rev))
        .toList();

    return Product(
      id: json['id']
          .toString(), // Convertimos int a String para mantener tu modelo
      name: json['nombre'] ?? '',
      description: json['descripcion'] ?? '',
      price:
          double.tryParse(json['precio']?.toString() ?? '0') ??
          0.0, // De String a double
      stock: json['stock'] as int? ?? 0,
      images: parsedImages,
      vendor: Vendor.fromJson(json['vendedor'] ?? {}),
      reviews: parsedReviews,
    );
  }
}

class Review {
  final String id;
  final String userName;
  final String userAvatar;
  final double calificacion;
  final String comentario;
  final String date;

  Review({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.calificacion,
    required this.comentario,
    required this.date,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id']?.toString() ?? '',
      userName: json['user_name'] ?? 'Anónimo',
      userAvatar:
          json['user_avatar'] ??
          "https://bunchobagels.com/wp-content/uploads/2024/09/placeholder.jpg",
      calificacion:
          double.tryParse(json['calificacion']?.toString() ?? '0.0') ?? 0.0,
      comentario: json['comentario'] ?? '',
      date: json['created_at'] ?? '',
    );
  }
}
