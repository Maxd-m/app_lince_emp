// lib/controllers/venta_controller.dart

import 'package:get/get.dart';
import '../api/venta_api.dart';

class VentaController extends GetxController {
  var isLoading = false.obs;
  var ventas = <dynamic>[].obs;

  @override
  void onInit() {
    fetchVentas();
    super.onInit();
  }

  Future<void> fetchVentas() async {
    isLoading.value = true;
    try {
      final data = await VentaApi.fetchVentas();
      ventas.assignAll(data);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> completarVenta(int id) async {
    isLoading.value = true;
    try {
      final success = await VentaApi.completarVenta(id);
      if (success) {
        Get.snackbar(
          "Éxito",
          "Venta marcada como completada",
          snackPosition: SnackPosition.BOTTOM,
        );
        await fetchVentas(); // Recargar lista
      } else {
        Get.snackbar(
          "Error",
          "No se pudo actualizar el estado",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}
