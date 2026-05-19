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
}

class Review {
  final String id;
  final String userName;
  final String userAvatar;
  final double rating;
  final String comment;
  final String date;

  Review({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.comment,
    required this.date,
  });
}
