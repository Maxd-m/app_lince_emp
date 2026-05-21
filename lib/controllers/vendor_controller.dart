// lib/controllers/vendor_controller.dart

import 'package:get/get.dart';
import '../models/vendor_model.dart';
import '../api/vendor_api.dart';

class VendorController extends GetxController {
  final RxList<Vendor> allVendors = <Vendor>[].obs;
  final RxList<Vendor> filteredVendors = <Vendor>[].obs;
  final RxBool isLoading = true.obs; // Agregamos un estado de carga

  @override
  void onInit() {
    super.onInit();
    _loadVendors();
  }

  Future<void> _loadVendors() async {
    isLoading.value = true;
    try {
      // Llamamos a la API real
      final vendors = await VendorApi.fetchVendors();
      allVendors.value = vendors;
      filteredVendors.value = allVendors;
    } catch (e) {
      print("Error cargando vendedores: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void search(String query) {
    if (query.isEmpty) {
      filteredVendors.value = allVendors;
    } else {
      filteredVendors.value = allVendors
          .where((v) => v.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}
