import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';
import '../models/cart_item_model.dart';
import '../api/purchase_api.dart';

class CartController extends GetxController {
  // Lista reactiva de items en el carrito
  var items = <CartItem>[].obs;
  var isLoading = false.obs;

  void addProduct(Product product) {
    // Verificamos si el producto ya existe en el carrito
    int index = items.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      items[index].quantity++;
      items.refresh(); // Notifica a Obx que la lista cambió internamente
    } else {
      items.add(CartItem(product: product));
    }
  }

  void removeProduct(String productId) {
    items.removeWhere((item) => item.product.id == productId);
  }

  void updateQuantity(String productId, int delta) {
    int index = items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      items[index].quantity += delta;

      // Si la cantidad llega a 0 o menos, lo removemos
      if (items[index].quantity <= 0) {
        items.removeAt(index);
      } else {
        items.refresh();
      }
    }
  }

  double get total =>
      items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  void clearCart() {
    items.clear();
  }

  Future<void> checkout({
    required String lugar,
    required String tipo,
    int? idMetodoPago,
  }) async {
    if (items.isEmpty) return;

    isLoading.value = true;
    try {
      final List<Map<String, dynamic>> productos = items.map((item) {
        return {
          'id_producto': int.parse(item.product.id),
          'cantidad': item.quantity,
        };
      }).toList();

      final success = await PurchaseApi.createPurchase(
        lugar: lugar,
        tipo: tipo,
        productos: productos,
        id_metodo_de_pago: idMetodoPago,
      );

      if (success) {
        clearCart();
        Get.back(); // Cierra el modal de opciones de pago
        Get.snackbar(
          "Éxito",
          "Venta creada correctamente.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar("Error", "No se pudo procesar la venta");
      }
    } finally {
      isLoading.value = false;
    }
  }
}
