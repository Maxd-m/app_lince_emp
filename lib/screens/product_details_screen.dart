// lib/screens/product_details_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_details_controller.dart';
import '../widgets/vendor_card.dart';
import '../widgets/review_card.dart';

class ProductDetailsScreen extends StatelessWidget {
  ProductDetailsScreen({Key? key}) : super(key: key);

  final ProductDetailsController controller = Get.put(
    ProductDetailsController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles del Producto"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final product = controller.product.value;
        if (product == null) {
          return const Center(
            child: Text(
              "Producto no encontrado",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          );
        }

        // Cálculo de estrellas promedio
        final averageRating = product.reviews.isNotEmpty
            ? (product.reviews.map((r) => r.rating).reduce((a, b) => a + b) /
                      product.reviews.length)
                  .toStringAsFixed(1)
            : "0";

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. IMAGEN PRINCIPAL
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(product.images.first),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 2. TÍTULO, PRECIO Y STOCK
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Stock: ${product.stock}",
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                  ),
                  Text(
                    "\$${product.price.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 3. BOTÓN AÑADIR AL CARRITO
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: controller.addToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Añadir al carrito",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // 4. DESCRIPCIÓN
              const Text(
                "Descripción",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                product.description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade800,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // 5. VENDIDO POR (Usa VendorCard que creamos antes)
              const Text(
                "Vendido por",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              VendorCard(vendor: product.vendor),
              const SizedBox(height: 32),

              // 6. RESEÑAS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Reseñas de clientes",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Chip(
                    label: Text(
                      "$averageRating / 5",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    avatar: const Icon(
                      Icons.star,
                      color: Colors.orange,
                      size: 18,
                    ),
                    backgroundColor: Colors.orange.shade100,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Evitamos ListView dentro de SingleChildScrollView usando spread operator o ListView(shrinkWrap:true)
              ...product.reviews
                  .map((review) => ReviewCard(review: review))
                  .toList(),

              if (product.reviews.isEmpty)
                const Text(
                  "Este producto aún no tiene reseñas.",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
            ],
          ),
        );
      }),
    );
  }
}
