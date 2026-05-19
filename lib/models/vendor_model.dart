// lib/models/vendor_model.dart

import 'product_model.dart'; // Importamos Product y Review del archivo anterior

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
}

// Extendemos Vendor para la vista de detalle
class VendorDetail extends Vendor {
  final List<Product> products;
  final List<Review> reviews;

  VendorDetail({
    required String id,
    required String name,
    required String image,
    required double rating,
    required String description,
    required List<String> categories,
    required this.products,
    required this.reviews,
  }) : super(
         id: id,
         name: name,
         image: image,
         rating: rating,
         description: description,
         categories: categories,
       );
}
