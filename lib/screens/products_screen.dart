// lib/screens/products_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../widgets/product_card.dart';
import '../widgets/app_drawer.dart';

class ProductsScreen extends StatelessWidget {
  ProductsScreen({Key? key}) : super(key: key);

  // Inyectamos el controlador
  final ProductController controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Catálogo de Productos"),
        backgroundColor: Colors.blueGrey,
      ),
      drawer: const AppDrawer(currentRoute: 'products'),
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
                      hintText: "Buscar producto...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
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
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.white),
                    onPressed: controller.openFilterModal,
                  ),
                ),
              ],
            ),
          ),

          // === GRILLA DE PRODUCTOS ===
          Expanded(
            child: Obx(() {
              if (controller.filteredProducts.isEmpty) {
                return const Center(
                  child: Text("No se encontraron productos."),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                // Aquí sí usamos scrolleo normal porque no hay SingleChildScrollView
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, // 2 columnas para el catálogo
                  childAspectRatio:
                      0.65, // Ajusta según la altura de tu ProductCard
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: controller.filteredProducts.length,
                itemBuilder: (context, index) {
                  return ProductCard(
                    product: controller.filteredProducts[index],
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
