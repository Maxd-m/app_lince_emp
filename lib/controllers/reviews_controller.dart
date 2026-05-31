import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api/review_api.dart';
import 'auth_controller.dart';

class ReviewsController extends GetxController {
  final AuthController authController = Get.find<AuthController>();

  var isLoading = false.obs;
  var isProductView = true.obs; // true: productos, false: vendedores

  var productReviews = <dynamic>[].obs;
  var vendorReviews = <dynamic>[].obs;
  var purchases = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    final token = authController.token.value;
    if (token == null) return;

    isLoading.value = true;
    try {
      final results = await Future.wait([
        ReviewApi.fetchMyPurchases(token),
        ReviewApi.fetchMyProductReviews(token),
        ReviewApi.fetchMyVendorReviews(token),
      ]);

      purchases.assignAll(results[0]);
      productReviews.assignAll(results[1]);
      vendorReviews.assignAll(results[2]);
    } finally {
      isLoading.value = false;
    }
  }

  /// Filtra productos comprados que NO han sido reseñados aún
  List<Map<String, dynamic>> getPendingProducts() {
    final reviewedIds = productReviews
        .map((r) => r['id_producto'].toString())
        .toSet();
    final Map<String, Map<String, dynamic>> uniqueProducts = {};

    for (var purchase in purchases) {
      for (var detail in purchase['detalles'] ?? []) {
        final prod = detail['producto'];
        if (prod != null) {
          final id = prod['id'].toString();
          if (!reviewedIds.contains(id)) {
            uniqueProducts[id] = {'id': id, 'nombre': prod['nombre']};
          }
        }
      }
    }
    return uniqueProducts.values.toList();
  }

  /// Filtra vendedores a los que se les compró y NO han sido reseñados aún
  List<Map<String, dynamic>> getPendingVendors() {
    final reviewedIds = vendorReviews
        .map((r) => r['id_vendedor'].toString())
        .toSet();
    final Map<String, Map<String, dynamic>> uniqueVendors = {};

    for (var purchase in purchases) {
      for (var detail in purchase['detalles'] ?? []) {
        final vendor = detail['producto']?['vendedor'];
        if (vendor != null) {
          final id = vendor['id'].toString();
          if (!reviewedIds.contains(id)) {
            uniqueVendors[id] = {'id': id, 'nombre': vendor['nombre']};
          }
        }
      }
    }
    return uniqueVendors.values.toList();
  }

  Future<void> submitReview({
    required String id,
    required double rating,
    required String comment,
    required bool anonymous,
  }) async {
    final token = authController.token.value;
    if (token == null) return;

    isLoading.value = true;
    bool success = false;

    if (isProductView.value) {
      success = await ReviewApi.createProductReview(
        token: token,
        productId: int.parse(id),
        rating: rating,
        comment: comment,
        anonymous: anonymous,
      );
    } else {
      success = await ReviewApi.createVendorReview(
        token: token,
        vendorId: int.parse(id),
        rating: rating,
        comment: comment,
        anonymous: anonymous,
      );
    }

    if (success) {
      Get.snackbar(
        "Éxito",
        "Reseña creada correctamente",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      fetchAllData();
    } else {
      Get.snackbar("Error", "No se pudo crear la reseña");
    }
    isLoading.value = false;
  }
}
