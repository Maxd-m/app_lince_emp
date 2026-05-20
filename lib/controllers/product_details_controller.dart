// lib/controllers/product_details_controller.dart

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../api/product_api.dart';

class ProductDetailsController extends GetxController {
  final RxBool isLoading = true.obs;
  final Rxn<Product> product = Rxn<Product>();

  @override
  void onInit() {
    super.onInit();
    // Recuperamos el ID pasado por argumentos al navegar: Get.to(() => ..., arguments: product.id)
    final String productId = Get.arguments as String? ?? "";
    if (productId.isNotEmpty) {
      fetchProduct(productId);
    } else {
      isLoading.value = false; // No hay ID
    }
  }

  Future<void> fetchProduct(String id) async {
    isLoading.value = true;
    try {
      final data = await ProductApi.fetchProductById(id);
      product.value = data;
    } finally {
      isLoading.value = false;
    }
  }

  void addToCart() {
    if (product.value != null) {
      // TODO: Añadir al CartController/Store

      // Mostrar el "Toast" de éxito
      Get.snackbar(
        "¡Éxito!",
        "Artículo añadido con éxito al carrito",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      );
    }
  }
}
