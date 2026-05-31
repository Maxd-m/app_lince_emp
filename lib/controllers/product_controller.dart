// lib/controllers/product_controller.dart

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/product_model.dart';
import '../api/product_api.dart';

class ProductController extends GetxController {
  final RxList<Product> allProducts = <Product>[].obs;
  final RxList<Product> filteredProducts = <Product>[].obs;
  final RxBool isLoading = false.obs; // Loader reactivo
  final _box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _loadCache();
    loadProducts();
  }

  void _loadCache() {
    final cached = _box.read('cached_products');
    if (cached != null) {
      final productos = (cached as List)
          .map((json) => Product.fromJson(json))
          .toList();
      allProducts.value = productos;
      filteredProducts.value = productos;
    }
  }

  Future<void> loadProducts() async {
    try {
      if (allProducts.isEmpty) isLoading.value = true;
      final productos = await ProductApi.fetchAllProducts();
      allProducts.value = productos;
      filteredProducts.value = productos;
    } catch (e) {
      Get.snackbar("Error", "No se pudo conectar con el servidor.");
    } finally {
      isLoading.value = false;
    }
  }

  void search(String query) {
    if (query.isEmpty) {
      filteredProducts.value = allProducts;
    } else {
      filteredProducts.value = allProducts
          .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void openFilterModal() {
    Get.snackbar("Filtros", "Próximamente: Opciones de filtrado avanzado");
  }
}
