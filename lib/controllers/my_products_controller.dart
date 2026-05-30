import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api/product_api.dart';
import '../models/product_model.dart';
import 'auth_controller.dart';

class MyProductsController extends GetxController {
  final AuthController authController = Get.find<AuthController>();
  final RxBool isLoading = false.obs;
  final RxList<Product> myProducts = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyProducts();
  }

  Future<void> fetchMyProducts() async {
    final token = authController.token.value;
    if (token == null) return;

    isLoading.value = true;
    try {
      final products = await ProductApi.fetchMyProducts(token);
      myProducts.assignAll(products);
    } finally {
      isLoading.value = false;
    }
  }

  // Placeholders para funcionalidades futuras
  void editProduct(Product product) {
    Get.snackbar(
      "Editar",
      "Próximamente: Formulario para editar ${product.name}",
    );
    print("Editando producto ID: ${product.id}");
  }

  void deleteProduct(Product product) {
    Get.defaultDialog(
      title: "Eliminar Producto",
      middleText: "¿Estás seguro de que deseas eliminar ${product.name}?",
      onConfirm: () => Get.back(),
      textConfirm: "Eliminar",
      confirmTextColor: Colors.white,
    );
  }

  void addProduct() {
    Get.snackbar("Nuevo Producto", "Próximamente: Formulario de creación");
  }
}
