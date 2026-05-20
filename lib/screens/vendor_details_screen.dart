// lib/screens/vendor_details_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/vendor_details_controller.dart';
import '../widgets/product_card.dart';
import '../widgets/review_card.dart';

class VendorDetailsScreen extends StatelessWidget {
  VendorDetailsScreen({Key? key}) : super(key: key);

  final VendorDetailsController controller = Get.put(VendorDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil del Vendedor"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final vendor = controller.vendor.value;
        if (vendor == null) {
          return const Center(
            child: Text(
              "Vendedor no encontrado",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Centramos la cabecera
            children: [
              // 1. CABECERA: Nombre y Avatar
              Text(
                vendor.name,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              CircleAvatar(
                radius: 80,
                backgroundColor: Theme.of(context).primaryColor,
                child: CircleAvatar(
                  radius: 76,
                  backgroundImage: NetworkImage(vendor.image),
                ),
              ),
              const SizedBox(height: 16),

              // 2. DESCRIPCIÓN
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  vendor.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade800,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),

              // 3. CATEGORÍAS
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Especializado en:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: vendor.categories.map((cat) {
                    return Chip(
                      label: Text(
                        cat,
                        style: TextStyle(color: Colors.blueGrey.shade800),
                      ),
                      backgroundColor: Colors.blueGrey.shade50,
                      side: BorderSide(color: Colors.blueGrey.shade200),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 32),

              // 4. PRODUCTOS DESTACADOS (Lista horizontal)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Productos destacados:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height:
                    320, // Altura fija para que el ListView horizontal funcione
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  scrollDirection: Axis.horizontal, // Scroll Horizontal
                  itemCount: vendor.products.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 240, // Ancho fijo para cada tarjeta en el carrusel
                      child: ProductCard(product: vendor.products[index]),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),

              // 5. RESEÑAS
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Reseñas:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: vendor.reviews.isNotEmpty
                      ? vendor.reviews
                            .map((r) => ReviewCard(review: r))
                            .toList()
                      : [
                          const Text(
                            "Este vendedor aún no tiene reseñas.",
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
