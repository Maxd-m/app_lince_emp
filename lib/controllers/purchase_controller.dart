import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/purchase_model.dart';
import '../api/purchase_api.dart';

class PurchaseController extends GetxController {
  final RxList<Purchase> purchases = <Purchase>[].obs;
  final RxBool isLoading = true.obs;
  final RxList<dynamic> paymentMethods = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPurchases();
  }

  Future<void> loadPurchases() async {
    isLoading.value = true;
    try {
      final data = await PurchaseApi.fetchPurchases();
      purchases.assignAll(data);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadPaymentMethods() async {
    try {
      final methods = await PurchaseApi.fetchPaymentMethods();
      paymentMethods.assignAll(methods);
    } catch (e) {
      print("Error cargando métodos de pago: $e");
    }
  }

  Future<void> pay(String purchaseId, int methodId) async {
    isLoading.value = true;
    try {
      final success = await PurchaseApi.payPurchase(purchaseId, methodId);
      if (success) {
        Get.snackbar(
          "Éxito",
          "Venta pagada correctamente.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await loadPurchases(); // Recargar la lista para ver el cambio de status
      } else {
        Get.snackbar("Error", "No se pudo procesar el pago");
      }
    } finally {
      isLoading.value = false;
    }
  }
}
