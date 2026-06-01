// lib/screens/vendors_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/vendor_controller.dart';
import '../widgets/vendor_card.dart';
import '../widgets/app_drawer.dart';

class VendorsScreen extends StatelessWidget {
  VendorsScreen({Key? key}) : super(key: key);

  final VendorController controller = Get.put(VendorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nuestros Colaboradores"),
        backgroundColor: Colors.blueGrey,
      ),
      drawer: const AppDrawer(currentRoute: 'vendors'),
      body: Column(
        children: [
          // === BARRA DE BÚSQUEDA Y FILTRO ===
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) => controller.search(value),
                    decoration: InputDecoration(
                      hintText: "Buscar vendedor...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
          ),

          // En tu vendors_screen.dart
          Expanded(
            child: Obx(() {
              // 1. Mostrar loading mientras espera la API
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              // 2. Mostrar mensaje de vacío solo si terminó de cargar y no hay datos
              if (controller.filteredVendors.isEmpty) {
                return const Center(
                  child: Text("No se encontraron colaboradores."),
                );
              }

              // 3. Mostrar la lista real
              return ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: controller.filteredVendors.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return VendorCard(vendor: controller.filteredVendors[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
