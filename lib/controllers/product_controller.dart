// lib/controllers/product_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/product_model.dart';
import '../api/product_api.dart';
import '../models/categoria_model.dart';

class ProductController extends GetxController {
  final RxList<Product> allProducts = <Product>[].obs;
  final RxList<Product> filteredProducts = <Product>[].obs;
  final RxList<Categoria> categories = <Categoria>[].obs;
  final RxnString selectedCategoryId = RxnString();
  final RxString currentSearchQuery = ''.obs;
  final RxBool isLoading = false.obs; // Loader reactivo
  final _box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _loadCache();
    loadProducts();
    loadCategories();
  }

  void _loadCache() {
    final cached = _box.read('cached_products');
    if (cached != null) {
      final productos = (cached as List)
          .map((json) => Product.fromJson(json))
          .toList();
      allProducts.assignAll(productos);
      _applyFilters();
    }
  }

  Future<void> loadProducts() async {
    try {
      if (allProducts.isEmpty) isLoading.value = true;
      final productos = await ProductApi.fetchAllProducts();
      allProducts.assignAll(productos);
      _applyFilters();
    } catch (e) {
      Get.snackbar("Error", "No se pudo conectar con el servidor.");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadCategories() async {
    try {
      final cats = await ProductApi.fetchAllCategory();
      categories.assignAll(cats);
    } catch (e) {
      print("Error cargando categorías: $e");
    }
  }

  void search(String query) {
    currentSearchQuery.value = query;
    _applyFilters();
  }

  void selectCategory(String? categoryId) {
    selectedCategoryId.value = categoryId;
    _applyFilters();
  }

  void _applyFilters() {
    filteredProducts.value = allProducts.where((p) {
      final matchesSearch = p.name.toLowerCase().contains(
        currentSearchQuery.value.toLowerCase(),
      );
      final matchesCategory =
          selectedCategoryId.value == null ||
          p.categoria.any((c) => c.id == selectedCategoryId.value);
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void openFilterModal() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Filtrar por categoría",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Obx(
                () => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text("Todas"),
                      selected: selectedCategoryId.value == null,
                      onSelected: (_) {
                        selectCategory(null);
                        Get.back();
                      },
                    ),
                    ...categories.map(
                      (cat) => ChoiceChip(
                        label: Text(cat.name),
                        selected: selectedCategoryId.value == cat.id,
                        onSelected: (selected) {
                          selectCategory(selected ? cat.id : null);
                          Get.back();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: const Text("Cerrar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
