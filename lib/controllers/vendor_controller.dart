// lib/controllers/vendor_controller.dart

import 'package:get/get.dart';
import '../models/vendor_model.dart';

class VendorController extends GetxController {
  final RxList<Vendor> allVendors = <Vendor>[].obs;
  final RxList<Vendor> filteredVendors = <Vendor>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadVendors();
  }

  void _loadVendors() {
    // Usamos el mismo generador de mock que tenías en el home
    final mocks = List.generate(
      10, // Generamos 10 vendedores para que haya lista
      (index) => Vendor(
        id: "v$index",
        name: index % 2 == 0
            ? "Tech Vendedor $index"
            : "Vendedor Destacado $index",
        image: "https://placehold.co/150x150/png",
        rating: 4.5,
        description:
            "Excelente servicio y calidad en cada uno de nuestros productos.",
        categories: ["Tecnología", "Accesorios"],
      ),
    );
    allVendors.value = mocks;
    filteredVendors.value = allVendors;
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
