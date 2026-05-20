// lib/controllers/product_controller.dart

import 'package:get/get.dart';
import '../models/product_model.dart';
import '../api/product_api.dart'; // Tu API mock

class ProductController extends GetxController {
  // Lista original y lista filtrada (observables)
  final RxList<Product> allProducts = <Product>[].obs;
  final RxList<Product> filteredProducts = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadProducts();
  }

  void _loadProducts() {
    // Aquí cargarías los datos de tu backend. Por ahora usamos el mock.
    allProducts.value = ProductApi.mockProducts;
    filteredProducts.value = allProducts;
  }

  // Función para buscar productos
  void search(String query) {
    if (query.isEmpty) {
      filteredProducts.value = allProducts;
    } else {
      filteredProducts.value = allProducts
          .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  // Función para el botón de filtro (Placeholder)
  void openFilterModal() {
    // TODO: Implementar un BottomSheet con opciones avanzadas (precio, categoría)
    Get.snackbar("Filtros", "Próximamente: Opciones de filtrado avanzado");
  }
}
